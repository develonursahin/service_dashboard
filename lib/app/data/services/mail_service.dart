import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/core/constants/app_secrets.dart';
import 'package:service_dashboard/app/core/enums/service_path.dart';
import 'package:service_dashboard/app/core/extensions/string/string_extension.dart';
import 'package:service_dashboard/app/core/manager/network_manager.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';

class MailService extends GetxService {
  Future<void> sendFailureAlert({
    required String subject,
    required String message,
    List<String>? ccList,
    required List<ServiceModel> failedServices,
  }) async {
    try {
      final htmlContent = _generateHtmlContent(failedServices);
      final pdfData = await _generatePdf(failedServices);

      final dateTime = DateTime.now();
      final formattedDate = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
      final formattedTime = "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

      final emailBody = '''
<!DOCTYPE html>
<html>
<head>
  <style>
    table {
      border-collapse: collapse;
      width: 100%;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 8px;
    }
    th {
      background-color: #f4f4f4;
      text-align: left;
    }
    .header, .footer {
      text-align: center;
      font-size: 14px;
    }
    .footer {
      font-size: 12px;
      color: #888;
    }
    .title {
      font-size: 18px;
      font-weight: bold;
    }
  </style>
</head>
<body>
  <div class="header">
    <p class="title">${AppSecrets.companyName} - Hatalı Servis Uyarısı</p>
    <p>Tarih: $formattedDate | Saat: $formattedTime</p>
  </div>
  <p>Son denemelerde aşağıdaki listede yer alan servis/cihazlara erişilememektedir:</p>
  $htmlContent
  <div class="footer">
    <p>Saygılarımızla,<br>${AppSecrets.mailSign}</p>
  </div>
</body>
</html>
''';

      final response = await NetworkManager.instance.dio.post(
        ServicePath.sendMail.subUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          'to': AppSecrets.receiverMail,
          'cc': ccList ?? [],
          'subject': subject,
          'html': emailBody,
          'username': AppSecrets.senderMail,
          'password': AppSecrets.senderPassword,
          'attachments': [
            {
              'filename': 'HataliServisler.pdf',
              'content': base64Encode(pdfData),
            }
          ]
        },
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

  Future<Uint8List> _generatePdf(List<ServiceModel> failedServices) async {
    final pdf = pw.Document();

    final font = await pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Tarih: ${DateTime.now().toFormattedString(isHour: true)}',
                    style: pw.TextStyle(font: font),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                '${AppSecrets.companyName} - Hatalı Servis Uyarısı',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Servisler', 'Cihazlar', 'Durum'],
                data: failedServices.expand((service) {
                  final failedDevices =
                      service.devices?.where((device) => device.status == false).toList() ?? [];

                  if (service.status == false) {
                    return [
                      [service.name ?? 'Bilinmiyor', '-', 'Servis Hatalı']
                    ];
                  }

                  if (failedDevices.isEmpty) {
                    return [
                      [service.name ?? 'Bilinmiyor', '-', 'Servis Hatalı']
                    ];
                  }

                  List<List<String>> rows = [];
                  rows.add([
                    service.name ?? 'Bilinmiyor',
                    failedDevices.first.name ?? '-',
                    'Cihaz Hatalı',
                  ]);

                  for (var i = 1; i < failedDevices.length; i++) {
                    rows.add([
                      '',
                      failedDevices[i].name ?? '-',
                      'Cihaz Hatalı',
                    ]);
                  }

                  return rows;
                }).toList(),
                headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(font: font),
                border: pw.TableBorder.all(
                  color: PdfColors.black,
                  width: 1,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Saygılarımızla,', style: pw.TextStyle(fontSize: 12, font: font)),
              pw.Text(AppSecrets.mailSign, style: pw.TextStyle(fontSize: 12, font: font)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  String _generateHtmlContent(List<ServiceModel> failedServices) {
    final StringBuffer htmlBuffer = StringBuffer();

    htmlBuffer.writeln('<table>');
    htmlBuffer.writeln('<tr><th>Servisler</th><th>Cihazlar</th><th>Durum</th></tr>');

    for (var service in failedServices) {
      if (service.status == false) {
        htmlBuffer.writeln(
            '<tr><td>${service.name ?? 'Bilinmiyor'}</td><td>-</td><td>Servis Hatalı</td></tr>');
      } else {
        final failedDevices =
            service.devices?.where((device) => device.status == false).toList() ?? [];
        if (failedDevices.isNotEmpty) {
          htmlBuffer.writeln(
              '<tr><td rowspan="${failedDevices.length}">${service.name ?? 'Bilinmiyor'}</td>'
              '<td>${failedDevices.first.name ?? 'Bilinmiyor'}</td>'
              '<td>Cihaz Hatalı</td></tr>');

          for (var i = 1; i < failedDevices.length; i++) {
            htmlBuffer.writeln(
                '<tr><td>${failedDevices[i].name ?? 'Bilinmiyor'}</td><td>Cihaz Hatalı</td></tr>');
          }
        }
      }
    }

    htmlBuffer.writeln('</table>');
    return htmlBuffer.toString();
  }
}
