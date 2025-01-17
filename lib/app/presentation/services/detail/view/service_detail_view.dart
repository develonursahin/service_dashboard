import 'package:flutter/material.dart';
import 'package:service_dashboard/app/core/constants/app_color.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/enums/loading_status.dart';
import 'package:service_dashboard/app/data/models/device/device_model.dart';
import 'package:service_dashboard/app/presentation/services/detail/viewmodel/service_detail_view_model.dart';

class ServiceDetailView extends StatelessWidget {
  final int serviceId;

  const ServiceDetailView({
    required this.serviceId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ServicesDetailViewModel controller =
        Get.put(ServicesDetailViewModel(serviceId: serviceId));

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
            controller.loadingStatus.value == LoadingStatus.loading
                ? ""
                : controller.service?.name ?? "Unknown Service",
          );
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.loadingStatus.value == LoadingStatus.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.loadingStatus.value == LoadingStatus.error) {
          return Center(child: Text("Error loading service"));
        }

        return RefreshIndicator(
          onRefresh: () async => await controller.fetchService(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: controller.service?.devices != null && controller.service!.devices!.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      itemCount: controller.service?.devices?.length,
                      itemBuilder: (context, index) {
                        List<DeviceModel> sortedDevices = List.from(controller.service!.devices!);
                        sortedDevices.sort((a, b) =>
                            ((b.status ?? false) ? 1 : 0).compareTo((a.status ?? false) ? 1 : 0));

                        DeviceModel device = sortedDevices[index];
                        return Card(
                          color: device.status == true ? AppColor.greenLight : AppColor.redLight,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: device.status == true
                              ? AppColor.greenDark.withOpacity(0.1)
                              : AppColor.red.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                device.name ?? "Bilinmeyen Cihaz",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(child: Text("Cihaz bulunamadı.")),
          ),
        );
      }),
    );
  }
}
