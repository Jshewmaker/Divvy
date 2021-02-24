import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/issue_sila/issue_sila.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';

class IssueSilaBloc extends Bloc<IssueSilaEvent, IssueSilaState> {
  final SilaRepository silaRepository;

  IssueSilaBloc({@required this.silaRepository})
      : assert(silaRepository != null),
        super(IssueSilaInitial());

  @override
  Stream<IssueSilaState> mapEventToState(IssueSilaEvent event) async* {
    if (event is IssueSilaRequest) {
      yield IssueSilaLoadInProgress();
      try {
        final IssueSilaResponse response =
            await silaRepository.issueSila(event.amount);
        yield IssueSilaLoadSuccess(response: response);
      } catch (_) {
        yield IssueSilaLoadFailure();
        print('error caught: $_');
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
