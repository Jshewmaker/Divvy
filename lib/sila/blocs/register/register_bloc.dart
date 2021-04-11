import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/models/register_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SilaRepository silaRepository;

  RegisterBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    final FirebaseService _firebaseService = FirebaseService();
    if (event is RegisterRequest) {
      yield RegisterLoadInProgress();
      try {
        final RegisterResponse handle = await silaRepository.register();
        Map<String, String> data = {"silaHandle": "divvysafe-$handle"};
        _firebaseService.addDataToFirestoreDocument('users', data);
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
