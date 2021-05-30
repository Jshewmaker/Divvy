import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/update_entity/update_entity.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class UpdateEntityBloc extends Bloc<UpdateEntityEvent, UpdateEntityState> {
  final SilaRepository silaRepository;

  UpdateEntityBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(UpdateEntityInitial());

  @override
  Stream<UpdateEntityState> mapEventToState(UpdateEntityEvent event) async* {
    if (event is UpdateEntityRequest) {
      yield UpdateEntityLoadInProgress();
      try {
        final UpdateUserInfo response = await silaRepository.updateEntity();
        yield UpdateEntityLoadSuccess(response: response);
      } catch (_) {
        yield UpdateEntityLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
