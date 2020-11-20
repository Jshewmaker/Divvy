import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CertifyBusinessOwnerState {}

class CertifyBusinessOwnerInitial extends CertifyBusinessOwnerState {}

class CertifyBusinessOwnerLoadInProgress extends CertifyBusinessOwnerState {}

class CertifyBusinessOwnerLoadSuccess extends CertifyBusinessOwnerState {
  CertifyBusinessOwnerLoadSuccess(this.response);

  final CertifyBusinessOwnerResponse response;
}

class CertifyBusinessOwnerLoadFailure extends CertifyBusinessOwnerState {}

class CertifyBusinessOwnerCubit extends Cubit<CertifyBusinessOwnerState> {
  CertifyBusinessOwnerCubit(this._silaBusinessRepository)
      : super(CertifyBusinessOwnerInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> certifyBusinessOwners(String token) async {
    emit(CertifyBusinessOwnerLoadInProgress());
    try {
      final response =
          await _silaBusinessRepository.certifyBusinessOwner(token);
      emit(CertifyBusinessOwnerLoadSuccess(response));
    } catch (_) {
      emit(CertifyBusinessOwnerLoadFailure());
    }
  }
}
