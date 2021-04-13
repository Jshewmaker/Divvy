import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/check_kyc_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  CreateSilaUserBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(CreateSilaUserInitial());

  @override
  Stream<CreateSilaUserState> mapEventToState(
      CreateSilaUserEvent event) async* {
    if (event is CreateSilaUserRequest) {
      try {
        UserModel user = await _firebaseService.getUserData();
        yield RegisterLoadInProgress();
        final RegisterResponse response = await silaRepository.register();
        yield RegisterLoadSuccess(registerResponse: response);

        try {
          yield RequestKYCLoadInProgress();
          final RegisterResponse response = await silaRepository.requestKYC();
          yield RequestKYCLoadSuccess(requestKycResponse: response);

          try {
            yield CheckKycLoadInProgress();
            CheckKycResponse response = await silaRepository.checkKYC();

            while (response.verificationStatus == "pending") {
              yield CheckKycPending();
              response = await silaRepository.checkKYC();
            }
            if (response.success == true) {
              _firebaseService.addDataToFirestoreDocument(
                  'users', {"kyc_status": 'passed'});
              yield CheckKycVerifiationSuccess(checkKycResponse: response);
              yield CreateSilaUserSuccess(user: user);
            } else if (response.verificationStatus == "failed")
              yield CheckKycVerifiationFail(checkKycResponse: response);
            print(
                "Verification Status: ${response.verificationStatus} ${response.verificationHistory[0].tags[0]}");
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
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
