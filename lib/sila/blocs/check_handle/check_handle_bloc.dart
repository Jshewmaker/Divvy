import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/models/handle.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class CheckHandleBloc extends Bloc<CheckHandleEvent, CheckHandleState> {
  final SilaRepository checkHandleRepository;

  CheckHandleBloc({@required this.checkHandleRepository})
      : assert(checkHandleRepository != null),
        super(CheckHandleInitial());

  @override
  Stream<CheckHandleState> mapEventToState(CheckHandleEvent event) async* {
    if (event is CheckHandleRequest) {
      yield CheckHandleLoadInProgress();
      try {
        final Handle handle =
            await checkHandleRepository.checkHandle(event.handle);
        yield CheckHandleLoadSuccess(checkHandle: handle);
      } catch (_) {
        yield CheckHandleLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
