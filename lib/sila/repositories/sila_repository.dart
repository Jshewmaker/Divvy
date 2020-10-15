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
    final RegisterResponse checkHandle = await silaApiClient.checkHandle(handle);
    return checkHandle;
  }



  Future<RegisterResponse> register(String handle) async {
    UserModel user = await _firebaseService.getUserData();

    final RegisterResponse registerHandle = await silaApiClient.register(handle, user);
    return registerHandle;
  }

  Future<RegisterResponse> requestKYC() async {
    UserModel user = await _firebaseService.getUserData();

    final RegisterResponse requestKYC = await silaApiClient.requestKYC(user.silaHandle, user.privateKey);
    return requestKYC;
  }

  Future<CheckKycResponse> checkKYC() async {
    UserModel user = await _firebaseService.getUserData();

    final CheckKycResponse checkKyc = await silaApiClient.checkKYC(user.silaHandle, user.privateKey);
    return checkKyc;
  }
}
