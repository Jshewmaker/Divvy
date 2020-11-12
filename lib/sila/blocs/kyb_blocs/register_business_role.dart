import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/register_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RegisterBusinessRoleState {}

class RegisterBusinessRoleInitial extends RegisterBusinessRoleState {}

class RegisterBusinessRoleLoadInProgress extends RegisterBusinessRoleState {}

class RegisterBusinessRoleLoadSuccess extends RegisterBusinessRoleState {
  RegisterBusinessRoleLoadSuccess(this.response);

  final RegisterResponse response;
}

class RegisterBusinessRoleLoadFailure extends RegisterBusinessRoleState {}

class RegisterBusinessRoleCubit extends Cubit<RegisterBusinessRoleState> {
  RegisterBusinessRoleCubit(this._silaBusinessRepository)
      : super(RegisterBusinessRoleInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> registerBusinessRole(UserModel user) async {
    if (user.name == null || user.name.isEmpty) return;
    emit(RegisterBusinessRoleLoadInProgress());
    try {
      FirebaseService _firebaseService = FirebaseService();
      _firebaseService.createBusinessAdminInFirestore(
          'users', user.toEntity().toDocument());

      final response = await _silaBusinessRepository.registerBusinessRole(user);
      emit(RegisterBusinessRoleLoadSuccess(response));
    } catch (_) {
      emit(RegisterBusinessRoleLoadFailure());
    }
  }
}
