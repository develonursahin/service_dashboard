import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/constants/app_color.dart';
import 'package:service_dashboard/app/core/constants/app_text_style.dart';
import 'package:service_dashboard/app/core/enums/service_type.dart';
import 'package:service_dashboard/app/core/extensions/context/context_extension.dart';
import 'package:service_dashboard/app/core/extensions/widget/widget_extension.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';
import 'package:service_dashboard/app/presentation/dashboard/widgets/circular_progress_widget.dart';
import 'package:service_dashboard/app/presentation/services/view/services_view.dart';

class ServicesWidget extends StatelessWidget {
  final RxList<ServiceModel> services;
  final int totalServiceCount;
  final ServiceType serviceType;

  const ServicesWidget({
    super.key,
    required this.services,
    required this.totalServiceCount,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return Container(
      constraints: BoxConstraints(
        maxWidth: services.length == totalServiceCount || services.isEmpty
            ? (Get.width - (context.pageHorizontal * 2))
            : Get.width >= 600
                ? (Get.width / 2) - context.pageHorizontal * 2
                : Get.width,
      ),
      padding: context.heighPadding,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: context.border12Radius,
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(serviceType == ServiceType.running ? "Çalışan Servisler" : "Hatalı Servisler",
                  style: AppTextStyle.blackBold18),
              CircularProgressWidget(
                services: services,
                color: serviceType == ServiceType.running ? AppColor.greenDark : AppColor.red,
                totalServiceCount: totalServiceCount,
              ),
            ],
          ),
          services.isNotEmpty
              ? SizedBox(
                  height: 55,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: services.length,
                      separatorBuilder: (context, index) => SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        ServiceModel service = services[index];
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: serviceType == ServiceType.running
                                  ? AppColor.greenDark
                                  : AppColor.red,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            service.name ?? "Bilinmiyor",
                            style: AppTextStyle.blackBold14,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Text(serviceType == ServiceType.failed
                      ? "Hatalı servis bulunamadı."
                      : "Çalışan servis bulunamadı."),
                ),
          services.isNotEmpty
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Tümünü gör",
                    style: AppTextStyle.blackBold12,
                  ).gestureDetector(
                    onTap: () => Get.to(() => ServicesView(serviceType: serviceType)),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
