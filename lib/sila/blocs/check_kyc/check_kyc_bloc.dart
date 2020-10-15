import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class CheckKycBloc extends Bloc<CheckKycEvent, CheckKycState> {
  final SilaRepository silaRepository;

  CheckKycBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(CheckKycInitial());

  @override
  Stream<CheckKycState> mapEventToState(CheckKycEvent event) async* {
    if (event is CheckKycRequest) {
      yield CheckKycLoadInProgress();
      try {
         CheckKycResponse response = await silaRepository.checkKYC();
        while (response.message.contains("is pending ID verification.")) {
          response = await silaRepository.checkKYC();
        }
        yield CheckKycLoadSuccess(response: response);
      } catch (_) {
        yield CheckKycLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
