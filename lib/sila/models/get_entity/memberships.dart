import 'package:equatable/equatable.dart';

class Memberships extends Equatable {
  final String businessHandle;
  final String entityName;
  final String role;
  final String details;
  final double ownershipStake;
  final String certificationToken;

  Memberships(
      {this.businessHandle,
      this.entityName,
      this.role,
      this.details,
      this.ownershipStake,
      this.certificationToken});

  factory Memberships.fromJson(Map<String, dynamic> json) {
    return Memberships(
      businessHandle: json['business_handle'],
      entityName: json['entity_name'],
      role: json['role'],
      details: json['details'],
      ownershipStake: json['ownership_stake'],
      certificationToken: json['certification_token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_handle'] = this.businessHandle;
    data['entity_name'] = this.entityName;
    data['role'] = this.role;
    data['details'] = this.details;
    data['ownership_stake'] = this.ownershipStake;
    data['certification_token'] = this.certificationToken;
    return data;
  }

  @override
  List<Object> get props => [
        this.businessHandle,
        this.entityName,
        this.role,
        this.details,
        this.ownershipStake,
        this.certificationToken
      ];
}
