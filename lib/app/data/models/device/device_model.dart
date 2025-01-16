import 'package:service_dashboard/app/core/base/model/base_request_model.dart';

class DeviceModel extends BaseModel {
  final int? id;
  final String? name;
  final int? serviceId;
  final bool? status;

  DeviceModel({
    this.id,
    this.name,
    this.serviceId,
    this.status,
  });

  @override
  DeviceModel fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'],
      serviceId: json['serviceId'],
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serviceId': serviceId,
      'status': status,
    };
  }
}
