import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/get_transactions/get_transactions.dart';
import 'package:divvy/sila/models/get_transactions_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class GetTransactionsBloc
    extends Bloc<GetTransactionsEvent, GetTransactionsState> {
  final SilaRepository silaRepository;

  GetTransactionsBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(GetEntityInitial());

  @override
  Stream<GetTransactionsState> mapEventToState(
      GetTransactionsEvent event) async* {
    if (event is GetTransactionsRequest) {
      yield GetTransactionsLoadInProgress();
      try {
        final GetTransactionsResponse response =
            await silaRepository.getTransactions();
        yield GetTransactionsLoadSuccess(response: response);
      } catch (_) {
        yield GetTransactionsLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
