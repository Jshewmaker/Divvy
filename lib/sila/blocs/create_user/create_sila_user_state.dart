import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateSilaUserState extends Equatable {
  const CreateSilaUserState();
  final String message = "";

  @override
  List<Object> get props => [];
}

class CreateSilaUserInitial extends CreateSilaUserState {}

class GetUserDataForProvider extends CreateSilaUserState {
  final UserModel user;

  GetUserDataForProvider({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

//CHECK HANDLE

class CheckHandleLoadInProgress extends CreateSilaUserState {}

class CheckHandleSuccess extends CreateSilaUserState {
  final RegisterResponse checkHandleResponse;

  const CheckHandleSuccess({@required this.checkHandleResponse})
      : assert(checkHandleResponse != null);

  @override
  List<Object> get props => [checkHandleResponse];
}

class HandleTaken extends CreateSilaUserState {
  final RegisterResponse checkHandleResponse;

  const HandleTaken({@required this.checkHandleResponse})
      : assert(checkHandleResponse != null);

  @override
  List<Object> get props => [checkHandleResponse];
}

class CheckHandleLoadFailure extends CreateSilaUserState {
  final dynamic exception;

  const CheckHandleLoadFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

//END CHECK HANDLE

//REGISTER

class RegisterLoadInProgress extends CreateSilaUserState {}

class RegisterLoadSuccess extends CreateSilaUserState {
  final RegisterResponse registerResponse;

  RegisterLoadSuccess({@required this.registerResponse})
      : assert(registerResponse != null);

  @override
  List<Object> get props => [registerResponse];
}

class RegisterLoadFailure extends CreateSilaUserState {
  final dynamic exception;

  const RegisterLoadFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

//END REGISTER

//REQUEST KYC

class RequestKYCLoadInProgress extends CreateSilaUserState {}

class RequestKYCLoadSuccess extends CreateSilaUserState {
  final RegisterResponse requestKycResponse;

  const RequestKYCLoadSuccess({@required this.requestKycResponse})
      : assert(requestKycResponse != null);

  @override
  List<Object> get props => [requestKycResponse];
}

class RequestKYCLoadFailure extends CreateSilaUserState {
  final dynamic exception;

  const RequestKYCLoadFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

//END REQUEST KYC

//CHECK KYC

class CheckKycLoadInProgress extends CreateSilaUserState {}

class CheckKycVerifiationSuccess extends CreateSilaUserState {
  final CheckKycResponse checkKycResponse;

  const CheckKycVerifiationSuccess({@required this.checkKycResponse})
      : assert(checkKycResponse != null);

  @override
  List<Object> get props => [checkKycResponse];
}

class CheckKycPending extends CreateSilaUserState {}

class CheckKycVerifiationFail extends CreateSilaUserState {
  final CheckKycResponse checkKycResponse;

  const CheckKycVerifiationFail({@required this.checkKycResponse})
      : assert(checkKycResponse != null);

  @override
  List<Object> get props => [checkKycResponse];
}

class CheckKycLoadFailure extends CreateSilaUserState {
  final dynamic exception;

  const CheckKycLoadFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

//END CHECK KYC

class CreateSilaUserSuccess extends CreateSilaUserState {
  final UserModel user;

  const CreateSilaUserSuccess({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}
