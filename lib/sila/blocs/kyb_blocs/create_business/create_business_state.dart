import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/models/kyb/check_kyb_response/check_kyb_response.dart';
import 'package:divvy/sila/models/kyb/link_business_member_response.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateSilaBusinessState extends Equatable {
  const CreateSilaBusinessState();
  final String message = "";

  @override
  List<Object> get props => [];
}

class CreateSilaBusinessInitial extends CreateSilaBusinessState {}

class GetUserDataForProvider extends CreateSilaBusinessState {
  final UserModel user;

  GetUserDataForProvider({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class SilaBusinessHandleExists extends CreateSilaBusinessState {}

class SilaBusinessHandleDoesNotExist extends CreateSilaBusinessState {}

class CreateBusinessHandleSuccess extends CreateSilaBusinessState {
  final String handle;

  CreateBusinessHandleSuccess({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [handle];
}

class RegisterLoadInProgress extends CreateSilaBusinessState {}

class RegisterBusinessSuccess extends CreateSilaBusinessState {
  final KYBRegisterResponse registerResponse;

  RegisterBusinessSuccess({@required this.registerResponse})
      : assert(registerResponse != null);

  @override
  List<Object> get props => [registerResponse];
}

class RegisterBusinessFailure extends CreateSilaBusinessState {
  final Exception exception;

  RegisterBusinessFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

class RegisterAdminSuccess extends CreateSilaBusinessState {
  final RegisterResponse registerResponse;

  RegisterAdminSuccess({@required this.registerResponse})
      : assert(registerResponse != null);

  @override
  List<Object> get props => [registerResponse];
}

class RegisterAdminFailure extends CreateSilaBusinessState {
  final Exception exception;

  RegisterAdminFailure({@required this.exception}) : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

class SilaAdminHandleExists extends CreateSilaBusinessState {}

class SilaAdminHandleDoesNotExist extends CreateSilaBusinessState {}

class CreateAdminHandleSuccess extends CreateSilaBusinessState {
  final String handle;

  CreateAdminHandleSuccess({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [handle];
}

class KybRegisterSuccess extends CreateSilaBusinessState {
  final KYBRegisterResponse registerResponse;

  KybRegisterSuccess({@required this.registerResponse})
      : assert(registerResponse != null);

  @override
  List<Object> get props => [registerResponse];
}

class BusinessHandleTaken extends CreateSilaBusinessState {
  final RegisterResponse checkHandleResponse;

  BusinessHandleTaken({@required this.checkHandleResponse})
      : assert(checkHandleResponse != null);

  @override
  List<Object> get props => [checkHandleResponse];
}

class AdminHandleTaken extends CreateSilaBusinessState {
  final RegisterResponse checkHandleResponse;

  AdminHandleTaken({@required this.checkHandleResponse})
      : assert(checkHandleResponse != null);

  @override
  List<Object> get props => [checkHandleResponse];
}

class CheckBusinessHandleSuccess extends CreateSilaBusinessState {
  final String handle;
  final RegisterResponse checkHandleResponse;

  CheckBusinessHandleSuccess({@required this.checkHandleResponse, this.handle})
      : assert(checkHandleResponse != null, handle != null);

  @override
  List<Object> get props => [checkHandleResponse, handle];
}

class CheckAdminHandleSuccess extends CreateSilaBusinessState {
  final String handle;
  final RegisterResponse checkHandleResponse;

  CheckAdminHandleSuccess({@required this.checkHandleResponse, this.handle})
      : assert(checkHandleResponse != null, handle != null);

  @override
  List<Object> get props => [checkHandleResponse, handle];
}

class LinkBusinessMembersSuccess extends CreateSilaBusinessState {
  final List<LinkBusinessMemberResponse> linkBusinessMembers;

  LinkBusinessMembersSuccess({@required this.linkBusinessMembers})
      : assert(linkBusinessMembers != null);

  @override
  List<Object> get props => [linkBusinessMembers];
}

class LinkBusinessMembersFailure extends CreateSilaBusinessState {
  final Exception exception;

  LinkBusinessMembersFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

class RequestKybSuccess extends CreateSilaBusinessState {
  final RegisterResponse requestKYBResponse;

  RequestKybSuccess({@required this.requestKYBResponse})
      : assert(requestKYBResponse != null);

  @override
  List<Object> get props => [requestKYBResponse];
}

class RequestKybFailure extends CreateSilaBusinessState {
  final Exception exception;

  RequestKybFailure({@required this.exception}) : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

class CheckKybPending extends CreateSilaBusinessState {}

class CheckKybSuccess extends CreateSilaBusinessState {
  final CheckKybResponse checkKYBResponse;

  CheckKybSuccess({@required this.checkKYBResponse})
      : assert(checkKYBResponse != null);

  @override
  List<Object> get props => [checkKYBResponse];
}

class CheckKybNotPassed extends CreateSilaBusinessState {
  final CheckKybResponse checkKYBResponse;

  CheckKybNotPassed({@required this.checkKYBResponse})
      : assert(checkKYBResponse != null);

  @override
  List<Object> get props => [checkKYBResponse];
}

class CheckKybFailure extends CreateSilaBusinessState {
  final dynamic exception;

  CheckKybFailure({@required this.exception}) : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

class GetEntitySuccess extends CreateSilaBusinessState {
  final GetEntityResponse getEntityResponse;

  GetEntitySuccess({@required this.getEntityResponse})
      : assert(getEntityResponse != null);

  @override
  List<Object> get props => [getEntityResponse];
}

class CertifyBeneficialOwnerSuccess extends CreateSilaBusinessState {
  final CertifyBeneficialOwnerResponse certifyBeneficialOwnerResponse;

  CertifyBeneficialOwnerSuccess({@required this.certifyBeneficialOwnerResponse})
      : assert(certifyBeneficialOwnerResponse != null);

  @override
  List<Object> get props => [certifyBeneficialOwnerResponse];
}

class CertifyBeneficialOwnerFailure extends CreateSilaBusinessState {
  final Exception exception;

  CertifyBeneficialOwnerFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}

class CertifyBusinessSuccess extends CreateSilaBusinessState {
  final CertifyBeneficialOwnerResponse certifyBusinessResponse;

  CertifyBusinessSuccess({@required this.certifyBusinessResponse})
      : assert(certifyBusinessResponse != null);

  @override
  List<Object> get props => [certifyBusinessResponse];
}

class CreateSilaBusinessSuccess extends CreateSilaBusinessState {
  final UserModel user;

  CreateSilaBusinessSuccess({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class CertifyBusinessFailure extends CreateSilaBusinessState {
  final Exception exception;

  CertifyBusinessFailure({@required this.exception})
      : assert(exception != null);

  @override
  List<Object> get props => [exception];
}
