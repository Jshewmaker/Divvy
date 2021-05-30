import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/models/kyb/check_kyb_response/check_kyb_response.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/get_business_roles_response.dart';
import 'package:divvy/sila/models/kyb/link_business_member_response.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CreateSilaBusinessState {}

class CreateSilaBusinessInitial extends CreateSilaBusinessState {}

class GetUserDataForProvider extends CreateSilaBusinessState {
  GetUserDataForProvider({@required this.user}) : assert(user != null);

  final UserModel user;
}

//Registration states
class RegisterBusinessLoadInProgress extends CreateSilaBusinessState {
  RegisterBusinessLoadInProgress({@required this.user}) : assert(user != null);

  final UserModel user;
}

class RegisterBusinessSuccess extends CreateSilaBusinessState {
  RegisterBusinessSuccess(this.response);

  final KYBRegisterResponse response;
}

class RegisterBusinessFailure extends CreateSilaBusinessState {
  RegisterBusinessFailure(this.exception);

  final exception;
}

//Register business roles

class RegisterBusinessRoleLoadInProgress extends CreateSilaBusinessState {}

class RegisterBusinessRoleLoadSuccess extends CreateSilaBusinessState {
  RegisterBusinessRoleLoadSuccess(this.response);

  final RegisterResponse response;
}

class RegisterBusinessRoleLoadFailure extends CreateSilaBusinessState {
  RegisterBusinessRoleLoadFailure(this.exception);

  final exception;
}

//Buisness role states
class GetBusinessRolesLoadInProgress extends CreateSilaBusinessState {}

class GetBusinessRolesSuccess extends CreateSilaBusinessState {
  GetBusinessRolesSuccess(this.response);

  final GetBusinessRolesResponse response;
}

class GetBusinessRolesFailure extends CreateSilaBusinessState {
  GetBusinessRolesFailure(this.exception);

  final exception;
}

//link business states

class LinkBusinessMembersLoadInProgress extends CreateSilaBusinessState {}

class LinkBusinessMembersSuccess extends CreateSilaBusinessState {
  LinkBusinessMembersSuccess(this.linkBusinessMembers);

  final List<LinkBusinessMemberResponse> linkBusinessMembers;
}

class LinkBusinessMembersFailure extends CreateSilaBusinessState {
  LinkBusinessMembersFailure(this.exception);

  final exception;
}

//Request kyb states

class RequestKYBLoadInProgress extends CreateSilaBusinessState {}

class RequestKYBSuccess extends CreateSilaBusinessState {
  RequestKYBSuccess(this.requestKYB);

  final RegisterResponse requestKYB;
}

class RequestKYBFailure extends CreateSilaBusinessState {
  RequestKYBFailure(this.exception);

  final exception;
}

//Check kyb states

class CheckKybLoadInProgress extends CreateSilaBusinessState {}

class CheckKybSuccess extends CreateSilaBusinessState {
  CheckKybSuccess(this.checkKYB);

  final CheckKybResponse checkKYB;
}

class CheckKybUnverified extends CreateSilaBusinessState {}

class CheckKybPending extends CreateSilaBusinessState {}

class CheckKybFailure extends CreateSilaBusinessState {
  CheckKybFailure(this.exception);

  final exception;
}

class CheckKybNotPassed extends CreateSilaBusinessState {
  CheckKybNotPassed(this.response);

  final CheckKybResponse response;
}

//get entity

class GetEntityLoadInProgress extends CreateSilaBusinessState {}

class GetEntitySuccess extends CreateSilaBusinessState {
  GetEntitySuccess(this.getEntity);

  final GetEntityResponse getEntity;
}

class GetEntityFailure extends CreateSilaBusinessState {
  GetEntityFailure(this.exception);

  final exception;
}

//certify beneficial owner status

class CertifyBeneficialOwnerLoadInProgress extends CreateSilaBusinessState {}

class CertifyBeneficialOwnerSuccess extends CreateSilaBusinessState {
  CertifyBeneficialOwnerSuccess(this.response);

  final CertifyBeneficialOwnerResponse response;
}

class CertifyBeneficialOwnerFailure extends CreateSilaBusinessState {
  CertifyBeneficialOwnerFailure(this.exception);

  final exception;
}

//certify business states
class CertifyBusinessLoadInProgress extends CreateSilaBusinessState {}

class CertifyBusinessSuccess extends CreateSilaBusinessState {
  CertifyBusinessSuccess(this.response);

  final CertifyBeneficialOwnerResponse response;
}

class CertifyBusinessFailure extends CreateSilaBusinessState {
  CertifyBusinessFailure(this.exception);

  final exception;
}

//Failure
class CreateSilaBusinessFailure extends CreateSilaBusinessState {}

//Success
class CreateSilaBusinessSuccess extends CreateSilaBusinessState {
  CreateSilaBusinessSuccess(this.user);

