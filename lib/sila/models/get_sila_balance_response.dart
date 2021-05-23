import 'package:equatable/equatable.dart';

class GetSilaBalanceResponse extends Equatable {
  final bool success;
  final String status;
  final String address;
  final double silaBalance;

  const GetSilaBalanceResponse({
    this.success,
    this.status,
    this.address,
    this.silaBalance,
  });

  @override
  List<Object> get props => [
        success,
        status,
        address,
        silaBalance,
      ];

  static GetSilaBalanceResponse fromJson(dynamic json) {
    return GetSilaBalanceResponse(
      success: json['success'],
      status: json['status'],
      address: json['address'],
      silaBalance:
          json['sila_balance'] != null ? json['sila_balance'].toDouble() : null,
    );
  }
}
