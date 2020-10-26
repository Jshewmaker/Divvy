import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/models/register_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class CheckHandleBloc extends Bloc<CheckHandleEvent, CheckHandleState> {
  final SilaRepository silaRepository;

  CheckHandleBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(CheckHandleInitial());

  @override
  Stream<CheckHandleState> mapEventToState(CheckHandleEvent event) async* {
    if (event is CheckHandleRequest) {
      yield CheckHandleLoadInProgress();
      try {
        final RegisterResponse handle =
            await silaRepository.checkHandle(event.handle);
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
