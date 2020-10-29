import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/kyb/get_business_type_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BusinessTypeState {}

class BusinessTypeInitial extends BusinessTypeState {}

class BusinessTypeLoadInProgress extends BusinessTypeState {}

class BusinessTypeLoadSuccess extends BusinessTypeState {
  BusinessTypeLoadSuccess(this.businessType);

  final GetBusinessTypeResponse businessType;
}

class BusinessTypeLoadFailure extends BusinessTypeState {}

class BusinessTypeCubit extends Cubit<BusinessTypeState> {
  BusinessTypeCubit(this._silaBusinessRepository)
      : super(BusinessTypeInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> getBusinessTypes() async {
    emit(BusinessTypeLoadInProgress());
    try {
      final businessType = await _silaBusinessRepository.getBusinessTypes();
      emit(BusinessTypeLoadSuccess(businessType));
    } catch (_) {
      emit(BusinessTypeLoadFailure());
    }
  }
}
