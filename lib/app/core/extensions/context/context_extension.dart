import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension PaddingExtension on BuildContext {
  double get kZero => 0.0;
  // EdgeInsets get pagePadding =>
  //     EdgeInsets.all(SizeConstant.instance.pagePadding);

  EdgeInsets get zeroPadding => EdgeInsets.zero;
  EdgeInsets get normalPadding => EdgeInsets.all(normalVal);
  EdgeInsets get lowPadding => EdgeInsets.all(lowVal);
  EdgeInsets get heighPadding => EdgeInsets.all(heighVal);
  double get normalVal => 8.0;
  double get heighVal => 14.0;
  double get lowVal => 4.0;
  double get pageHorizontal => 16.0;
  EdgeInsets topPadding() => EdgeInsets.only(top: Get.height * 0.02);
  EdgeInsets bottomBarBottomPadding() => const EdgeInsets.only(bottom: 80);
  EdgeInsets bottomPadding() => EdgeInsets.only(bottom: Get.height * 0.03);
  EdgeInsets dynamicAllPadding(double value) => EdgeInsets.all(value);
  EdgeInsets dynamicSymmetricPadding(double? horizontal, double? vertical) =>
      EdgeInsets.symmetric(horizontal: horizontal ?? 0.0, vertical: vertical ?? kZero);
  EdgeInsets dynamicOnlyPadding({double? top, double? bottom, double? right, double? left}) =>
      EdgeInsets.only(
          bottom: bottom ?? kZero, top: top ?? kZero, left: left ?? kZero, right: right ?? kZero);
}

extension BorderRadiusExtension on BuildContext {
  BorderRadius get border4Radius => BorderRadius.circular(4.0);
  BorderRadius get border8Radius => BorderRadius.circular(8.0);
  BorderRadius get border10Radius => BorderRadius.circular(10.0);
  BorderRadius get border12Radius => BorderRadius.circular(12.0);
  BorderRadius get border14Radius => BorderRadius.circular(14.0);
  BorderRadius get border16Radius => BorderRadius.circular(16.0);
  BorderRadius get border18Radius => BorderRadius.circular(18.0);
  BorderRadius get border20Radius => BorderRadius.circular(20.0);
  BorderRadius get border22Radius => BorderRadius.circular(22.0);
  BorderRadius get border24Radius => BorderRadius.circular(24.0);
  BorderRadius get border26Radius => BorderRadius.circular(26.0);
  BorderRadius get border28Radius => BorderRadius.circular(28.0);
  BorderRadius get border30Radius => BorderRadius.circular(30.0);
  BorderRadius get border36Radius => BorderRadius.circular(36.0);
  BorderRadius get border40Radius => BorderRadius.circular(40.0);
  BorderRadius get border46Radius => BorderRadius.circular(46.0);
  //Vertical Top
  BorderRadius get borderVerticalTop10Radius =>
      const BorderRadius.vertical(top: Radius.circular(10.0));
  BorderRadius get borderVerticalTop12Radius =>
      const BorderRadius.vertical(top: Radius.circular(12.0));
  BorderRadius get borderVerticalTop15Radius =>
      const BorderRadius.vertical(top: Radius.circular(15.0));
  BorderRadius get borderVerticalTop28Radius =>
      const BorderRadius.vertical(top: Radius.circular(28.0));
  //Vertical Bottom
  BorderRadius get borderVerticalBottom10Radius =>
      const BorderRadius.vertical(bottom: Radius.circular(10.0));
  BorderRadius get borderVerticalBottom12Radius =>
      const BorderRadius.vertical(bottom: Radius.circular(12.0));
  BorderRadius get borderVerticalBottom15Radius =>
      const BorderRadius.vertical(bottom: Radius.circular(15.0));
  BorderRadius get borderVerticalBottom28Radius =>
      const BorderRadius.vertical(bottom: Radius.circular(28.0));
}

extension MediaQuerySizeExtension on BuildContext {
  Size get mediaQuery => MediaQuery.of(this).size;
  double get colorPaletteHeight => mediaQuery.height * 0.045;
  double get height => mediaQuery.height;
  double get width => mediaQuery.width;
  double get searchTextHeight => height * 0.05;
  double dynamicWidth(double val) => width * val;
  double dynamicHeight(double val) => height * val;
}

extension DurationExtension on BuildContext {
  Duration get lowDuration => const Duration(milliseconds: 300);
  Duration get mediumDuration => const Duration(seconds: 1);
  Duration get normalDuration => const Duration(seconds: 2);
  Duration get heighDuration => const Duration(seconds: 3);
}
