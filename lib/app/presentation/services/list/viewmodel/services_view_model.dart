import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/enums/loading_status.dart';
import 'package:service_dashboard/app/core/enums/service_path.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';
import 'package:service_dashboard/app/data/services/api_service.dart';
import 'package:service_dashboard/app/core/enums/service_type.dart';

class ServicesViewModel extends GetxController {
  final ApiService apiService = ApiService();
  final ServiceType serviceType;

  var services = <ServiceModel>[].obs;
  Rx<LoadingStatus> loadingStatus = LoadingStatus.initial.obs;

  ServicesViewModel({required this.serviceType});

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchServices();
  }

  Future<void> fetchServices() async {
    loadingStatus.value = LoadingStatus.loading;
    try {
      String path = serviceType == ServiceType.running
          ? ServicePath.runningServices.subUrl
          : ServicePath.failedServices.subUrl;

      services.value = await apiService.getListData(
        objectModel: ServiceModel(),
        path: path,
      );

      loadingStatus.value = LoadingStatus.success;
    } catch (error) {
      log('Error fetching services: $error');
      loadingStatus.value = LoadingStatus.error;
    } finally {
      update();
    }
  }
}
