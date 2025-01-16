import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/constants/app_color.dart';
import 'package:service_dashboard/app/core/constants/app_text_style.dart';
import 'package:service_dashboard/app/presentation/dashboard/view/dashboard_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Service Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColor.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.appbar,
          titleTextStyle: AppTextStyle.blackBold18,
        ),
      ),
      home: const DashboardView(),
    );
  }
}
