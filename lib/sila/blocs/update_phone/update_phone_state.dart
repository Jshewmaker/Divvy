part of 'update_phone_bloc.dart';

abstract class UpdatePhoneState extends Equatable {
  const UpdatePhoneState();

  @override
  List<Object> get props => [];
}

class UpdatePhoneInitial extends UpdatePhoneState {}

class UpdatePhoneLoadInProgress extends UpdatePhoneState {}

class UpdatePhoneLoadSuccess extends UpdatePhoneState {
  final UpdateUserInfo response;

  const UpdatePhoneLoadSuccess({@required this.response})
      : assert(response != null);

  @override
  List<Object> get props => [response];
}

class UpdatePhoneLoadFailure extends UpdatePhoneState {}
