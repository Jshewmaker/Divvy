import 'package:equatable/equatable.dart';

class CertifyBusinessOwnerResponse extends Equatable {
  final bool success;
  final String status;
  final String message;

  const CertifyBusinessOwnerResponse({
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

  static CertifyBusinessOwnerResponse fromJson(dynamic json) {
    return CertifyBusinessOwnerResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
    );
  }
}
