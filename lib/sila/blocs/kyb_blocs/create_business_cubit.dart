import 'dart:math';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/models/kyb/check_kyb_response/check_kyb_response.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/business_roles.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/get_business_roles_response.dart';
import 'package:divvy/sila/models/kyb/link_business_member_response.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CreateSilaBusinessState {}

class CreateSilaBusinessInitial extends CreateSilaBusinessState {}

//Registration states
class RegisterBusinessLoadInProgress extends CreateSilaBusinessState {}

class RegisterBusinessSuccess extends CreateSilaBusinessState {
  RegisterBusinessSuccess(this.response);

  final KYBRegisterResponse response;
}

class RegisterBusinessFailure extends CreateSilaBusinessState {}

//Register business roles

class RegisterBusinessRoleLoadInProgress extends CreateSilaBusinessState {}

class RegisterBusinessRoleLoadSuccess extends CreateSilaBusinessState {
  RegisterBusinessRoleLoadSuccess(this.response);

  final RegisterResponse response;
}

class RegisterBusinessRoleLoadFailure extends CreateSilaBusinessState {}

//Buisness role states
class GetBusinessRolesLoadInProgress extends CreateSilaBusinessState {}

class GetBusinessRolesSuccess extends CreateSilaBusinessState {
  GetBusinessRolesSuccess(this.response);

  final GetBusinessRolesResponse response;
}

class GetBusinessRolesFailure extends CreateSilaBusinessState {}

//link business states

class LinkBusinessMembersLoadInProgress extends CreateSilaBusinessState {}

class LinkBusinessMembersSuccess extends CreateSilaBusinessState {
  LinkBusinessMembersSuccess(this.linkBusinessMembers);

  final List<LinkBusinessMemberResponse> linkBusinessMembers;
}

class LinkBusinessMembersFailure extends CreateSilaBusinessState {}

//Request kyb states

class RequestKYBLoadInProgress extends CreateSilaBusinessState {}

class RequestKYBSuccess extends CreateSilaBusinessState {
  RequestKYBSuccess(this.requestKYB);

  final RegisterResponse requestKYB;
}

class RequestKYBFailure extends CreateSilaBusinessState {}

//Check kyb states

class CheckKybLoadInProgress extends CreateSilaBusinessState {}

class CheckKybSuccess extends CreateSilaBusinessState {
  CheckKybSuccess(this.checkKYB);

  final CheckKybResponse checkKYB;
}

class CheckKybUnverified extends CreateSilaBusinessState {}

class CheckKybPending extends CreateSilaBusinessState {}

class CheckKybFailure extends CreateSilaBusinessState {}

//get entity

class GetEntityLoadInProgress extends CreateSilaBusinessState {}

class GetEntitySuccess extends CreateSilaBusinessState {
  GetEntitySuccess(this.getEntity);

  final GetEntityResponse getEntity;
}

class GetEntityFailure extends CreateSilaBusinessState {}

//certify beneficial owner status

class CertifyBeneficialOwnerLoadInProgress extends CreateSilaBusinessState {}

class CertifyBeneficialOwnerSuccess extends CreateSilaBusinessState {
  CertifyBeneficialOwnerSuccess(this.response);

  final CertifyBeneficialOwnerResponse response;
}

class CertifyBeneficialOwnerFailure extends CreateSilaBusinessState {}

//certify business states
class CertifyBusinessLoadInProgress extends CreateSilaBusinessState {}

class CertifyBusinessSuccess extends CreateSilaBusinessState {
  CertifyBusinessSuccess(this.response);

  final CertifyBeneficialOwnerResponse response;
}

class CertifyBusinessFailure extends CreateSilaBusinessState {}

//Failure
class CreateSilaBusinessFailure extends CreateSilaBusinessState {}

//Success
class CreateSilaBusinessSuccess extends CreateSilaBusinessState {}

class CreateSilaBusinessCubit extends Cubit<CreateSilaBusinessState> {
  CreateSilaBusinessCubit(this._silaBusinessRepository)
      : super(CreateSilaBusinessInitial());

  final SilaBusinessRepository _silaBusinessRepository;

  Future<void> createBusinesss() async {
    final FirebaseService _firebaseService = FirebaseService();
    UserModel user;
    emit(RegisterBusinessLoadInProgress());

    try {
      user = await _firebaseService.getUserData();
      String username = formatUsername(user);
      Map<String, String> data = {"silaHandle": username};
      _firebaseService.addDataToFirestoreDocument('users', data);
      final response = await _silaBusinessRepository.registerKYB();
      emit(RegisterBusinessSuccess(response));

      try {
        FirebaseService _firebaseService = FirebaseService();

        UserModel businessAdmin = await _firebaseService.getBusinessUser();
        String username = formatUsername(businessAdmin);
        Map<String, String> data = {"silaHandle": username};
        _firebaseService.addDataToBusinessUserDocument('users', data);

        final response =
            await _silaBusinessRepository.registerBusinessAdmin(businessAdmin);
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
                        emit(CreateSilaBusinessSuccess());
                      } catch (_) {
                        emit(CertifyBusinessFailure());
                      }
                    } catch (_) {
                      emit(CertifyBeneficialOwnerFailure());
                    }
                  } catch (_) {
                    emit(GetEntityFailure());
                  }
                } else {
                  emit(CheckKybFailure());
                }
              } catch (_) {
                emit(CheckKybFailure());
              }
            } catch (_) {
              emit(RequestKYBFailure());
            }
          } catch (_) {
            emit(LinkBusinessMembersFailure());
          }
        } catch (_) {
          emit(GetBusinessRolesFailure());
        }
      } catch (_) {
        emit(RegisterBusinessRoleLoadFailure());
      }
    } catch (_) {
      emit(RegisterBusinessFailure());
    }
  }

  String formatUsername(UserModel user) {
    Random random = Random();
    String handle;
    handle = "divvy-" + user.name.replaceAll(' ', '').replaceAll('\'', '');
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
