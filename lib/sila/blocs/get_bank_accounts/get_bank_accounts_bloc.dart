import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/bank_accounts_entity.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

import 'get_bank_accounts.dart';

class GetBankAccountsBloc
    extends Bloc<GetBankAccountsEvent, GetBankAccountsState> {
  final SilaRepository silaRepository;

  GetBankAccountsBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(GetBankAccountsInitial());

  @override
  Stream<GetBankAccountsState> mapEventToState(
      GetBankAccountsEvent event) async* {
    if (event is GetBankAccountsRequest) {
      yield GetBankAccountsLoadInProgress();
      try {
        ListOfBankAccountEntities response =
            await silaRepository.getBankAccounts();
        yield GetBankAccountsLoadSuccess(response: response);
      } catch (_) {
        yield GetBankAccountsLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
