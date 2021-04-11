import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/models/kyb/check_kyb_response/check_kyb_response.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/get_business_roles_response.dart';
import 'package:divvy/sila/models/kyb/kyb.dart';
import 'package:divvy/sila/models/kyb/link_business_member_response.dart';
import 'package:divvy/sila/models/kyb/naics_categories_models/get_naics_categories_response.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class SilaBusinessRepository {
  final SilaApiClient silaApiClient;
  FirebaseService _firebaseService;
  FirebaseAuth _firebaseAuth;

  SilaBusinessRepository({@required this.silaApiClient}) {
    _firebaseService = FirebaseService();
    _firebaseAuth = FirebaseAuth.instance;
    assert(silaApiClient != null);
  }

  ///Returns a list of business types for a user to select during business
  ///registration
  Future<GetBusinessTypeResponse> getBusinessTypes() async {
    final GetBusinessTypeResponse response =
        await silaApiClient.getBusinessTypes();
    return response;
  }

  ///Returns a list of NAICS categories for a user to select during business
  ///registration
  Future<GetNaicsCategoriesResponse> getNaicsCategories() async {
    final GetNaicsCategoriesResponse response =
        await silaApiClient.getNaicsCategories();
    return response;
  }

  Future<KYBRegisterResponse> registerKYB() async {
    UserModel user = await _firebaseService.getUserData();

    final KYBRegisterResponse response =
        await silaApiClient.registerBusiness(user, user.silaHandle);
    return response;
  }

  ///Gets a list of valid business roles that can be used to link individuals to businesses.
  Future<GetBusinessRolesResponse> getBusinessRoles() async {
    return await silaApiClient.getBusinessRoles();
  }

  Future<RegisterResponse> registerBusinessAdmin(UserModel user) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return await silaApiClient.register(user.uid, isbusinessUser: true);
  }

  Future<List<LinkBusinessMemberResponse>> linkBusinessMember(
      GetBusinessRolesResponse getBusinessRolesResponse) async {
    UserModel businessUser = await _firebaseService.getUserData();
    UserModel user = await _firebaseService.getBusinessUser();
    List<LinkBusinessMemberResponse> responses = [];
    for (int i = 0; i < getBusinessRolesResponse.businessRoles.length; i++) {
      LinkBusinessMemberResponse response =
          await silaApiClient.linkBusinessMember(
              getBusinessRolesResponse.businessRoles[i].name,
              businessUser,
              user);
      responses.add(response);
    }
    return responses;
  }

  ///Request Know Your BUSINESS in SILA ecosystem
  Future<RegisterResponse> requestKYB() async {
    UserModel user = await _firebaseService.getUserData();

    return await silaApiClient.requestKYB(user.silaHandle, user.privateKey);
  }

  ///Check Status of Know Your BUSINESS in SILA ecosystem
  Future<CheckKybResponse> checkKYB() async {
    UserModel user = await _firebaseService.getUserData();

    final CheckKybResponse response =
        await silaApiClient.checkKYB(user.silaHandle, user.privateKey);
    return response;
  }

  Future<GetEntityResponse> getEntity() async {
    UserModel user = await _firebaseService.getBusinessUser();
    return silaApiClient.getEntity(user.silaHandle, user.privateKey);
  }

  Future<CertifyBeneficialOwnerResponse> certifyBeneficialOwner(
      String token) async {
    UserModel user = await _firebaseService.getBusinessUser();
    UserModel businessUser = await _firebaseService.getUserData();
    return silaApiClient.certifyBeneficialOwner(user, businessUser, token);
  }

  Future<CertifyBeneficialOwnerResponse> certifyBusiness() async {
    UserModel user = await _firebaseService.getBusinessUser();
    UserModel businessUser = await _firebaseService.getUserData();
    return silaApiClient.certifyBusiness(user, businessUser);
  }
}
