import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/models/handle.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SilaRepository silaRepository;

  RegisterBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
      RegisterEvent event) async* {
    if (event is RegisterRequest) {
      yield RegisterLoadInProgress();
      try {
        final Handle handle =
            await silaRepository.register(event.handle );
        yield RegisterLoadSuccess(handle: handle);
      } catch (_) {
        yield RegisterLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
