import 'package:service_dashboard/app/core/base/model/base_request_model.dart';
import 'package:service_dashboard/app/data/models/service/service_model.dart';

class StartModel extends BaseModel {
  List<ServiceModel>? failedServices;
  List<ServiceModel>? runningServices;

  StartModel({
    this.failedServices,
    this.runningServices,
  });

  @override
  StartModel fromJson(Map<String, dynamic> json) {
    return StartModel(
      failedServices: json['failedServices'] != null
          ? List<ServiceModel>.from(json['failedServices'].map((v) => ServiceModel().fromJson(v)))
          : [],
      runningServices: json['runningServices'] != null
          ? List<ServiceModel>.from(json['runningServices'].map((v) => ServiceModel().fromJson(v)))
          : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'failedServices': failedServices?.map((v) => v.toJson()).toList(),
      'runningServices': runningServices?.map((v) => v.toJson()).toList(),
    };
  }
}
