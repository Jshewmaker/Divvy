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

  Future<Handle> checkHandle(String handle) async {
    final Handle checkHandle = await silaApiClient.checkHandle(handle);
    return checkHandle;
  }



  Future<Handle> register(String handle) async {
    UserModel user = await _firebaseService.getUserData();

    final Handle registerHandle = await silaApiClient.register(handle, user);
    return registerHandle;
  }

  Future<Handle> requestKYC() async {
    UserModel user = await _firebaseService.getUserData();

    final Handle requestKYC = await silaApiClient.requestKYC(user.silaHandle, user.privateKey);
    return requestKYC;
  }
}
