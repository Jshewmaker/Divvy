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
    if (event is ProjectInitialEvent) {
      yield ProjectLoadInProgress();
      try {
        Project project = await firebaseService.getProjects(event.projectID);
        if (project != null) {
          UserModel user = await firebaseService.getUserData();
          if ((user.isHomeowner && project.homeownerPath == null) ||
              (!user.isHomeowner && project.generalContractorPath == null)) {
            final Project updatedProject = await firebaseService
                .addUserDataToProject(event.projectID, user);
            if (updatedProject == null) {
              yield ProjectNotConnected();
            } else {
              yield ProjectLoadSuccess(project: updatedProject);
            }
          } else {
            if (user.isHomeowner) {
              yield HomeownerExists();
            } else {
              yield GCExists();
            }
          }
        } else {
          yield ProjectDoesNotExist();
        }

        // final LineItemListModel lineItem =
        //     await firebaseService.getPhaseLineItems(1, event.projectID);
      } catch (_) {
        yield ProjectLoadFailure();
      }
    }
    if (event is CheckForProject) {
      try {
        yield CheckProjectInitial();
        //UserModel user = await firebaseService.getUserData();
        UserModel user = event.user;
        if (user.projectID != null && user.projectID != "") {
          yield ProjectLoadInProgress();
          Project project = await firebaseService.getProjects(user.projectID);
          yield ProjectLoadSuccess(project: project);
        } else {
          yield ProjectNotConnected();
        }
      } catch (_) {
        yield ProjectLoadFailure();
      }
    }
    if (event is ProjectListRequested) {
      yield ProjectLoadInProgress();
      try {
        List<Project> projects =
            await firebaseService.getProjectList(event.projectIDs);
        if (projects.isNotEmpty) {
          yield ProjectListLoadSuccess(projects: projects);
        } else {
          yield ProjectDoesNotExist();
        }
      } catch (_) {
        yield ProjectLoadFailure();
      }
    }
  }
}
