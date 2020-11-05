import 'package:equatable/equatable.dart';

class GetBusinessTypeResponse extends Equatable {
  final bool success;
  final String status;
  final List<dynamic> businessTypes;

  GetBusinessTypeResponse({this.success, this.status, this.businessTypes});

  factory GetBusinessTypeResponse.fromJson(Map<String, dynamic> json) {
    return GetBusinessTypeResponse(
      success: json['success'],
      status: json['status'],
      businessTypes: json['business_types'] != null
          ? json['business_types']
              .map((v) => new BusinessTypes.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    if (this.businessTypes != null) {
      data['business_types'] =
          this.businessTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object> get props => [this.success, this.status, this.businessTypes];
}

class BusinessTypes extends Equatable {
  final String uuid;
  final String name;
  final String label;
  final bool requiresCertification;

  BusinessTypes({this.uuid, this.name, this.label, this.requiresCertification});

  factory BusinessTypes.fromJson(Map<String, dynamic> json) {
    return BusinessTypes(
      uuid: json['uuid'],
      name: json['name'],
      label: json['label'],
      requiresCertification: json['requires_certification'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['label'] = this.label;
    data['requires_certification'] = this.requiresCertification;
    return data;
  }

  @override
  List<Object> get props =>
      [this.uuid, this.name, this.label, this.requiresCertification];
}
