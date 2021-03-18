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
    if (event is DivvyCheckForHandle) {
      UserModel user = await _firebaseService.getUserData();
      if (user.silaHandle != null) {
        //Handle exists in Divvy and Sila ecosysten
        yield SilaHandleExists();
      } else {
        yield SilaHandleDoesNotExist();
      }
    } else if (event is CreateHandle) {
      UserModel user = await _firebaseService.getUserData();

      String handle = createHandle(user);
      yield CreateHandleSuccess(handle: handle);
    } else if (event is SilaCheckHandle) {
      final RegisterResponse response =
          await silaRepository.checkHandle(event.handle);

      if (response.success != true) {
        yield HandleTaken(checkHandleResponse: response);
      } else {
        yield CheckHandleSuccess(
            checkHandleResponse: response, handle: event.handle);
      }
    } else if (event is SilaRegisterHandle) {
      yield RegisterLoadInProgress();
      try {
        final RegisterResponse response =
            await silaRepository.register(event.handle);
        Map<String, String> data = {"silaHandle": event.handle};
        _firebaseService.addDataToFirestoreDocument(collection, data);
        yield RegisterSuccess(registerResponse: response);
      } catch (_) {
        yield RegisterFailure(exception: _);
      }
    } else if (event is SilaRequestKYC) {
      try {
        yield RequestKYCLoadInProgress();
        final RegisterResponse response = await silaRepository.requestKYC();
        yield RequestKYCSuccess(requestKycResponse: response);
      } catch (_) {
        yield RequestKYCFailure(exception: _);
      }
    } else if (event is SilaCheckKYC) {
      try {
        yield CheckKycLoadInProgress();
        UserModel user = await _firebaseService.getUserData();
        CheckKycResponse response = await silaRepository.checkKYC();

        while (response.verificationStatus == "pending") {
          yield CheckKycPending();
          response = await silaRepository.checkKYC();
        }
        if (response.success == true) {
          _firebaseService
              .addDataToFirestoreDocument('users', {"kyc_status": 'passed'});
          yield CheckKycVerifiationSuccess(checkKycResponse: response);
          yield CreateSilaUserSuccess(user: user);
        } else if (response.verificationStatus == "failed")
          yield CheckKycVerifiationFail(checkKycResponse: response);
        print(
            "Verification Status: ${response.verificationStatus} ${response.verificationHistory[0].tags[0]}");
      } catch (_) {
        yield CheckKycFailure(exception: _);
      }
    }

    //////////////////////////////////////////////////////////////////

    // else if (event is CreateSilaUserRequest) {
    //   yield CheckHandleLoadInProgress();

    //   try {
    //     UserModel user = await _firebaseService.getUserData();
    //     yield GetUserDataForProvider(user: user);
    //     createHandle(user);
    //     final RegisterResponse response =
    //         await silaRepository.checkHandle(handle);

    //     if (response.success != true) {
    //       yield HandleTaken(checkHandleResponse: response);
    //     } else {
    //       yield CheckHandleSuccess(checkHandleResponse: response);

    //       try {
    //         yield RegisterLoadInProgress();
    //         final RegisterResponse response =
    //             await silaRepository.register(handle);
    //         yield RegisterLoadSuccess(registerResponse: response);
    //         Map<String, String> data = {"silaHandle": handle};
    //         _firebaseService.addDataToFirestoreDocument(collection, data);

    //         try {
    //           yield RequestKYCLoadInProgress();
    //           final RegisterResponse response =
    //               await silaRepository.requestKYC();
    //           yield RequestKYCLoadSuccess(requestKycResponse: response);

    //           try {
    //             yield CheckKycLoadInProgress();
    //             CheckKycResponse response = await silaRepository.checkKYC();

    //             while (response.verificationStatus == "pending") {
    //               yield CheckKycPending();
    //               response = await silaRepository.checkKYC();
    //             }
    //             if (response.success == true) {
    //               _firebaseService.addDataToFirestoreDocument(
    //                   'users', {"kyc_status": 'passed'});
    //               yield CheckKycVerifiationSuccess(checkKycResponse: response);
    //               yield CreateSilaUserSuccess(user: user);
    //             } else if (response.verificationStatus == "failed")
    //               yield CheckKycVerifiationFail(checkKycResponse: response);
    //             print(
    //                 "Verification Status: ${response.verificationStatus} ${response.verificationHistory[0].tags[0]}");
    //           } catch (_) {
    //             yield CheckKycLoadFailure(exception: _);
    //           }
    //         } catch (_) {
    //           yield RequestKYCLoadFailure(exception: _);
    //         }
    //       } catch (_) {
    //         yield RegisterLoadFailure(exception: _);
    //       }
    //     }
    //   } catch (_) {
    //     yield CheckHandleLoadFailure(exception: _);
    //   }
    // }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  String createHandle(UserModel user) {
    String handle = "";
    handle += "divvysafe-" + user.name.replaceAll(' ', '').replaceAll('\'', '');
    for (int i = 0; i < 5; i++) {
      handle += random.nextInt(10).toString();
    }
    return handle;
  }
}
