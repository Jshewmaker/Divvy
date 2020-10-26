import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateAddressState extends Equatable {
  const UpdateAddressState();

  @override
  List<Object> get props => [];
}

class UpdateAddressInitial extends UpdateAddressState {}

class UpdateAddressLoadInProgress extends UpdateAddressState {}

class UpdateAddressLoadSuccess extends UpdateAddressState {
  final UpdateUserInfo response;

  const UpdateAddressLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class UpdateAddressLoadFailure extends UpdateAddressState {}
