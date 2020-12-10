import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/transfer_sila/transfer_sila.dart';
import 'package:divvy/sila/models/transfer_sila_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class TransferSilaBloc extends Bloc<TransferSilaEvent, TransferSilaState> {
  final SilaRepository silaRepository;

  TransferSilaBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(TransferSilaInitial());

  @override
  Stream<TransferSilaState> mapEventToState(TransferSilaEvent event) async* {
    if (event is TransferSilaRequest) {
      yield TransferSilaLoadInProgress();
      try {
        final TransferSilaResponse response = await silaRepository.transferSila(
            event.sender,
            event.amount,
            event.receiverHandle,
            event.transferMessage);
        yield TransferSilaLoadSuccess(response: response);
      } catch (_) {
        yield TransferSilaLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
