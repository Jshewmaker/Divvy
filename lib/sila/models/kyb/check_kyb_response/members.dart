import 'package:equatable/equatable.dart';

class Members extends Equatable {
  final String userHandle;
  final String firstName;
  final String lastName;
  final String role;
  final String details;
  final int ownershipStake;
  final String verificationStatus;
  final bool verificationRequired;
  final String verificationId;
  final String beneficialOwnerCertificationStatus;
  final String businessCertificationStatus;

  Members(
      {this.userHandle,
      this.firstName,
      this.lastName,
      this.role,
      this.details,
      this.ownershipStake,
      this.verificationStatus,
      this.verificationRequired,
      this.verificationId,
      this.beneficialOwnerCertificationStatus,
      this.businessCertificationStatus});

  factory Members.fromJson(Map<String, dynamic> json) {
    return Members(
      userHandle: json['user_handle'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      details: json['details'],
      ownershipStake: json['ownership_stake'],
      verificationStatus: json['verification_status'],
      verificationRequired: json['verification_required'],
      verificationId: json['verification_id'],
      beneficialOwnerCertificationStatus:
          json['beneficial_owner_certification_status'],
      businessCertificationStatus: json['business_certification_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_handle'] = this.userHandle;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['role'] = this.role;
    data['details'] = this.details;
    data['ownership_stake'] = this.ownershipStake;
    data['verification_status'] = this.verificationStatus;
    data['verification_required'] = this.verificationRequired;
    data['verification_id'] = this.verificationId;
    data['beneficial_owner_certification_status'] =
        this.beneficialOwnerCertificationStatus;
    data['business_certification_status'] = this.businessCertificationStatus;
    return data;
  }

  @override
  List<Object> get props => [
        this.userHandle,
        this.firstName,
        this.lastName,
        this.role,
        this.details,
        this.ownershipStake,
        this.verificationStatus,
        this.verificationRequired,
        this.verificationId,
        this.beneficialOwnerCertificationStatus,
        this.businessCertificationStatus
      ];
}
