import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/blocs/get_sila_balance/get_sila_balance.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class GetSilaBalanceBloc
    extends Bloc<GetSilaBalanceEvent, GetSilaBalanceState> {
  final SilaRepository silaRepository;

  GetSilaBalanceBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(GetSilaBalanceInitial());

  @override
  Stream<GetSilaBalanceState> mapEventToState(
      GetSilaBalanceEvent event) async* {
    if (event is GetSilaBalanceRequest) {
      yield GetSilaBalanceLoadInProgress();
      try {
        final GetSilaBalanceResponse response =
            await silaRepository.getSilaBalance();
        yield GetSilaBalanceLoadSuccess(response: response);
      } catch (_) {
        yield GetSilaBalanceLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
