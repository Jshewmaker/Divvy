import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LinkAccountState extends Equatable {
  const LinkAccountState();

  @override
  List<Object> get props => [];
}

class LinkAccountInitial extends LinkAccountState {}

class LinkAccountLoadInProgress extends LinkAccountState {}

class LinkAccountLoadSuccess extends LinkAccountState {
  final LinkAccountResponse response;

  const LinkAccountLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class LinkAccountLoadFailure extends LinkAccountState {
  final Exception exception;

  const LinkAccountLoadFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}
