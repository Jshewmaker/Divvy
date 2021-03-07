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

class SilaHandleExists extends CreateSilaUserState {}

class SilaHandleDoesNotExist extends CreateSilaUserState {}

class CreateHandleSuccess extends CreateSilaUserState {
  final String handle;

  const CreateHandleSuccess({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [handle];
}

class CheckHandleSuccess extends CreateSilaUserState {
  final RegisterResponse checkHandleResponse;
  final String handle;

  const CheckHandleSuccess({@required this.checkHandleResponse, this.handle})
      : assert(checkHandleResponse != null && handle != null);

  @override
  List<Object> get props => [checkHandleResponse, handle];
}

class HandleTaken extends CreateSilaUserState {
  final RegisterResponse checkHandleResponse;

  const HandleTaken({@required this.checkHandleResponse})
      : assert(checkHandleResponse != null);

  @override
  List<Object> get props => [checkHandleResponse];
}

class CheckHandleFailure extends CreateSilaUserState {
  final dynamic exception;

  const CheckHandleFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

//END CHECK HANDLE

//REGISTER

class RegisterLoadInProgress extends CreateSilaUserState {}

class RegisterSuccess extends CreateSilaUserState {
  final RegisterResponse registerResponse;

  RegisterSuccess({@required this.registerResponse})
      : assert(registerResponse != null);

  @override
  List<Object> get props => [registerResponse];
}

class RegisterFailure extends CreateSilaUserState {
  final dynamic exception;

  const RegisterFailure({@required this.exception}) : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

//END REGISTER

//REQUEST KYC

class RequestKYCLoadInProgress extends CreateSilaUserState {}

class RequestKYCSuccess extends CreateSilaUserState {
  final RegisterResponse requestKycResponse;

  const RequestKYCSuccess({@required this.requestKycResponse})
      : assert(requestKycResponse != null);

  @override
  List<Object> get props => [requestKycResponse];
}

class RequestKYCFailure extends CreateSilaUserState {
  final dynamic exception;

  const RequestKYCFailure({@required this.exception})
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

class CheckKycFailure extends CreateSilaUserState {
  final dynamic exception;

  const CheckKycFailure({@required this.exception}) : assert(exception != null);

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
