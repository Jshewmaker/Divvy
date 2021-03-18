import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class IssueSilaState extends Equatable {
  const IssueSilaState();

  @override
  List<Object> get props => [];
}

class IssueSilaInitial extends IssueSilaState {}

class IssueSilaLoadInProgress extends IssueSilaState {}

class IssueSilaLoadSuccess extends IssueSilaState {
  final IssueSilaResponse response;

  const IssueSilaLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class IssueSilaLoadFailure extends IssueSilaState {
  final Exception exception;

  const IssueSilaLoadFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}
