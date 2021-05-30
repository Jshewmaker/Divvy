import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/bank_account_balance_response.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BankAccountBalanceState {}

class BankAccountBalanceInitial extends BankAccountBalanceState {}

class BankAccountBalanceLoadInProgress extends BankAccountBalanceState {}

class BankAccountBalanceLoadSuccess extends BankAccountBalanceState {
  BankAccountBalanceLoadSuccess(this.bankAccountBalanceResponse);

  final BankAccountBalanceResponse bankAccountBalanceResponse;
}

class BankAccountBalanceLoadFailure extends BankAccountBalanceState {
  BankAccountBalanceLoadFailure(this.exception);

  final Exception exception;
}

class BankAccountBalanceCubit extends Cubit<BankAccountBalanceState> {
  BankAccountBalanceCubit(this.silaRepository)
      : super(BankAccountBalanceInitial());

  final SilaRepository silaRepository;

  Future<void> getBankAccountBalances() async {
    emit(BankAccountBalanceLoadInProgress());
    try {
      final bankAccountBalance = await silaRepository.getBankAccountBalance();
      emit(BankAccountBalanceLoadSuccess(bankAccountBalance));
    } catch (_) {
      emit(BankAccountBalanceLoadFailure(_));
    }
  }
}

/*
userInitial
------------------
userCheckHandle
UserCheckHandleSuccessful
UserCheckHandleFailure
UserRegisterHandle
UserRegisterHandleSuccessful
UserRegsiterHandleFailure
UserKYC
UserKYCSuccessful
userKycFailure
---------------
UserFailure
*/
