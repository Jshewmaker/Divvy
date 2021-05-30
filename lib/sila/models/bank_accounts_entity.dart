import 'dart:convert';

import 'package:equatable/equatable.dart';

/*
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}
*/

class ListOfBankAccountEntities {
  final List<BankAccountEntity> bankAccounts;

  ListOfBankAccountEntities({this.bankAccounts});

  factory ListOfBankAccountEntities.fromJson(List<dynamic> parsedJson) {
    List<BankAccountEntity> accounts = [];
    accounts = parsedJson.map((i) => BankAccountEntity.fromJson(i)).toList();

    return new ListOfBankAccountEntities(bankAccounts: accounts);
  }
}

class BankAccountEntity extends Equatable {
  final String accountNumber;
  final String routingNumber;
  final String accountName;
  final String accountType;
  final String accountStatus;
  final bool active;
  final String accountLinkStatus;
  final double matchScore;
  final String accountOwnerName;
  final String entityName;

  const BankAccountEntity(
      this.accountNumber,
      this.routingNumber,
      this.accountName,
      this.accountType,
      this.accountStatus,
      this.active,
      this.accountLinkStatus,
      this.matchScore,
      this.accountOwnerName,
      this.entityName);

  @override
  List<Object> get props => [
        accountNumber,
        routingNumber,
        accountName,
        accountType,
        accountStatus,
        active,
        accountLinkStatus,
        matchScore,
        accountOwnerName,
        entityName
      ];

  static BankAccountEntity fromJson(Map<String, Object> json) {
    return BankAccountEntity(
      json["account_number"] as String,
      json["routing_number"] as String,
      json["account_name"] as String,
      json["account_type"] as String,
      json["account_status"] as String,
      json["active"] as bool,
      json["account_link_status"] as String,
      json["match_score"] as double,
      json["account_owner_name"] as String,
      json["entity_name"] as String,
    );
  }
}
