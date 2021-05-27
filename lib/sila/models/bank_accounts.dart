import 'package:equatable/equatable.dart';

class BankAccountBalanceResponse extends Equatable {
  final bool success;
  final String status;
  final int availableBalance;
  final int currentBalance;
  final String maskedAccountNumber;
  final String routingNumber;
  final String accountName;

  const BankAccountBalanceResponse({
    this.success,
    this.status,
    this.availableBalance,
    this.currentBalance,
    this.maskedAccountNumber,
    this.routingNumber,
    this.accountName,
  });

  @override
  List<Object> get props => [
        success,
        status,
        availableBalance,
        currentBalance,
        maskedAccountNumber,
        routingNumber,
        accountName,
      ];

  static BankAccountBalanceResponse fromJson(dynamic json) {
    return BankAccountBalanceResponse(
      success: json['success'],
      status: json['status'],
      availableBalance: json['available_balance'],
      currentBalance: json['current_balance'],
      maskedAccountNumber: json['masked_account_number'],
      routingNumber: json['routing_number'],
      accountName: json['account_name'],
    );
  }
}
