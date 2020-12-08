import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:meta/meta.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoadInProgress extends ProjectState {}

class ProjectLoadSuccess extends ProjectState {
  final Project project;

  const ProjectLoadSuccess({@required this.project});

  @override
  List<Object> get props => [project];

  @override
  String toString() => 'ProjectConnected { projects: $project}';
}

class ProjectLoadFailure extends ProjectState {}
