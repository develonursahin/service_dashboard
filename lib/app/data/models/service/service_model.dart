import 'package:get/get.dart';
import 'package:service_dashboard/app/core/base/model/base_request_model.dart';
import 'package:service_dashboard/app/core/enums/service_status.dart';
import 'package:service_dashboard/app/data/models/device/device_model.dart';

class ServiceModel extends BaseModel {
  final int? id;
  int? failureCount;
  final String? name;
  final bool? status;
  final Rx<ServiceCheckStatus> serviceCheckStatus;
  final List<DeviceModel>? devices;
  String? lastChecked;

  ServiceModel({
    this.id,
    this.failureCount,
    this.name,
    this.status,
    this.lastChecked,
    this.devices,
    ServiceCheckStatus serviceCheckStatus = ServiceCheckStatus.normal,
  }) : serviceCheckStatus = serviceCheckStatus.obs;

  @override
  ServiceModel fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      devices: (json['devices'] as List).map((service) => DeviceModel().fromJson(service)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'devices': devices?.map((device) => device.toJson()).toList(),
    };
  }
}
