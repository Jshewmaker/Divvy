import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/link_account/link_account.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class LinkAccountBloc extends Bloc<LinkAccountEvent, LinkAccountState> {
  final SilaRepository silaRepository;

  LinkAccountBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(LinkAccountInitial());

  @override
  Stream<LinkAccountState> mapEventToState(LinkAccountEvent event) async* {
    if (event is LinkAccountRequest) {
      yield LinkAccountLoadInProgress();
      try {
        final LinkAccountResponse response =
            await silaRepository.linkAccount(event.plaidPublicToken);
        FirebaseService _firebaseService = FirebaseService();
        _firebaseService.addDataToFirestoreDocument(
            'users', {"bankAccountIsConnected": true});
        yield LinkAccountLoadSuccess(response: response);
      } catch (_) {
        yield LinkAccountLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
