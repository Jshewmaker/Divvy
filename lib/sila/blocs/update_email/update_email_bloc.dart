import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/update_email/update_email.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class UpdateEmailBloc extends Bloc<UpdateEmailEvent, UpdateEmailState> {
  final SilaRepository silaRepository;

  UpdateEmailBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(UpdateEmailInitial());

  @override
  Stream<UpdateEmailState> mapEventToState(UpdateEmailEvent event) async* {
    if (event is UpdateEmailRequest) {
      yield UpdateEmailLoadInProgress();
      try {
        final UpdateUserInfo response =
            await silaRepository.updateEmail(event.email);
        yield UpdateEmailLoadSuccess(response: response);
      } catch (_) {
        yield UpdateEmailLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
