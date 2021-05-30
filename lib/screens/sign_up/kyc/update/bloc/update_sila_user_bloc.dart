import 'dart:math';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/screens/sign_up/kyc/update/bloc/update_sila_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class UpdateSilaUserBloc
    extends Bloc<UpdateSilaUserEvent, UpdateSilaUserState> {
  final SilaRepository silaRepository;
  FirebaseService _firebaseService = FirebaseService();
  FirebaseAuth firebaseAuth;

  String collection = "users";
  Random random = Random();

  UpdateSilaUserBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(UpdateSilaUserInitial());

  @override
  Stream<UpdateSilaUserState> mapEventToState(
      UpdateSilaUserEvent event) async* {
    //Update Address
    if (event is UpdateAddress) {
      try {
        _firebaseService.addDataToFirestoreDocument(
            'users',
            UserModel(
              streetAddress: event.streetAddress,
              city: event.city,
              state: event.state,
              country: event.country,
              postalCode: event.postalCode,
            ).toEntity().toDocumentAddresses());
        final response = await silaRepository.updateAddress();
        yield UpdateUserInfoSuccess(response: response);
      } catch (_) {
        yield UpdateUserInfoFailure(exception: _);
      }
    }

    //Update User Info (entity)
    else if (event is UpdateUserInfo) {
      try {
        //_firebaseService.addUserEmailToFirebaseDocument(); //need??
        _firebaseService.addDataToFirestoreDocument(
            'users',
            UserModel(
              name: "${event.firstName} ${event.lastName}",
              dateOfBirthYYYYMMDD: event.birthday,
              phone: event.phone,
            ).toEntity().toDocumentNameDOBPhone());
        final response = await silaRepository.updateEntity();
        yield UpdateUserInfoSuccess(response: response);
      } catch (_) {
        yield UpdateUserInfoFailure(exception: _);
      }
    }

    //Update SSN
    else if (event is UpdateSSN) {
      try {
        _firebaseService.addDataToFirestoreDocument(
            'users',
            UserModel(
              identityValue: event.ssn,
            ).toEntity().toDocumentIdentityValue());
        final response = await silaRepository.updateIdentity(event.ssn);
        yield UpdateUserInfoSuccess(response: response);
      } catch (_) {
        yield UpdateUserInfoFailure(exception: _);
      }
    }
  }
}
