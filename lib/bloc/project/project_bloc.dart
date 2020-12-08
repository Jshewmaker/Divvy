import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/project/project_event.dart';
import 'package:divvy/bloc/project/project_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final FirebaseService firebaseService;

  ProjectBloc({@required this.firebaseService})
      : assert(firebaseService != null),
        super(ProjectInitial());

  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async* {
    if (event is ProjectRequested) {
      yield ProjectLoadInProgress();
      try {
        final Project project =
            await firebaseService.getProjects(event.projectID, event.data);
        yield ProjectLoadSuccess(project: project);
        final LineItemListModel lineItem =
            await firebaseService.getPhaseLineItems(1, event.projectID);
      } catch (_) {
        yield ProjectLoadFailure();
      }
    }
  }
}
