import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/update_ssn/update_ssn.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

///You can only update SSN before KYC is processed.
///
///Only call this if you are writing a flow where KYC hasnt been process yet
///or KYC has failed
class UpdateSsnBloc extends Bloc<UpdateSsnEvent, UpdateSsnState> {
  final SilaRepository silaRepository;

  UpdateSsnBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(UpdateSsnInitial());

  @override
  Stream<UpdateSsnState> mapEventToState(UpdateSsnEvent event) async* {
    if (event is UpdateSsnRequest) {
      yield UpdateSsnLoadInProgress();
      try {
        final UpdateUserInfo response =
            await silaRepository.updateIdentity(event.ssn);
        yield UpdateSsnLoadSuccess(response: response);
      } catch (_) {
        yield UpdateSsnLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
