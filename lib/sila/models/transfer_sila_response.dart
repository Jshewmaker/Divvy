import 'package:equatable/equatable.dart';

class TransferSilaResponse extends Equatable {
  final bool success;
  final String message;
  final String reference;
  final String status;
  final String destinationAddress;
  final String transactionsID;
  final String descriptor;

  const TransferSilaResponse(
      {this.success,
      this.message,
      this.reference,
      this.status,
      this.destinationAddress,
      this.transactionsID,
      this.descriptor});

  @override
  List<Object> get props => [
        success,
        message,
        reference,
        status,
        destinationAddress,
        transactionsID,
        descriptor,
      ];

  static TransferSilaResponse fromJson(dynamic json) {
    return TransferSilaResponse(
      success: json['success'],
      message: json['message'],
      reference: json['reference'],
      status: json['status'],
      destinationAddress: json['destination_address'],
      transactionsID: json['transaction_id'],
      descriptor: json['descriptor'],
    );
  }
}
