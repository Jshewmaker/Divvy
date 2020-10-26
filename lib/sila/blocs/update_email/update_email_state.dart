import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateEmailState extends Equatable {
  const UpdateEmailState();

  @override
  List<Object> get props => [];
}

class UpdateEmailInitial extends UpdateEmailState {}

class UpdateEmailLoadInProgress extends UpdateEmailState {}

class UpdateEmailLoadSuccess extends UpdateEmailState {
  final UpdateUserInfo response;

  const UpdateEmailLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class UpdateEmailLoadFailure extends UpdateEmailState {}
