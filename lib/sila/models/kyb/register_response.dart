import 'package:equatable/equatable.dart';

class KYBRegisterResponse extends Equatable {
  final String message;
  final String reference;
  final String status;

  const KYBRegisterResponse({
    this.message,
    this.reference,
    this.status,
  });

  @override
  List<Object> get props => [
        message,
        reference,
        status,
      ];

  static KYBRegisterResponse fromJson(dynamic json) {
    return KYBRegisterResponse(
      message: json['message'],
      reference: json['reference'],
      status: json['status'],
    );
  }
}
