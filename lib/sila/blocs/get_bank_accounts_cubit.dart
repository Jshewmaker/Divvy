import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/get_bank_accounts_response.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class GetBankAccountsState {}

class GetBankAccountsInitial extends GetBankAccountsState {}

class GetBankAccountsLoadInProgress extends GetBankAccountsState {}

class GetBankAccountsLoadSuccess extends GetBankAccountsState {
  GetBankAccountsLoadSuccess(this.bankAccountResponse);

  final GetBankAccountsResponse bankAccountResponse;
}

class GetBankAccountsLoadFailure extends GetBankAccountsState {
  GetBankAccountsLoadFailure(this.exception);

  final Exception exception;
}

class GetBankAccountsCubit extends Cubit<GetBankAccountsState> {
  GetBankAccountsCubit(this.silaRepository) : super(GetBankAccountsInitial());

  final SilaRepository silaRepository;

  Future<void> getGetBankAccountss() async {
    emit(GetBankAccountsLoadInProgress());
    try {
      final bankAccounts = await silaRepository.getBankAccounts();
      emit(GetBankAccountsLoadSuccess(bankAccounts));
    } catch (_) {
      emit(GetBankAccountsLoadFailure(_));
    }
  }
}
