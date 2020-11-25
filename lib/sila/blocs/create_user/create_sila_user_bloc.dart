import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/sila/models/check_kyc_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:divvy/sila/blocs/blocs.dart';
import 'create_sila_user.dart';
import 'package:divvy/sila/models/register_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class CreateSilaUserBloc
    extends Bloc<CreateSilaUserEvent, CreateSilaUserState> {
  final SilaRepository silaRepository;
  FirebaseService _firebaseService = FirebaseService();
  FirebaseAuth firebaseAuth;
  String collection = "users";
  Random random = Random();
  String handle = "";

  CreateSilaUserBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(CreateSilaUserInitial());

  @override
  Stream<CreateSilaUserState> mapEventToState(
      CreateSilaUserEvent event) async* {
    if (event is CreateSilaUserRequest) {
      yield CheckHandleLoadInProgress();

      try {
        UserModel user = await _firebaseService.getUserData();
        createHandle(user);
        final RegisterResponse response =
            await silaRepository.checkHandle(handle);
        if (response.success != true) {
          yield HandleTaken(checkHandleResponse: response);
        } else {
          yield CheckHandleSuccess(checkHandleResponse: response);

          try {
            yield RegisterLoadInProgress();
            final RegisterResponse response =
                await silaRepository.register(handle);
            yield RegisterLoadSuccess(registerResponse: response);
            Map<String, String> data = {"silaHandle": handle};
            _firebaseService.addDataToFirestoreDocument(collection, data);

            try {
              yield RequestKYCLoadInProgress();
              final RegisterResponse response =
                  await silaRepository.requestKYC();
              yield RequestKYCLoadSuccess(requestKycResponse: response);

              try {
                yield CheckKycLoadInProgress();
                CheckKycResponse response = await silaRepository.checkKYC();
                while (response.verificationStatus == "pending") {
                  yield CheckKycPending();
                  response = await silaRepository.checkKYC();
                }
                if (response.success == true) {
                  yield CheckKycVerifiationSuccess(checkKycResponse: response);
                  yield CreateSilaUserSuccess();
                } else if (response.verificationStatus == "failed")
                  yield CheckKycVerifiationFail(checkKycResponse: response);
              } catch (_) {
                yield CheckKycLoadFailure(exception: _);
              }
            } catch (_) {
              yield RequestKYCLoadFailure(exception: _);
            }
          } catch (_) {
            yield RegisterLoadFailure(exception: _);
          }
        }
      } catch (_) {
        yield CheckHandleLoadFailure(exception: _);
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  void createHandle(UserModel user) {
    handle += "divvy-" + user.name.replaceAll(' ', '').replaceAll('\'', '');
    for (int i = 0; i < 5; i++) {
      handle += random.nextInt(10).toString();
    }
  }
}
