import 'package:equatable/equatable.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class ProjectConnectedLoadSuccess extends ProjectEvent {}

class ProjectInitialEvent extends ProjectEvent {
  const ProjectInitialEvent();

  @override
  List<Object> get props => [];
}

class ProjectCheck extends ProjectEvent {
  const ProjectCheck();

  @override
  List<Object> get props => [];
}

class ProjectRequested extends ProjectEvent {
  final String projectID;
  final Map data;

  const ProjectRequested(this.projectID, this.data);

  @override
  List<Object> get props => [projectID, data];

  @override
  String toString() => 'Connecting Project{project $projectID and $data}';
}
