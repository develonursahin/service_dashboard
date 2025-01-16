import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/constants/app_secrets.dart';
import 'package:service_dashboard/app/core/enums/service_path.dart';
import 'package:service_dashboard/app/core/manager/network_manager.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';
import 'package:service_dashboard/app/presentation/dashboard/viewmodel/dashboard_view_model.dart';

class MailService extends GetxService {
  final DashboardViewModel dashboardViewModel = Get.find();

  /// E-posta gönderme fonksiyonu
  ///
  /// [subject]: E-postanın konusu
  /// [message]: E-postanın gövde metni
  /// [ccList]: CC yapılacak e-posta adresleri
  /// [failedServices]: Hatalı servislerin listesi
  Future<void> sendFailureAlert({
    required String subject,
    required String message,
    List<String>? ccList,
    required List<ServiceModel> failedServices,
  }) async {
    try {
      // Hatalı servisleri ve cihazları düz metin olarak oluştur
      final textContent = _generateTextContent(failedServices);

      // E-posta içeriği
      final emailBody = '''
${AppSecrets.companyName} - Hatalı Servis/Cihaz Uyarısı

Son ${dashboardViewModel.maxFailureCount} denemede aşağıdaki listede yer alan servis/cihazlara erişilememektedir:

$textContent

Saygılarımızla,
${AppSecrets.mailSign}
''';

      final response = await NetworkManager.instance.dio.post(
        ServicePath.sendMail.subUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: jsonEncode({
          'to': AppSecrets.receiverMail,
          'cc': ccList ?? [],
          'subject': subject,
          'text': emailBody,
          'username': AppSecrets.senderMail,
          'password': AppSecrets.senderPassword,
        }),
      );

      if (response.statusCode == 200) {
        log('E-posta başarıyla gönderildi!');
      } else {
        log('E-posta gönderilirken hata oluştu: ${response.statusCode}');
      }
    } catch (e) {
      log('E-posta gönderme hatası: $e');
    }
  }

  String _generateTextContent(List<ServiceModel> failedServices) {
    final StringBuffer textBuffer = StringBuffer();

    for (var service in failedServices) {
      if (service.status == false) {
        textBuffer.writeln('Servis: ${service.name ?? 'Bilinmiyor'} - Servis Hatalı');
        textBuffer.writeln();
      } else {
        final failedDevices = service.devices?.where((device) => device.status == false) ?? [];

        if (failedDevices.isNotEmpty) {
          textBuffer.writeln('Servis: ${service.name ?? 'Bilinmiyor'}');
          for (var device in failedDevices) {
            textBuffer.writeln(' - Cihaz: ${device.name ?? 'Bilinmiyor'}');
          }
          textBuffer.writeln();
        }
      }
    }
    return textBuffer.toString();
  }
}
