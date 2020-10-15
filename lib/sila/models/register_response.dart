import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  final bool success;
  final String message;
  final String reference;
  final String status;
  final String verificationUUID;

  const RegisterResponse({this.success, this.message, this.reference, this.status, this.verificationUUID});

  @override
  List<Object> get props => [
        success,
        message,
        reference,
        status,
        verificationUUID,
      ];

  static RegisterResponse fromJson(dynamic json) {
    return RegisterResponse(
      success: json['success'],
      message: json['message'],
      reference: json['reference'],
      status: json['status'],
      verificationUUID: json['verification_uuid'],
    );
  }
}
