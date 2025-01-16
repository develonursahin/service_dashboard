import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/constants/app_secrets.dart';
import 'package:service_dashboard/app/core/enums/loading_status.dart';
import 'package:service_dashboard/app/core/enums/service_path.dart';
import 'package:service_dashboard/app/core/enums/service_status.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';
import 'package:service_dashboard/app/data/models/start/start_model.dart';
import 'package:service_dashboard/app/data/services/api_service.dart';
import 'package:service_dashboard/app/data/services/mail_service.dart';

class DashboardViewModel extends GetxController {
  final ApiService apiService = ApiService();
  final MailService mailService = MailService();

  var runningServices = <ServiceModel>[].obs;
  var failedServices = <ServiceModel>[].obs;
  StartModel? services;

  Rx<LoadingStatus> loadingStatus = LoadingStatus.initial.obs;
  Rx<DateTime?> fetchedTime = Rx<DateTime?>(null);
  Timer? _timer;
  int refreshTime = 10;
  final int maxFailureCount = 3;

  var tempFailureCount = <int, int>{};
  var servicesToNotify = <int>{};

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchServices();

    _timer = Timer.periodic(Duration(seconds: refreshTime), (_) {
      fetchServices();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchServices({bool manualRefresh = false}) async {
    loadingStatus.value = LoadingStatus.loading;

    if (manualRefresh) {
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: refreshTime), (_) {
        fetchServices();
      });
    }

    try {
      services = await apiService.getObjectData(
        objectModel: StartModel(),
        path: ServicePath.services.subUrl,
      );

      runningServices.value = services?.runningServices ?? [];
      failedServices.value = services?.failedServices ?? [];
      fetchedTime.value = DateTime.now();

      loadingStatus.value = LoadingStatus.success;

      checkRepeatedFailures();
    } catch (error) {
      log('Error fetching services: $error');
      loadingStatus.value = LoadingStatus.error;
    } finally {
      update();
    }
  }

  Future<void> checkRepeatedFailures() async {
    for (var service in failedServices) {
      tempFailureCount[service.id!] = (tempFailureCount[service.id!] ?? 0) + 1;

      if (tempFailureCount[service.id!]! >= maxFailureCount &&
          !servicesToNotify.contains(service.id!)) {
        servicesToNotify.add(service.id!);
      }
    }

    for (var service in runningServices) {
      if (tempFailureCount.containsKey(service.id)) {
        tempFailureCount.remove(service.id); 
      }
    }

    if (servicesToNotify.isNotEmpty) {
      log(servicesToNotify.length.toString());

      await mailService.sendFailureAlert(
        subject: "${AppSecrets.companyName} - Hatalı Servis/Cihaz Uyarısı",
        message:
            "Son $maxFailureCount denemede aşağıdaki listede yer alan servis/cihazlara erişilememektedir.",
        ccList: [AppSecrets.receiverMail],
        failedServices:
            failedServices.where((service) => servicesToNotify.contains(service.id)).toList(),
      );

      for (var id in servicesToNotify.toList()) {
        tempFailureCount.remove(id); 
        servicesToNotify.remove(id); 
      }
    }
    update();
  }

  Future<void> checkService(int serviceId) async {
    final service = failedServices.firstWhere((s) => s.id == serviceId);
    if (service.serviceCheckStatus.value == ServiceCheckStatus.loading) return;

    service.serviceCheckStatus.value = ServiceCheckStatus.loading;
    service.lastChecked = DateTime.now().toString();
    update();

    log("Checking service: $serviceId");

    final isServiceRunning = await apiService.checkService(serviceId);

    if (isServiceRunning) {
      service.serviceCheckStatus.value = ServiceCheckStatus.success;
      await Future.delayed(const Duration(seconds: 2));
      failedServices.remove(service);
      runningServices.add(service);
    } else {
      service.serviceCheckStatus.value = ServiceCheckStatus.blinking;
      await Future.delayed(const Duration(seconds: 2));
      service.serviceCheckStatus.value = ServiceCheckStatus.normal;
    }

    update();
    log("Service check complete: $serviceId");
  }
}
