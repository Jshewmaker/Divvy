import 'package:equatable/equatable.dart';

class VerificationHistory extends Equatable {
  final String verificationId;
  final String verificationStatus;
  final String kycLevel;
  final int requestedAt;
  final int updatedAt;
  final List<Null> reasons;
  final List<String> tags;
  final double score;
  final String parentVerification;

  VerificationHistory(
      {this.verificationId,
      this.verificationStatus,
      this.kycLevel,
      this.requestedAt,
      this.updatedAt,
      this.reasons,
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
      score: json['score'] as double,
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
        this.reasons,
        this.tags,
        this.score,
        this.parentVerification
      ];
}
