import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/register_response.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RequestKYBState {}

class RequestKYBInitial extends RequestKYBState {}

class RequestKYBLoadInProgress extends RequestKYBState {}

class RequestKYBLoadSuccess extends RequestKYBState {
  RequestKYBLoadSuccess(this.requestKYB);

  final RegisterResponse requestKYB;
}

class RequestKYBLoadFailure extends RequestKYBState {}

class RequestKYBCubit extends Cubit<RequestKYBState> {
  RequestKYBCubit(this._silaBusinessRepository) : super(RequestKYBInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> requestKYB() async {
    emit(RequestKYBLoadInProgress());
    try {
      RegisterResponse requestKYB = await _silaBusinessRepository.requestKYB();
      emit(RequestKYBLoadSuccess(requestKYB));
    } catch (_) {
      emit(RequestKYBLoadFailure());
    }
  }
}
