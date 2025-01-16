import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';

class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget({
    super.key,
    required this.services,
    required this.totalServiceCount,
    required this.color,
  });

  final RxList<ServiceModel> services;
  final int totalServiceCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 45,
          height: 45,
          child: CircularProgressIndicator(
            value: services.isNotEmpty ? services.length / totalServiceCount : 0.0,
            backgroundColor: Colors.grey.shade300,
            strokeCap: StrokeCap.round,
            color: color,
            strokeWidth: 8,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              services.length.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(
              '/$totalServiceCount',
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
