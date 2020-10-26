import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateSsnState extends Equatable {
  const UpdateSsnState();

  @override
  List<Object> get props => [];
}

class UpdateSsnInitial extends UpdateSsnState {}

class UpdateSsnLoadInProgress extends UpdateSsnState {}

class UpdateSsnLoadSuccess extends UpdateSsnState {
  final UpdateUserInfo response;

  const UpdateSsnLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class UpdateSsnLoadFailure extends UpdateSsnState {}
