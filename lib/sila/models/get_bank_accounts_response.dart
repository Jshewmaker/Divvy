import 'package:equatable/equatable.dart';

class GetBankAccountsResponse extends Equatable {
  final String accountNumber;
  final String routingNumber;
  final String accountType;
  final String accountName;
  final String accountStatus;
  final bool active;
  final String accountLinkStatus;
  final double matchScore;
  final String accountOwnerName;
  final String entityName;

  const GetBankAccountsResponse(
      {this.accountLinkStatus,
      this.accountName,
      this.accountNumber,
      this.accountOwnerName,
      this.accountStatus,
      this.accountType,
      this.active,
      this.entityName,
      this.matchScore,
      this.routingNumber});

  @override
  List<Object> get props => [
        accountLinkStatus,
        routingNumber,
        accountName,
        accountNumber,
        accountOwnerName,
        accountStatus,
        accountType,
        active,
        entityName,
        matchScore,
      ];

  static GetBankAccountsResponse fromJson(dynamic json) {
    return GetBankAccountsResponse(
      accountLinkStatus: json['account_link_status'],
      accountNumber: json['account_number'],
      accountOwnerName: json['account_owner_name'],
      entityName: json['entity_name'],
      routingNumber: json['routing_number'],
      accountName: json['account_name'],
      matchScore: json['match_score'],
      active: json['active'],
      accountStatus: json['account_status'],
      accountType: json['account_type'],
    );
  }
}
