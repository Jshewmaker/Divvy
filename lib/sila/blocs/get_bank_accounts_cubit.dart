import 'package:bloc/bloc.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class GetBankAccountsState {}

class GetBankAccountsInitial extends GetBankAccountsState {}

class GetBankAccountsLoadInProgress extends GetBankAccountsState {}

class GetBankAccountsLoadSuccess extends GetBankAccountsState {
  GetBankAccountsLoadSuccess(this.bankAccounts);

  final GetBankAccountsResponse bankAccounts;
}

class GetBankAccountsLoadFailure extends GetBankAccountsState {}

class GetBankAccountsCubit extends Cubit<GetBankAccountsState> {
  GetBankAccountsCubit(this._silaRepository) : super(GetBankAccountsInitial());

  final SilaRepository _silaRepository;

  Future<void> getGetBankAccountss() async {
    emit(GetBankAccountsLoadInProgress());
    try {
      final GetBankAccounts = await _silaRepository.getBankAccounts();
      emit(GetBankAccountsLoadSuccess(GetBankAccounts));
    } catch (_) {
      emit(GetBankAccountsLoadFailure());
    }
  }
}
