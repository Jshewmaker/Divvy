import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/blocs.dart';
import 'package:divvy/sila/blocs/request_kyc/request_kyc.dart';
import 'package:divvy/sila/models/register_response.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class RequestKYCBloc extends Bloc<RequestKYCEvent, RequestKYCState> {
  final SilaRepository silaRepository;

  RequestKYCBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(RequestKYCInitial());

  @override
  Stream<RequestKYCState> mapEventToState(
      RequestKYCEvent event) async* {
    if (event is RequestKYCRequest) {
      yield RequestKYCLoadInProgress();
      try {
        final RegisterResponse handle =
            await silaRepository.requestKYC();
        yield RequestKYCLoadSuccess(handle: handle);
      } catch (_) {
        yield RequestKYCLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