  final UserModel user;
}

class CreateSilaBusinessCubit extends Cubit<CreateSilaBusinessState> {
  CreateSilaBusinessCubit(this._silaBusinessRepository)
      : super(CreateSilaBusinessInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> createBusinesss() async {
    final FirebaseService _firebaseService = FirebaseService();
    UserModel user;

    try {
      user = await _firebaseService.getUserData();
      emit(RegisterBusinessLoadInProgress(user: user));
      emit(GetUserDataForProvider(user: user));
      String username = formatUsername(user);
      Map<String, String> data = {"silaHandle": username};
      _firebaseService.addDataToFirestoreDocument('users', data);

      final response = await _silaBusinessRepository.registerKYB(username);
      emit(RegisterBusinessSuccess(response));

      try {
        FirebaseService _firebaseService = FirebaseService();

        UserModel businessAdmin = await _firebaseService.getBusinessUser();
        String username = formatUsername(businessAdmin);
        Map<String, String> data = {"silaHandle": username};
        _firebaseService.addDataToBusinessUserDocument('users', data);

        final response =
            await _silaBusinessRepository.registerBusinessAdmin(username);
        emit(RegisterBusinessRoleLoadSuccess(response));

        try {
          final GetBusinessRolesResponse getBusinessRolesResponse =
              await _silaBusinessRepository.getBusinessRoles();
          emit(GetBusinessRolesSuccess(getBusinessRolesResponse));

          try {
            List<LinkBusinessMemberResponse> linkBusinessMembers = [];
            linkBusinessMembers = await _silaBusinessRepository
                .linkBusinessMember(getBusinessRolesResponse);
            emit(LinkBusinessMembersSuccess(linkBusinessMembers));

            try {
              RegisterResponse requestKYBResponse =
                  await _silaBusinessRepository.requestKYB();
              emit(RequestKYBSuccess(requestKYBResponse));

              try {
                CheckKybResponse checkKYBResponse =
                    await _silaBusinessRepository.checkKYB();
                while (
                    checkKYBResponse.verificationStatus.contains("pending")) {
                  emit(CheckKybPending());
                  checkKYBResponse = await _silaBusinessRepository.checkKYB();
                }
                if (checkKYBResponse.verificationStatus == "passed") {
                  emit(CheckKybSuccess(checkKYBResponse));

                  try {
                    GetEntityResponse getEntityResponse =
                        await _silaBusinessRepository.getEntity();
                    emit(GetEntitySuccess(getEntityResponse));

                    try {
                      String token = getToken(getEntityResponse);
                      if (token != null) {
                        final CertifyBeneficialOwnerResponse
                            certifyBeneficialOwnerResponse =
                            await _silaBusinessRepository
                                .certifyBeneficialOwner(token);
                        emit(CertifyBeneficialOwnerSuccess(
                            certifyBeneficialOwnerResponse));
                      }

                      try {
                        final CertifyBeneficialOwnerResponse
                            certifyBusinessResponse =
                            await _silaBusinessRepository.certifyBusiness();
                        emit(CertifyBusinessSuccess(certifyBusinessResponse));
                        emit(CreateSilaBusinessSuccess(user));
                        _firebaseService.addDataToBusinessUserDocument(
                            'users', {"kyc_status": 'passed'});
                        _firebaseService.addDataToFirestoreDocument(
                            'users', {"kyc_status": 'passed'});
                      } catch (_) {
                        emit(CertifyBusinessFailure(_));
                      }
                    } catch (_) {
                      emit(CertifyBeneficialOwnerFailure(_));
                    }
                  } catch (_) {
                    emit(GetEntityFailure(_));
                  }
                } else {
                  emit(CheckKybNotPassed(checkKYBResponse));
                }
              } catch (_) {
                emit(CheckKybFailure(_));
              }
            } catch (_) {
              emit(RequestKYBFailure(_));
            }
          } catch (_) {
            emit(LinkBusinessMembersFailure(_));
          }
        } catch (_) {
          emit(GetBusinessRolesFailure(_));
        }
      } catch (_) {
        emit(RegisterBusinessRoleLoadFailure(_));
      }
    } catch (_) {
      emit(RegisterBusinessFailure(_));
    }
  }

  String formatUsername(UserModel user) {
    Random random = Random();
    String handle;
    handle = "divvysafe-" + user.name.replaceAll(' ', '').replaceAll('\'', '');
    for (int i = 0; i < 5; i++) {
      handle += random.nextInt(10).toString();
    }
    return handle;
  }

  String getToken(GetEntityResponse response) {
    String token;
    int i = 0;

    do {
      if (response.memberships[i].certificationToken != null) {
        return response.memberships[i].certificationToken;
      }
      i++;
    } while (i < response.memberships.length);
    return token;
  }
}
