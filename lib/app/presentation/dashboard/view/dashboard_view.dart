import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/enums/service_type.dart';
import 'package:service_dashboard/app/core/extensions/context/context_extension.dart';
import 'package:service_dashboard/app/core/extensions/widget/widget_extension.dart';
import 'package:service_dashboard/app/presentation/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:service_dashboard/app/presentation/dashboard/widgets/appbar/custom_app_bar_widget.dart';
import 'package:service_dashboard/app/presentation/dashboard/widgets/service_control_table_widget.dart';
import 'package:service_dashboard/app/presentation/dashboard/widgets/services_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardViewModel controller = Get.put(DashboardViewModel());

    return Scaffold(
      appBar: CustomAppBarWidget(
        onRefresh: () => controller.fetchServices(manualRefresh: true),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchServices(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (Get.width >= 600) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => controller.runningServices.isNotEmpty
                              ? ServicesWidget(
                                  services: controller.runningServices,
                                  serviceType: ServiceType.running,
                                  totalServiceCount: controller.runningServices.length +
                                      controller.failedServices.length,
                                )
                              : SizedBox.shrink(),
                        ),
                        Obx(
                          () => controller.failedServices.isNotEmpty
                              ? ServicesWidget(
                                  services: controller.failedServices,
                                  serviceType: ServiceType.failed,
                                  totalServiceCount: controller.runningServices.length +
                                      controller.failedServices.length,
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    );
                  } else {
                    return Obx(
                      () => Column(
                        children: [
                          controller.runningServices.isNotEmpty
                              ? ServicesWidget(
                                  services: controller.runningServices,
                                  serviceType: ServiceType.running,
                                  totalServiceCount: controller.runningServices.length +
                                      controller.failedServices.length,
                                )
                              : SizedBox.shrink(),
                          controller.runningServices.isNotEmpty &&
                                  controller.failedServices.isNotEmpty
                              ? SizedBox(height: context.pageHorizontal)
                              : SizedBox.shrink(),
                          controller.failedServices.isNotEmpty
                              ? ServicesWidget(
                                  services: controller.failedServices,
                                  serviceType: ServiceType.failed,
                                  totalServiceCount: controller.runningServices.length +
                                      controller.failedServices.length,
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    );
                  }
                },
              ),
              ServiceControlTableWidget().pOnly(top: context.pageHorizontal),
            ],
          ).pAll(context.pageHorizontal),
        ),
      ),
    );
  }
}
