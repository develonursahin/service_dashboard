import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountdownController extends GetxController {
  var remainingTime = Duration.zero.obs;

  void updateRemainingTime(DateTime? fetchedTime, int refreshTime) {
    if (fetchedTime != null) {
      remainingTime.value =
          fetchedTime.add(Duration(seconds: refreshTime)).difference(DateTime.now());
    } else {
      remainingTime.value = Duration.zero;
    }
  }
}

class CountdownWidget extends StatefulWidget {
  final DateTime? fetchedTime;
  final int refreshTime;

  const CountdownWidget({
    super.key,
    required this.fetchedTime,
    required this.refreshTime,
  });

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  final CountdownController _controller = Get.put(CountdownController());

  @override
  void initState() {
    super.initState();

    _controller.updateRemainingTime(widget.fetchedTime, widget.refreshTime);

    _timer = Timer.periodic(const Duration(seconds: 1), _updateRemainingTime);
  }

  void _updateRemainingTime(Timer timer) {
    _controller.updateRemainingTime(widget.fetchedTime, widget.refreshTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String timeString = _controller.remainingTime.value.isNegative
          ? "Kontrol zamanı geldi!"
          : "${_controller.remainingTime.value.inMinutes}:${(_controller.remainingTime.value.inSeconds % 60).toString().padLeft(2, '0')}";

      return Text(
        widget.fetchedTime != null ? "Sonraki Kontrol: $timeString" : "Veriler henüz yüklenmedi.",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        textAlign: TextAlign.center,
      );
    });
  }
}
