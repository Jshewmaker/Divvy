import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CertifyBeneficialOwnerState {}

class CertifyBeneficialOwnerInitial extends CertifyBeneficialOwnerState {}

class CertifyBeneficialOwnerLoadInProgress extends CertifyBeneficialOwnerState {
}

class CertifyBeneficialOwnerLoadSuccess extends CertifyBeneficialOwnerState {
  CertifyBeneficialOwnerLoadSuccess(this.response);

  final CertifyBeneficialOwnerResponse response;
}

class CertifyBeneficialOwnerLoadFailure extends CertifyBeneficialOwnerState {}

class CertifyBeneficialOwnerCubit extends Cubit<CertifyBeneficialOwnerState> {
  CertifyBeneficialOwnerCubit(this._silaBusinessRepository)
      : super(CertifyBeneficialOwnerInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> certifyBeneficialOwners(String token) async {
    emit(CertifyBeneficialOwnerLoadInProgress());
    try {
      final response =
          await _silaBusinessRepository.certifyBeneficialOwner(token);
      emit(CertifyBeneficialOwnerLoadSuccess(response));
    } catch (_) {
      emit(CertifyBeneficialOwnerLoadFailure());
    }
  }
}
