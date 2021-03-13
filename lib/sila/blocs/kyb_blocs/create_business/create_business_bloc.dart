import 'dart:math';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/kyb_blocs/create_business/create_business_event.dart';
import 'package:divvy/sila/blocs/kyb_blocs/create_business/create_business_state.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/models/kyb/check_kyb_response/check_kyb_response.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/get_business_roles_response.dart';
import 'package:divvy/sila/models/kyb/link_business_member_response.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:divvy/sila/repositories/sila_business_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateSilaBusinessBloc
    extends Bloc<CreateSilaBusinessEvent, CreateSilaBusinessState> {
  final SilaBusinessRepository silaBusinessRepository;
  final SilaRepository silaRepository;
  FirebaseService _firebaseService = FirebaseService();
  FirebaseAuth firebaseAuth;

  String collection = "users";
  Random random = Random();

  CreateSilaBusinessBloc(
      {@required this.silaBusinessRepository, this.silaRepository})
      : assert(silaBusinessRepository != null, silaRepository != null),
        super(CreateSilaBusinessInitial());

  @override
  Stream<CreateSilaBusinessState> mapEventToState(
      CreateSilaBusinessEvent event) async* {
    // Check Firestore for Business Sila Handle
    if (event is DivvyCheckForBusinessHandle) {
      UserModel business = await _firebaseService.getUserData();
      if (business.silaHandle != null) {
        //Handle exists in Divvy and Sila ecosysten
        yield SilaBusinessHandleExists();
      } else {
        yield SilaBusinessHandleDoesNotExist();
      }
    }

    // Create Sila handle for Business
    else if (event is CreateBusinessHandle) {
      UserModel business = await _firebaseService.getUserData();
      String handle = createHandle(business);
      yield CreateBusinessHandleSuccess(handle: handle);
    }

    // Check Sila to see if valid handle
    else if (event is SilaCheckBusinessHandle) {
      final RegisterResponse response =
          await silaRepository.checkHandle(event.handle);
      if (response.success != true) {
        yield BusinessHandleTaken(checkHandleResponse: response);
      } else {
        yield CheckBusinessHandleSuccess(
            checkHandleResponse: response, handle: event.handle);
      }
    }

    // Register Business with Sila and store handle in Firebase
    else if (event is SilaRegisterBusiness) {
      yield RegisterLoadInProgress();
      try {
        final KYBRegisterResponse response =
            await silaBusinessRepository.registerKYB(event.handle);
        Map<String, String> data = {"silaHandle": event.handle};
        _firebaseService.addDataToFirestoreDocument(collection, data);
        yield RegisterBusinessSuccess(registerResponse: response);
      } catch (_) {
        yield RegisterBusinessFailure(exception: _);
      }
    }

    // Check Firestore for Business Sila Handle
    else if (event is DivvyCheckForAdminHandle) {
      UserModel admin = await _firebaseService.getBusinessUser();
      if (admin.silaHandle != null) {
        //Handle exists in Divvy and Sila ecosysten
        yield SilaAdminHandleExists();
      } else {
        yield SilaAdminHandleDoesNotExist();
      }
    }

    // Create Sila handle for Admin
    else if (event is CreateAdminHandle) {
      UserModel admin = await _firebaseService.getBusinessUser();
      String handle = createHandle(admin);
      yield CreateAdminHandleSuccess(handle: handle);
    }

    // Check Sila to see if valid handle
    else if (event is SilaCheckAdminHandle) {
      final RegisterResponse response =
          await silaRepository.checkHandle(event.handle);
      if (response.success != true) {
        yield AdminHandleTaken(checkHandleResponse: response);
      } else {
        yield CheckAdminHandleSuccess(
            checkHandleResponse: response, handle: event.handle);
      }
    }

    // Register Admin with Sila and store handle in Firebase
    else if (event is SilaRegisterAdmin) {
      yield RegisterLoadInProgress();
      try {
        final RegisterResponse response =
            await silaBusinessRepository.registerBusinessAdmin(event.handle);
        Map<String, String> data = {"silaHandle": event.handle};
        _firebaseService.addDataToBusinessUserDocument(collection, data);
        yield RegisterAdminSuccess(registerResponse: response);
      } catch (_) {
        yield RegisterAdminFailure(exception: _);
      }
    }

    // Get roles from sila and link admin to each
    else if (event is LinkBusinessMembers) {
      try {
        final GetBusinessRolesResponse getBusinessRolesResponse =
            await silaBusinessRepository.getBusinessRoles();

        List<LinkBusinessMemberResponse> linkBusinessMembers = [];
        linkBusinessMembers = await silaBusinessRepository
            .linkBusinessMember(getBusinessRolesResponse);
        yield LinkBusinessMembersSuccess(
            linkBusinessMembers: linkBusinessMembers);
      } catch (_) {
        yield LinkBusinessMembersFailure(exception: _);
      }
    }

    // Request KYB
    else if (event is RequestKYB) {
      try {
        RegisterResponse requestKYBResponse =
            await silaBusinessRepository.requestKYB();
        yield RequestKybSuccess(requestKYBResponse: requestKYBResponse);
      } catch (_) {
        yield RequestKybFailure(exception: _);
      }
    }

    // Check KYB
    else if (event is CheckKYB) {
      try {
        CheckKybResponse checkKYBResponse =
            await silaBusinessRepository.checkKYB();
        while (checkKYBResponse.verificationStatus.contains("pending")) {
          yield CheckKybPending();
          checkKYBResponse = await silaBusinessRepository.checkKYB();
        }
        if (checkKYBResponse.verificationStatus == "passed") {
          yield CheckKybSuccess(checkKYBResponse: checkKYBResponse);
        } else {
          yield CheckKybNotPassed(checkKYBResponse: checkKYBResponse);
        }
      } catch (_) {
        yield CheckKybFailure(exception: _);
      }
    }

    // Certify Beneficial Owner with Sila
    else if (event is CertifyBeneficialOwner) {
      try {
        GetEntityResponse getEntityResponse =
            await silaBusinessRepository.getEntity();
        yield GetEntitySuccess(getEntityResponse: getEntityResponse);

        String token = getToken(getEntityResponse);
        if (token != null) {
          final CertifyBeneficialOwnerResponse certifyBeneficialOwnerResponse =
              await silaBusinessRepository.certifyBeneficialOwner(token);
          yield CertifyBeneficialOwnerSuccess(
              certifyBeneficialOwnerResponse: certifyBeneficialOwnerResponse);
        }
      } catch (_) {
        CertifyBeneficialOwnerFailure(exception: _);
      }
    }

    // Certify Business with Sila
    else if (event is CertifyBusiness) {
      try {
        UserModel admin = await _firebaseService.getUserData();
        final CertifyBeneficialOwnerResponse certifyBusinessResponse =
            await silaBusinessRepository.certifyBusiness();
        yield CertifyBusinessSuccess(
            certifyBusinessResponse: certifyBusinessResponse);
        _firebaseService
            .addDataToBusinessUserDocument('users', {"kyc_status": 'passed'});
        _firebaseService
            .addDataToFirestoreDocument('users', {"kyc_status": 'passed'});
        yield CreateSilaBusinessSuccess(user: admin);
      } catch (_) {
        yield CertifyBusinessFailure(exception: _);
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }

  String createHandle(UserModel user) {
    String handle = "";
    handle += "divvysafe-" + user.name.replaceAll(' ', '').replaceAll('\'', '');
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
