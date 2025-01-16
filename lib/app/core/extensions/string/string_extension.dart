// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

extension StringExtension on String {
  bool get isEmail => contains("@") && contains(".");
  bool get isNotShort => length >= 4;
}

extension SvgExtension on String {
  Widget get toSvg => SvgPicture.asset(this);
  Widget toColorSvg({Color? color}) => SvgPicture.asset(this, color: color);
}

extension ImagesExtension on String {
  Widget get toImage => Image.asset(
        this,
        fit: BoxFit.fill,
      );
  AssetImage get toImageProvider => AssetImage(this);
}

extension LottieExtension on String {
  Widget get toLottie => Lottie.asset(this);
}

extension EmailValidateExtension on String {
  bool get emailValidate =>
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}

extension DateTimeExtensions on DateTime {
  // Tarih ve saat bilgisini "dd.MM.yyyy HH:mm:ss" formatında döndürür
  String toFormattedString({bool? isHour = false}) {
    return isHour == true
        ? "${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year.toString()} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}"
        : "${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year.toString()}";
  }
}

extension StringDateTimeExtensions on String {
  // Verilen tarih string'ini "dd.MM.yyyy HH:mm:ss" formatında döndürür
  String toFormattedDate({bool? isHour = false}) {
    // Tarih formatını "yyyy-MM-dd HH:mm:ss" olarak kabul ediyoruz
    DateTime? dateTime = DateTime.tryParse(this);

    // Eğer geçerli bir tarih değilse boş döneriz
    if (dateTime == null) return '';

    return isHour == true
        ? "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year.toString()} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}"
        : "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year.toString()}";
  }
}

extension StringHtmlExtension on String {
  String removeHtmlTags() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return replaceAll(exp, '');
  }
}

extension UpperCaseExtension on String {
  String get toUpperCaseString {
    return toUpperCase();
  }
}

extension TimeAgo on String {
  String toTimeAgo() {
    DateTime dateTime = DateTime.parse(this);
    Duration difference = DateTime.now().toUtc().difference(dateTime.toUtc());

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}d';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}sa';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}g';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}a';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }
}
