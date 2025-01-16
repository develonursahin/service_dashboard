import 'package:flutter/material.dart';
import 'package:service_dashboard/app/core/constants/app_color.dart';
import 'package:service_dashboard/app/core/enums/service_type.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';
import 'package:service_dashboard/app/presentation/services/viewmodel/services_view_model.dart';

class ServicesView extends StatelessWidget {
  final ServiceType serviceType;

  const ServicesView({
    required this.serviceType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ServicesViewModel controller = Get.put(ServicesViewModel(serviceType: serviceType));

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceType == ServiceType.running ? "Çalışan Servisler" : "Hatalı Servisler"),
        centerTitle: true,
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async => await controller.fetchServices(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              ServiceModel service = controller.services[index];
              return Card(
                color: serviceType == ServiceType.running ? AppColor.greenLight : AppColor.redLight,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: serviceType == ServiceType.running
                    ? AppColor.greenDark.withOpacity(0.1)
                    : AppColor.red.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      service.name ?? "Unknown Service",
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
        );
      }),
    );
  }
}
