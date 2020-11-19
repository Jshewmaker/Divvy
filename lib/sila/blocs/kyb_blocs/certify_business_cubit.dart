import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CertifyBusinessState {}

class CertifyBusinessInitial extends CertifyBusinessState {}

class CertifyBusinessLoadInProgress extends CertifyBusinessState {}

class CertifyBusinessLoadSuccess extends CertifyBusinessState {
  CertifyBusinessLoadSuccess(this.response);

  final CertifyBusinessOwnerResponse response;
}

class CertifyBusinessLoadFailure extends CertifyBusinessState {}

class CertifyBusinessCubit extends Cubit<CertifyBusinessState> {
  CertifyBusinessCubit(this._silaBusinessRepository)
      : super(CertifyBusinessInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> certifyBusinesss() async {
    emit(CertifyBusinessLoadInProgress());
    try {
      final response = await _silaBusinessRepository.certifyBusiness();
      emit(CertifyBusinessLoadSuccess(response));
    } catch (_) {
      emit(CertifyBusinessLoadFailure());
    }
  }
}
