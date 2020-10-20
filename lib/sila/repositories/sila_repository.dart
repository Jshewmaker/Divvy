import 'package:divvy/sila/models/models.dart';
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
}
