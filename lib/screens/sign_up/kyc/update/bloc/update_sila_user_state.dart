import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateSilaUserState extends Equatable {
  const UpdateSilaUserState();
  final String message = "";

  @override
  List<Object> get props => [];
}

class UpdateSilaUserInitial extends UpdateSilaUserState {}

class UpdateUserInfoSuccess extends UpdateSilaUserState {
  final UpdateUserInfo response;

  UpdateUserInfoSuccess({@required this.response}) : assert(response != null);

  @override
  List<Object> get props => [response];
}

class UpdateUserInfoFailure extends UpdateSilaUserState {
  final Exception exception;

  UpdateUserInfoFailure({@required this.exception}) : assert(exception != null);

  @override
  List<Object> get props => [exception];
}
