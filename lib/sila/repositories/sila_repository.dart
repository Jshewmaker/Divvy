import 'package:divvy/sila/models/bank_account_balance_response.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/get_transactions_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/models/redeem_sila_model.dart';
import 'package:divvy/sila/models/transfer_sila_response.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';

class SilaRepository {
  final SilaApiClient silaApiClient;
  FirebaseService _firebaseService;

  SilaRepository({@required this.silaApiClient}) {
    _firebaseService = FirebaseService();
    assert(silaApiClient != null);
  }

  /// Check if user handle is avaible in SILA ecosystem
  Future<RegisterResponse> checkHandle(String handle) async {
    final RegisterResponse response = await silaApiClient.checkHandle(handle);
    return response;
  }

  ///Register user in SILA ecosystem
  Future<RegisterResponse> register(String handle) async {
    UserModel user = await _firebaseService.getUserData();

    final RegisterResponse response =
        await silaApiClient.register(handle, user);
    return response;
  }

  ///Rquest KYC for registered SILA user
  Future<RegisterResponse> requestKYC() async {
    UserModel user = await _firebaseService.getUserData();

    final RegisterResponse response =
        await silaApiClient.requestKYC(user.silaHandle, user.privateKey);
    return response;
  }

  ///Check Status of KYC in SILA ecosystem
  Future<CheckKycResponse> checkKYC() async {
    UserModel user = await _firebaseService.getUserData();

    final CheckKycResponse response =
        await silaApiClient.checkKYC(user.silaHandle, user.privateKey);
    return response;
  }

  ///Link bank account to user's SILA Account
  Future<LinkAccountResponse> linkAccount(String plaidPublicToken) async {
    UserModel user = await _firebaseService.getUserData();

    final LinkAccountResponse response = await silaApiClient.linkAccount(
        user.silaHandle, user.privateKey, plaidPublicToken);
    return response;
  }

  Future<BankAccountBalanceResponse> getBankAccountBalance() async {
    UserModel user = await _firebaseService.getUserData();

    final BankAccountBalanceResponse response = await silaApiClient
        .getBankAccountBalance(user.silaHandle, user.privateKey);
    return response;
  }

  ///Transfer money from user's bank account to SILA account.
  ///
  ///Dollars to SILA is 0.01 = 1 SILA. $784.98 = 78498 SILA
  Future<IssueSilaResponse> issueSila(double amount) async {
    UserModel user = await _firebaseService.getUserData();
    amount = amount * 100;
    final IssueSilaResponse response =
        await silaApiClient.issueSila(user.silaHandle, user.privateKey, amount);
    return response;
  }

  ///Get SILA wallet balance
  Future<GetSilaBalanceResponse> getSilaBalance() async {
    UserModel user = await _firebaseService.getUserData();

    final GetSilaBalanceResponse response =
        await silaApiClient.getSilaBalance(user.wallet);
    return response;
  }

  ///Get transactions from SILA wallet
  ///
  ///This will return any transaction that deal with: Adding money to the wallet,
  ///removing money from the wallet, and transfering money from wallet to wallet
  Future<GetTransactionsResponse> getTransactions() async {
    UserModel user = await _firebaseService.getUserData();

    final GetTransactionsResponse response =
        await silaApiClient.getTransactions(user.silaHandle, user.privateKey);
    return response;
  }

  ///Return User info that is stored in SILA ecosystem
  Future<GetEntityResponse> getEntity() async {
    UserModel user = await _firebaseService.getUserData();

    final GetEntityResponse response =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);
    return response;
  }

  ///Update email  in SILA ecosystem
  Future<UpdateUserInfo> updateEmail(String newEmail) async {
    UserModel user = await _firebaseService.getUserData();
    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updateEmail(
        user.silaHandle, user.privateKey, entity.emails[0].uuid, newEmail);
    return response;
  }

  ///Update phone number in SILA ecosystem
  Future<UpdateUserInfo> updatePhone(String newPhone) async {
    UserModel user = await _firebaseService.getUserData();

    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updatePhone(
        user.silaHandle, user.privateKey, entity.phones[0].uuid, newPhone);
    return response;
  }

  ///You can only update SSN before KYC is processed.
  ///
  ///Only call this if you are writing a flow where KYC hasnt been process yet
  ///or KYC has failed
  Future<UpdateUserInfo> updateIdentity(String newSSN) async {
    UserModel user = await _firebaseService.getUserData();
    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updateIdentity(
        user.silaHandle, user.privateKey, entity.identities[0].uuid, newSSN);
    return response;
  }

  ///Update address in SILA ecosystem
  Future<UpdateUserInfo> updateAddress(Map<String, String> newAddress) async {
    UserModel user = await _firebaseService.getUserData();
    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updateAddress(
        user.silaHandle, user.privateKey, entity.addresses[0].uuid, newAddress);
    return response;
  }

  ///You can only update this info before KYC is processed
  ///
  ///Update user's first name, last name, or birthday.
  Future<UpdateUserInfo> updateEntity(Map<String, String> entity) async {
    UserModel user = await _firebaseService.getUserData();

    final UpdateUserInfo response = await silaApiClient.updateEntity(
        user.silaHandle, user.privateKey, entity);
    return response;
  }

  Future<RedeemSilaModel> redeemSila(int amount) async {
    UserModel user = await _firebaseService.getUserData();
    return await silaApiClient.redeemSila(user, amount);
  }

  Future<TransferSilaResponse> transferSila(UserModel sender, double amount,
      String receiverHandle, String transferMessage) async {
    return await silaApiClient.transferSila(
        sender, amount, receiverHandle, transferMessage);
  }
}
