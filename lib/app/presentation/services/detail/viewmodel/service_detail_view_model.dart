import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/enums/loading_status.dart';
import 'package:service_dashboard/app/core/enums/service_path.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';
import 'package:service_dashboard/app/data/services/api_service.dart';

class ServicesDetailViewModel extends GetxController {
  final ApiService apiService = ApiService();
  final int serviceId;

  ServiceModel? service;
  Rx<LoadingStatus> loadingStatus = LoadingStatus.initial.obs;

  ServicesDetailViewModel({required this.serviceId});

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchService();
  }

  Future<void> fetchService() async {
    loadingStatus.value = LoadingStatus.loading;
    try {
      service = await apiService.getObjectData(
        objectModel: ServiceModel(),
        path: "${ServicePath.services.subUrl}/$serviceId",
      );

      loadingStatus.value = LoadingStatus.success;
    } catch (error) {
      log('Error fetching service.\nService ID: $serviceId\nError: $error');
      loadingStatus.value = LoadingStatus.error;
    } finally {
      update();
    }
  }
}
