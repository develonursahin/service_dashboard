import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:service_dashboard/app/core/constants/app_color.dart';
import 'package:service_dashboard/app/core/constants/app_text_style.dart';
import 'package:service_dashboard/app/core/enums/service_type.dart';
import 'package:service_dashboard/app/core/extensions/widget/widget_extension.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';
import 'package:service_dashboard/app/presentation/services/list/view/services_view.dart';

class ServiceIndicator extends StatelessWidget {
  final ServiceType serviceType;
  final List<ServiceModel> services;
  final int totalServices;

  const ServiceIndicator({
    super.key,
    required this.serviceType,
    required this.services,
    required this.totalServices,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CircularPercentIndicator(
        radius: 30,
        lineWidth: 8,
        animation: true,
        percent: services.length / totalServices,
        center: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              services.length.toString(),
              style: AppTextStyle.blackBold24,
            ),
            Text(
              " /$totalServices",
              style: AppTextStyle.greyDarkRegular18,
            ),
          ],
        ),
        footer: Text(serviceType == ServiceType.running ? "Çalışan Servisler" : "Hatalı Servisler",
            style: AppTextStyle.blackBold18),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: serviceType == ServiceType.running ? AppColor.greenDark : AppColor.red,
      ).gestureDetector(
        onTap: () => Get.to(() => ServicesView(serviceType: serviceType)),
      ),
    );
  }
}
