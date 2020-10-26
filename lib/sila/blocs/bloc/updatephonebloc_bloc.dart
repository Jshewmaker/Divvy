import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'updatephonebloc_event.dart';
part 'updatephonebloc_state.dart';

class UpdatePhoneBloc extends Bloc<UpdatePhoneEvent, UpdatePhoneState> {
  final SilaRepository silaRepository;

  UpdatePhoneBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(UpdatePhoneInitial());

  @override
  Stream<UpdatePhoneState> mapEventToState(
    UpdatePhoneEvent event,
  ) async* {
    if (event is UpdatePhoneRequest) {
      yield UpdatePhoneLoadInProgress();
      try {
        final UpdateUserInfo response =
            await silaRepository.updatePhone(event.phoneNumber);
        yield UpdatePhoneLoadSuccess(response: response);
      } catch (_) {
        yield UpdatePhoneLoadFailure();
      }
    }
  }
}
