import 'package:equatable/equatable.dart';

class LinkAccountResponse extends Equatable {
  final bool success;
  final String status;
  final String reference;
  final String message;
  final String accountName;

  const LinkAccountResponse(
      {this.success,
      this.message,
      this.reference,
      this.status,
      this.accountName});

  @override
  List<Object> get props => [
        success,
        message,
        reference,
        status,
        accountName,
      ];

  static LinkAccountResponse fromJson(dynamic json) {
    return LinkAccountResponse(
      success: json['success'],
      message: json['message'],
      reference: json['reference'],
      status: json['status'],
      accountName: json['account_name'],
    );
  }
}
