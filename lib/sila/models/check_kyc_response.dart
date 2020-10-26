import 'package:equatable/equatable.dart';

class CheckKycResponse extends Equatable {
  final bool success;
  final String status;
  final String message;
  final String reference;
  final String entityType;
  final String verificationStatus;
  final List<dynamic> verificationHistory;
  final List<String> validKycLevels;

  CheckKycResponse(
      {this.success,
      this.status,
      this.message,
      this.reference,
      this.entityType,
      this.verificationStatus,
      this.verificationHistory,
      this.validKycLevels});

  factory CheckKycResponse.fromJson(Map<String, dynamic> json) {
    return CheckKycResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      reference: json['reference'],
      entityType: json['entity_type'],
      verificationStatus: json['verification_status'],
      verificationHistory: json['verification_history'] != null
          ? json['verification_history']
              .map((v) => new VerificationHistory.fromJson(v))
              .toList()
          : null,
      validKycLevels: json['valid_kyc_levels'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
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
    return data;
  }

  @override
  List<Object> get props => [
        this.success,
        this.status,
        this.message,
        this.reference,
        this.entityType,
        this.verificationStatus,
        this.verificationHistory,
        this.validKycLevels
      ];
}

class VerificationHistory extends Equatable {
  final String verificationId;
  final String verificationStatus;
  final String kycLevel;
  final int requestedAt;
  final int updatedAt;
  final List<String> tags;
  final double score;
  final String parentVerification;

  VerificationHistory(
      {this.verificationId,
      this.verificationStatus,
      this.kycLevel,
      this.requestedAt,
      this.updatedAt,
      this.tags,
      this.score,
      this.parentVerification});

  factory VerificationHistory.fromJson(Map<String, dynamic> json) {
    return VerificationHistory(
      verificationId: json['verification_id'],
      verificationStatus: json['verification_status'],
      kycLevel: json['kyc_level'],
      requestedAt: json['requested_at'],
      updatedAt: json['updated_at'],
      tags: json['tags'].cast<String>(),
      score: json['score'],
      parentVerification: json['parent_verification'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verification_id'] = this.verificationId;
    data['verification_status'] = this.verificationStatus;
    data['kyc_level'] = this.kycLevel;
    data['requested_at'] = this.requestedAt;
    data['updated_at'] = this.updatedAt;
    data['tags'] = this.tags;
    data['score'] = this.score;
    data['parent_verification'] = this.parentVerification;
    return data;
  }

  @override
  List<Object> get props => [
        this.verificationId,
        this.verificationStatus,
        this.kycLevel,
        this.requestedAt,
        this.updatedAt,
        this.tags,
        this.score,
        this.parentVerification
      ];
}
