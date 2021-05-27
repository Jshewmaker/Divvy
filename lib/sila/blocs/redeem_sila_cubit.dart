import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/redeem_sila_model.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RedeemSilaState {}

class RedeemSilaInitial extends RedeemSilaState {}

class RedeemSilaLoadInProgress extends RedeemSilaState {}

class RedeemSilaLoadSuccess extends RedeemSilaState {
  RedeemSilaLoadSuccess(this.response);

  final RedeemSilaModel response;
}

class RedeemSilaLoadFailure extends RedeemSilaState {
  RedeemSilaLoadFailure(this.exception);

  final Exception exception;
}

class RedeemSilaCubit extends Cubit<RedeemSilaState> {
  RedeemSilaCubit(this._silaRepository) : super(RedeemSilaInitial());

  final SilaRepository _silaRepository;

  Future<void> redeemSila(int amount) async {
    emit(RedeemSilaLoadInProgress());
    try {
      //final response = await _silaRepository.redeemSila(amount);
      // emit(RedeemSilaLoadSuccess(response));
    } catch (_) {
      emit(RedeemSilaLoadFailure(_));
    }
  }
}
