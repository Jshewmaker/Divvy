import 'package:equatable/equatable.dart';

class RedeemSilaModel extends Equatable {
  final bool success;
  final String message;
  final String reference;
  final String status;
  final String transcationID;
  final String descriptor;

  const RedeemSilaModel(
      {this.success,
      this.message,
      this.reference,
      this.status,
      this.transcationID,
      this.descriptor});

  @override
  List<Object> get props =>
      [success, message, reference, status, transcationID, descriptor];

  static RedeemSilaModel fromJson(dynamic json) {
    return RedeemSilaModel(
      success: json['success'],
      message: json['message'],
      reference: json['reference'],
      status: json['status'],
      transcationID: json['transaction_id'],
      descriptor: json['descriptor'],
    );
  }
}
