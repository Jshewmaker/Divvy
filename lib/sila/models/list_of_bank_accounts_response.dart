import 'package:divvy/sila/models/bank_accounts_entity.dart';
import 'package:equatable/equatable.dart';

class ListOfBankAccountsModel {
  final List<BankAccount> bankAccounts;

  ListOfBankAccountsModel({this.bankAccounts});

  factory ListOfBankAccountsModel.fromEntity(
      ListOfBankAccountEntities entities) {
    List<BankAccount> bankAccounts = [];
    bankAccounts =
        entities.bankAccounts.map((e) => BankAccount.fromEntity(e)).toList();

    return ListOfBankAccountsModel(bankAccounts: bankAccounts);
  }
}

class BankAccount extends Equatable {
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

  const BankAccount(
      {this.accountNumber,
      this.routingNumber,
      this.accountName,
      this.accountType,
      this.accountStatus,
      this.active,
      this.accountLinkStatus,
      this.matchScore,
      this.accountOwnerName,
      this.entityName});

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

  static BankAccount fromEntity(BankAccountEntity entity) {
    return BankAccount(
      accountNumber: entity.accountNumber,
      routingNumber: entity.routingNumber,
      accountName: entity.accountName,
      accountType: entity.accountType,
      accountStatus: entity.accountStatus,
      active: entity.active,
      accountLinkStatus: entity.accountLinkStatus,
      matchScore: entity.matchScore,
      accountOwnerName: entity.accountOwnerName,
      entityName: entity.entityName,
    );
  }
}


/*
[
  {
    "account_number": "*1234",
    "routing_number": "123456789",
    "account_name": "default",
    "account_type": "CHECKING",
    "account_status": "active",
    "active": true/false,
    "account_link_status": "microdeposit_automatically_verified",
    "match_score": 0.825,
    "account_owner_name": "Test User",
    "entity_name": "Test User",
  }
]
*/