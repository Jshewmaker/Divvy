import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/get_transactions_response.dart';
import 'package:divvy/sila/models/models.dart';
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

  Future<RegisterResponse> checkHandle(String handle) async {
    final RegisterResponse response = await silaApiClient.checkHandle(handle);
    return response;
  }

  Future<RegisterResponse> register(String handle) async {
    UserModel user = await _firebaseService.getUserData();

    final RegisterResponse response =
        await silaApiClient.register(handle, user);
    return response;
  }

  Future<RegisterResponse> requestKYC() async {
    UserModel user = await _firebaseService.getUserData();

    final RegisterResponse response =
        await silaApiClient.requestKYC(user.silaHandle, user.privateKey);
    return response;
  }

  Future<CheckKycResponse> checkKYC() async {
    UserModel user = await _firebaseService.getUserData();

    final CheckKycResponse response =
        await silaApiClient.checkKYC(user.silaHandle, user.privateKey);
    return response;
  }

  Future<LinkAccountResponse> linkAccount(String plaidPublicToken) async {
    UserModel user = await _firebaseService.getUserData();

    final LinkAccountResponse response = await silaApiClient.linkAccount(
        user.silaHandle, user.privateKey, plaidPublicToken);
    return response;
  }

  Future<IssueSilaResponse> issueSila() async {
    UserModel user = await _firebaseService.getUserData();

    final IssueSilaResponse response =
        await silaApiClient.issueSila(user.silaHandle, user.privateKey);
    return response;
  }

  Future<GetSilaBalanceResponse> getSilaBalance() async {
    UserModel user = await _firebaseService.getUserData();

    final GetSilaBalanceResponse response =
        await silaApiClient.getSilaBalance(user.wallet);
    return response;
  }

  Future<GetTransactionsResponse> getTransactions() async {
    UserModel user = await _firebaseService.getUserData();

    final GetTransactionsResponse response =
        await silaApiClient.getTransactions(user.silaHandle, user.privateKey);
    return response;
  }

  Future<GetEntityResponse> getEntity() async {
    UserModel user = await _firebaseService.getUserData();

    final GetEntityResponse response =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);
    return response;
  }

  Future<UpdateUserInfo> updateEmail(String newEmail) async {
    UserModel user = await _firebaseService.getUserData();
    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updateEmail(
        user.silaHandle, user.privateKey, entity.emails[0].uuid, newEmail);
    return response;
  }

  Future<UpdateUserInfo> updatePhone(String newPhone) async {
    UserModel user = await _firebaseService.getUserData();

    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updatePhone(
        user.silaHandle, user.privateKey, entity.phones[0].uuid, newPhone);
    return response;
  }

  Future<UpdateUserInfo> updateIdentity(String newSSN) async {
    UserModel user = await _firebaseService.getUserData();
    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updateIdentity(
        user.silaHandle, user.privateKey, entity.identities[0].uuid, newSSN);
    return response;
  }

  Future<UpdateUserInfo> updateAddress(String newAddress) async {
    String field = 'city';
    UserModel user = await _firebaseService.getUserData();
    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updateAddress(
        user.silaHandle,
        user.privateKey,
        entity.addresses[0].uuid,
        field,
        newAddress);
    return response;
  }

  Future<UpdateUserInfo> updateEntity(String newPhone) async {
    String field = 'birthdate';
    UserModel user = await _firebaseService.getUserData();
    GetEntityResponse entity =
        await silaApiClient.getEntity(user.silaHandle, user.privateKey);

    final UpdateUserInfo response = await silaApiClient.updateEntity(
        user.silaHandle,
        user.privateKey,
        entity.phones[0].uuid,
        field,
        newPhone);
    return response;
  }
}
