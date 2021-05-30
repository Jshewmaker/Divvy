import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/update_address/update_address.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class UpdateAddressBloc extends Bloc<UpdateAddressEvent, UpdateAddressState> {
  final SilaRepository silaRepository;

  UpdateAddressBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(UpdateAddressInitial());

  @override
  Stream<UpdateAddressState> mapEventToState(UpdateAddressEvent event) async* {
    if (event is UpdateAddressRequest) {
      yield UpdateAddressLoadInProgress();
      try {
        final UpdateUserInfo response = await silaRepository.updateAddress();
        yield UpdateAddressLoadSuccess(response: response);
      } catch (_) {
        yield UpdateAddressLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
