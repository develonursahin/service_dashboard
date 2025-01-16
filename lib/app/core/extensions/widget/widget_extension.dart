import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ExpansionTileExtension on ExpansionTile {
  Widget removeDivider() => Builder(builder: (context) {
        return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent), child: this);
      });
}

extension SizedBoxExtension on Widget {
  SizedBox sized({double? width, double? height}) => SizedBox(
        height: height,
        width: width,
        child: this,
      );
}

extension OnTapExtension on Widget {
  GestureDetector gestureDetector({
    Function()? onTap,
    String? buttonTitle,
    BuildContext? context,
  }) {
    return GestureDetector(
      onTap: () async {
        if (onTap != null) {
          onTap();
        }
      },
      child: this,
    );
  }
}

extension PaddingExtension on Widget {
  Padding pAll(double val) => Padding(
        padding: EdgeInsets.all(val),
        child: this,
      );

  Padding pOnly({double? top, double? bottom, double? left, double? right}) => Padding(
        padding: EdgeInsets.only(
            top: top ?? 0.0, bottom: bottom ?? 0.0, left: left ?? 0.0, right: right ?? 0.0),
        child: this,
      );
  Padding pSymmetric({double? horizontal, double? vertical}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal ?? 0.0, vertical: vertical ?? 0.0),
        child: this,
      );
  Padding pPage() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 52.0),
        child: this,
      );

  Padding pOnlyTop() => Padding(
        padding: EdgeInsets.only(top: Get.height * 0.07),
        child: this,
      );
  Padding pConstTop() => Padding(
        padding: EdgeInsets.only(top: Get.height * 0.02),
        child: this,
      );
  Padding pConstBottomWithBottomBar() => Padding(
        padding: EdgeInsets.only(bottom: Get.height * 0.16),
        child: this,
      );
  Padding pConstBottom() => Padding(
        padding: EdgeInsets.only(bottom: Get.height * 0.03),
        child: this,
      );
}

extension AlignmentExtension on Widget {
  Align align({AlignmentGeometry alignment = Alignment.center}) => Align(
        alignment: alignment,
        child: this,
      );
  Align center() => Align(
        alignment: Alignment.center,
        child: this,
      );
}
