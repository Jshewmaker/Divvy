import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CheckKycState extends Equatable {
  const CheckKycState();

  @override
  List<Object> get props => [];
}

class CheckKycInitial extends CheckKycState {}

class CheckKycLoadInProgress extends CheckKycState {}

class CheckKycLoadSuccess extends CheckKycState {
  final CheckKycResponse response;

  const CheckKycLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class CheckKycLoadNotReady extends CheckKycState {
  final CheckKycResponse response;

  const CheckKycLoadNotReady({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class CheckKycLoadFailure extends CheckKycState {}
