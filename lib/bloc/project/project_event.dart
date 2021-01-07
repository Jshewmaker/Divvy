import 'package:equatable/equatable.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class ProjectConnectedLoadSuccess extends ProjectEvent {}

class CheckForProject extends ProjectEvent {}

class ProjectInitialEvent extends ProjectEvent {
  final String projectID;

  const ProjectInitialEvent(this.projectID);

  @override
  List<Object> get props => [projectID];

  @override
  String toString() => 'Connecting Project{project $projectID }';
}

class ProjectCheck extends ProjectEvent {
  const ProjectCheck();

  @override
  List<Object> get props => [];
}

class ProjectRequested extends ProjectEvent {
  final String projectID;

  const ProjectRequested(this.projectID);

  @override
  List<Object> get props => [projectID];

  @override
  String toString() => 'Connecting Project{project $projectID }';
}
