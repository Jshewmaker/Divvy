import 'package:equatable/equatable.dart';

class IssueSilaResponse extends Equatable {
  final String reference;
  final String message;
  final bool success;
  final String status;
  final String transactionID;
  final String descriptor;

  const IssueSilaResponse(
      {this.success,
      this.message,
      this.reference,
      this.status,
      this.transactionID,
      this.descriptor});

  @override
  List<Object> get props =>
      [success, message, reference, status, transactionID, descriptor];

  static IssueSilaResponse fromJson(dynamic json) {
    return IssueSilaResponse(
      success: json['success'],
      message: json['message'],
      reference: json['reference'],
      status: json['status'],
      transactionID: json['transaction_id'],
      descriptor: json['descriptor'],
    );
  }
}
