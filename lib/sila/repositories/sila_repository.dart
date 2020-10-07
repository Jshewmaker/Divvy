import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';

class SilaRepository {
  final SilaApiClient silaApiClient;

  SilaRepository({@required this.silaApiClient})
      : assert(silaApiClient != null);

  Future<Handle> checkHandle(String handle) async {
    final Handle checkHandle = await silaApiClient.checkHandle(handle);
    return checkHandle;
  }

  Future getFirestoreUser() async {
    return Firestore.instance.collection('users').snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => User.fromEntity(UserEntity.fromSnapshot(doc)));
    });
  }

  Future<Handle> register(String handle) async {
    var firebaseService = FirebaseService();
    var user = await firebaseService.getUser();
    var data =
        await Firestore.instance.collection('users').document(user.uid).get();
    var data2 = User.fromEntity(UserEntity.fromSnapshot(data));
    // var user = await getFirestoreUser().

    final Handle registerHandle = await silaApiClient.register(handle, data2);
    return registerHandle;
  }
}
