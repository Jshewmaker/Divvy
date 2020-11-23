import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/check_kyb_response/check_kyb_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CheckKYBState {}

class CheckKYBInitial extends CheckKYBState {}

class CheckKYBLoadInProgress extends CheckKYBState {}

class CheckKYBLoadSuccess extends CheckKYBState {
  CheckKYBLoadSuccess(this.checkKYB);

  final CheckKybResponse checkKYB;
}

class CheckKYBLoadFailure extends CheckKYBState {}

class CheckKYBCubit extends Cubit<CheckKYBState> {
  CheckKYBCubit(this._silaBusinessRepository) : super(CheckKYBInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> checkKYB() async {
    emit(CheckKYBLoadInProgress());
    try {
      CheckKybResponse checkKYB = await _silaBusinessRepository.checkKYB();
      emit(CheckKYBLoadSuccess(checkKYB));
    } catch (_) {
      emit(CheckKYBLoadFailure());
    }
  }
}
