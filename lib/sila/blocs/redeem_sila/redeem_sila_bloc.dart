import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/update_ssn/update_ssn.dart';
import 'package:divvy/sila/models/redeem_sila_model.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

import 'redeem_sila.dart';

class RedeemSilaBloc extends Bloc<RedeemSilaEvent, RedeemSilaState> {
  final SilaRepository silaRepository;

  RedeemSilaBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(RedeemSilaInitial());

  @override
  Stream<RedeemSilaState> mapEventToState(RedeemSilaEvent event) async* {
    if (event is RedeemSilaRequest) {
      yield RedeemSilaLoadInProgress();
      try {
        final response =
            await silaRepository.redeemSila(event.account, event.amount);
        yield RedeemSilaLoadSuccess(response);
      } catch (_) {
        yield RedeemSilaLoadFailure(exception: _);
        print('error caught: $_');
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
