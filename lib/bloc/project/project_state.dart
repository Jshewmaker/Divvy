import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoadInProgress extends ProjectState {}

class ProjectLoadSuccess extends ProjectState {
  final List<Project> projects;

  const ProjectLoadSuccess([this.projects = const []]);

  @override
  List<Object> get props => [projects];

  @override
  String toString() => 'ProjectConnected { projects: $projects}';
}

class ProjectLoadFailure extends ProjectState {}
