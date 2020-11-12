import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/get_business_roles_response.dart';
import 'package:divvy/sila/models/kyb/kyb.dart';
import 'package:divvy/sila/models/kyb/naics_categories_models/get_naics_categories_response.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:meta/meta.dart';

class SilaBusinessRepository {
  final SilaApiClient silaApiClient;
  FirebaseService _firebaseService;

  SilaBusinessRepository({@required this.silaApiClient}) {
    _firebaseService = FirebaseService();
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
        await silaApiClient.registerBusiness(user.silaHandle, user);
    return response;
  }

  ///Gets a list of valid business roles that can be used to link individuals to businesses.
  Future<GetBusinessRolesResponse> getBusinessRoles() async {
    return await silaApiClient.getBusinessRoles();
  }

  Future<RegisterResponse> registerBusinessRole(UserModel user) async {
    UserModel user = await _firebaseService.getBusinessUser();
    return await silaApiClient.register(user.name, user);
  }
}
