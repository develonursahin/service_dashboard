import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/constants/app_color.dart';
import 'package:service_dashboard/app/core/constants/app_secrets.dart';
import 'package:service_dashboard/app/core/constants/app_text_style.dart';
import 'package:service_dashboard/app/core/enums/loading_status.dart';
import 'package:service_dashboard/app/core/extensions/context/context_extension.dart';
import 'package:service_dashboard/app/core/extensions/string/string_extension.dart';
import 'package:service_dashboard/app/core/extensions/widget/widget_extension.dart';
import 'package:service_dashboard/app/presentation/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:service_dashboard/app/presentation/dashboard/widgets/appbar/countdown_widget.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({
    super.key,
    this.onRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50);

  final dynamic Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final DashboardViewModel dashboardViewModel = Get.find();
    return Obx(
      () => AppBar(
        title: Text(
          "${AppSecrets.companyName} - Servisler",
          style: AppTextStyle.whiteBold20.copyWith(
            shadows: [
              Shadow(
                offset: Offset(0, 0),
                blurRadius: 24,
                color: Colors.white.withOpacity(0.8),
              ),
            ],
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: AppColor.white,
          backgroundImage: const AssetImage("assets/icons/app_icon_white.png"),
        ).paddingAll(10),
        actions: [
          dashboardViewModel.loadingStatus.value == LoadingStatus.loading
              ? const CircularProgressIndicator(color: AppColor.white)
              : Icon(
                  Icons.refresh,
                  color: AppColor.white,
                ).pOnly(right: context.pageHorizontal).gestureDetector(onTap: onRefresh)
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.secondary,
                AppColor.secondary,
                AppColor.primary,
                AppColor.primary,
                AppColor.primary,
                AppColor.primary,
                AppColor.primary,
                AppColor.secondary,
                AppColor.secondary
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: AppColor.background,
            width: double.infinity,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColor.secondary, borderRadius: context.borderVerticalBottom28Radius),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Obx(() {
                final fetchedTime = dashboardViewModel.fetchedTime.value;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      fetchedTime != null
                          ? "Son Kontrol: ${fetchedTime.toFormattedString(isHour: true)}"
                          : "Veriler henüz yüklenmedi.",
                      style: AppTextStyle.whiteBold14,
                      textAlign: TextAlign.center,
                    ),
                    CountdownWidget(
                      fetchedTime: dashboardViewModel.fetchedTime.value,
                      refreshTime: dashboardViewModel.remainingTimeInSeconds.value,
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
