import 'package:equatable/equatable.dart';

class Handle extends Equatable {
  final bool success;
  final String message;
  final String reference;
  final String status;
  final String verificationUUID;

  const Handle({this.success, this.message, this.reference, this.status, this.verificationUUID});

  @override
  List<Object> get props => [
        success,
        message,
        reference,
        status,
        verificationUUID,
      ];

  static Handle fromJson(dynamic json) {
    return Handle(
      success: json['success'],
      message: json['message'],
      reference: json['reference'],
      status: json['status'],
      verificationUUID: json['verification_uuid'],
    );
  }
}
