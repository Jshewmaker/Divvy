import 'package:equatable/equatable.dart';

class CertifyBeneficialOwnerResponse extends Equatable {
  final bool success;
  final String status;
  final String message;

  const CertifyBeneficialOwnerResponse({
    this.success,
    this.status,
    this.message,
  });

  @override
  List<Object> get props => [
        success,
        status,
        message,
      ];

  static CertifyBeneficialOwnerResponse fromJson(dynamic json) {
    return CertifyBeneficialOwnerResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
    );
  }
}
