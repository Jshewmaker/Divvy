import 'package:equatable/equatable.dart';
import "verification_history.dart";
import "members.dart";

class CheckKybResponse extends Equatable {
  final String status;
  final String message;
  final String reference;
  final String entityType;
  final String verificationStatus;
  final List<VerificationHistory> verificationHistory;
  final List<String> validKycLevels;
  final String certificationStatus;
  final List<dynamic> certificationHistory;
  final List<Members> members;

  CheckKybResponse(
      {this.status,
      this.message,
      this.reference,
      this.entityType,
      this.verificationStatus,
      this.verificationHistory,
      this.validKycLevels,
      this.certificationStatus,
      this.certificationHistory,
      this.members});

  factory CheckKybResponse.fromJson(Map<String, dynamic> json) {
    return CheckKybResponse(
      status: json['status'],
      message: json['message'],
      reference: json['reference'],
      entityType: json['entity_type'],
      verificationStatus: json['verification_status'],
      verificationHistory: json['verification_history'] != null
          ? json['verification_history']
              .map<VerificationHistory>(
                  (v) => new VerificationHistory.fromJson(v))
              .toList()
          : null,
      validKycLevels: json['valid_kyc_levels'].cast<String>(),
      certificationStatus: json['certification_status'],
      certificationHistory: json['certification_history'],
      members: json['members'] != null
          ? json['members']
              .map<Members>((v) => new Members.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['reference'] = this.reference;
    data['entity_type'] = this.entityType;
    data['verification_status'] = this.verificationStatus;
    if (this.verificationHistory != null) {
      data['verification_history'] =
          this.verificationHistory.map((v) => v.toJson()).toList();
    }
    data['valid_kyc_levels'] = this.validKycLevels;
    data['certification_status'] = this.certificationStatus;
    if (this.certificationHistory != null) {
      data['certification_history'] =
          this.certificationHistory.map((v) => v.toJson()).toList();
    }
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object> get props => [
        this.status,
        this.message,
        this.reference,
        this.entityType,
        this.verificationStatus,
        this.verificationHistory,
        this.validKycLevels,
        this.certificationStatus,
        this.certificationHistory,
        this.members
      ];
}
