import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateEntityState extends Equatable {
  const UpdateEntityState();

  @override
  List<Object> get props => [];
}

class UpdateEntityInitial extends UpdateEntityState {}

class UpdateEntityLoadInProgress extends UpdateEntityState {}

class UpdateEntityLoadSuccess extends UpdateEntityState {
  final UpdateUserInfo response;

  const UpdateEntityLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class UpdateEntityLoadFailure extends UpdateEntityState {}
