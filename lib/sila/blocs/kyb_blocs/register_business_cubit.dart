import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RegisterBusinessState {}

class RegisterBusinessInitial extends RegisterBusinessState {}

class RegisterBusinessLoadInProgress extends RegisterBusinessState {}

class RegisterBusinessLoadSuccess extends RegisterBusinessState {
  RegisterBusinessLoadSuccess(this.response);

  final KYBRegisterResponse response;
}

class RegisterBusinessLoadFailure extends RegisterBusinessState {}

class RegisterBusinessCubit extends Cubit<RegisterBusinessState> {
  RegisterBusinessCubit(this._silaBusinessRepository)
      : super(RegisterBusinessInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> registerBusinesss() async {
    final FirebaseService _firebaseService = FirebaseService();
    UserModel user;
    emit(RegisterBusinessLoadInProgress());
    try {
      user = await _firebaseService.getUserData();
      String username = formatUsername(user);
      Map<String, String> data = {"silaHandle": username};
      _firebaseService.addDataToFirestoreDocument('users', data);
      final response = await _silaBusinessRepository.registerKYB();

      emit(RegisterBusinessLoadSuccess(response));
    } catch (_) {
      emit(RegisterBusinessLoadFailure());
    }
  }

  String formatUsername(UserModel user) {
    Random random = Random();
    String handle = user.name;
    handle = "divvysafe-" + user.name.replaceAll(' ', '').replaceAll('\'', '');
    for (int i = 0; i < 5; i++) {
      handle += random.nextInt(10).toString();
    }
    return handle;
  }
}
