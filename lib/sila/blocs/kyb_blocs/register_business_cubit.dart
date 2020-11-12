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
    emit(RegisterBusinessLoadInProgress());
    try {
      final response = await _silaBusinessRepository.registerKYB();
      emit(RegisterBusinessLoadSuccess(response));
    } catch (_) {
      emit(RegisterBusinessLoadFailure());
    }
  }
}
