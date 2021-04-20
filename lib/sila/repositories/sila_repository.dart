import 'package:divvy/sila/models/bank_account_balance_response.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/get_transactions_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/models/redeem_sila_model.dart';
import 'package:divvy/sila/models/transfer_sila_response.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';

class SilaRepository {
  final SilaApiClient silaApiClient;
  FirebaseAuth firebaseAuth;

  SilaRepository({@required this.silaApiClient}) {
    firebaseAuth = FirebaseAuth.instance;
    assert(silaApiClient != null);
  }

  ///Register user in SILA ecosystem
  Future<RegisterResponse> register() async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final RegisterResponse response = await silaApiClient.register(user.uid);
    return response;
  }

  ///Rquest KYC for registered SILA user
  Future<RegisterResponse> requestKYC() async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final RegisterResponse response = await silaApiClient.requestKYC(user.uid);
    return response;
  }

  ///Check Status of KYC in SILA ecosystem
  Future<CheckKycResponse> checkKYC() async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final CheckKycResponse response = await silaApiClient.checkKYC(user.uid);
    return response;
  }

  ///Link bank account to user's SILA Account
  Future<LinkAccountResponse> linkAccount(String plaidPublicToken) async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final LinkAccountResponse response =
        await silaApiClient.linkAccount(user.uid, plaidPublicToken);
    return response;
  }

  ///Transfer money from user's bank account to SILA account.
  ///
  ///Dollars to SILA is 0.01 = 1 SILA. $784.98 = 78498 SILA
  Future<IssueSilaResponse> issueSila(double amount) async {
    FirebaseUser user = await firebaseAuth.currentUser();
    amount = amount * 100;
    final IssueSilaResponse response =
        await silaApiClient.issueSila(user.uid, amount);
    return response;
  }

  ///Get SILA wallet balance
  Future<GetSilaBalanceResponse> getSilaBalance() async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final GetSilaBalanceResponse response =
        await silaApiClient.getSilaBalance(user.uid);
    return response;
  }

  Future<GetSilaBalanceResponse> getProjectBalance(String wallet) async {
    final GetSilaBalanceResponse response =
        await silaApiClient.getSilaBalance(wallet);
    return response;
  }

  ///Get transactions from SILA wallet
  ///
  ///This will return any transaction that deal with: Adding money to the wallet,
  ///removing money from the wallet, and transfering money from wallet to wallet
  Future<GetTransactionsResponse> getTransactions() async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final GetTransactionsResponse response =
        await silaApiClient.getTransactions(user.uid);
    return response;
  }

  ///Return User info that is stored in SILA ecosystem
  Future<GetEntityResponse> getEntity() async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final GetEntityResponse response =
        await silaApiClient.getEntity(user.uid, false);
    return response;
  }

  ///Update email  in SILA ecosystem
  Future<UpdateUserInfo> updateEmail(String newEmail) async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final UpdateUserInfo response =
        await silaApiClient.updateEmail(user.uid, newEmail);
    return response;
  }

  ///Update phone number in SILA ecosystem
  Future<UpdateUserInfo> updatePhone(String newPhone) async {
    FirebaseUser user = await firebaseAuth.currentUser();
    final UpdateUserInfo response =
        await silaApiClient.updatePhone(user.uid, newPhone);
    return response;
  }

  ///You can only update SSN before KYC is processed.
  ///
  ///Only call this if you are writing a flow where KYC hasnt been process yet
  ///or KYC has failed
  Future<UpdateUserInfo> updateIdentity(String newSSN) async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final UpdateUserInfo response =
        await silaApiClient.updateIdentity(user.uid, newSSN);
    return response;
  }

  ///Update address in SILA ecosystem
  Future<UpdateUserInfo> updateAddress(Map<String, String> newAddress) async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final UpdateUserInfo response =
        await silaApiClient.updateAddress(user.uid, newAddress);
    return response;
  }

  ///You can only update this info before KYC is processed
  ///
  ///Update user's first name, last name, or birthday.
  Future<UpdateUserInfo> updateEntity(Map<String, String> entity) async {
    FirebaseUser user = await firebaseAuth.currentUser();

    final UpdateUserInfo response =
        await silaApiClient.updateEntity(user.uid, entity);
    return response;
  }

  Future<RedeemSilaModel> redeemSila(int amount) async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return await silaApiClient.redeemSila(user.uid, amount);
  }

  Future<TransferSilaResponse> transferSila(
      double amount, String destinationHandle, String descriptor) async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return await silaApiClient.transferSila(
        user.uid, amount, destinationHandle, descriptor);
  }
}
