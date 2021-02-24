import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/get_sila_balance/get_sila_balance.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class GetSilaBalanceBloc
    extends Bloc<GetSilaBalanceEvent, GetSilaBalanceState> {
  final SilaRepository silaRepository;
  FirebaseService _firebaseService = FirebaseService();

  GetSilaBalanceBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(GetSilaBalanceInitial());

  @override
  Stream<GetSilaBalanceState> mapEventToState(
      GetSilaBalanceEvent event) async* {
    if (event is GetSilaBalanceRequest) {
      yield GetSilaBalanceLoadInProgress();
      try {
        final GetSilaBalanceResponse userSilaResponse =
            await silaRepository.getSilaBalance();
        if (event.user.projectID != null && event.user.projectID != "") {
          Project project =
              await _firebaseService.getProjects(event.user.projectID);
          UserModel homeowner =
              await _firebaseService.getUserByPath(project.homeownerPath);
          final GetSilaBalanceResponse projectSilaResponse =
              await silaRepository.getProjectBalance(homeowner.wallet);
          yield GetSilaBalanceLoadSuccess(
              userSilaResponse: userSilaResponse,
              projectSilaResponse: projectSilaResponse);
        } else {
          yield GetSilaBalanceLoadSuccess(userSilaResponse: userSilaResponse);
        }
      } catch (_) {
        print('error caught: $_');
        yield GetSilaBalanceLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
