import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/models/kyb/kyb.dart';
import 'package:divvy/sila/models/kyb/naics_categories_models/get_naics_categories_response.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:meta/meta.dart';

class SilaBusinessRepository {
  final SilaApiClient silaApiClient;
  FirebaseService _firebaseService;

  SilaBusinessRepository({@required this.silaApiClient}) {
    _firebaseService = FirebaseService();
    assert(silaApiClient != null);
  }

  Future<GetBusinessTypeResponse> getBusinessTypes() async {
    final GetBusinessTypeResponse response =
        await silaApiClient.getBusinessTypes();
    return response;
  }

  Future<GetNaicsCategoriesResponse> getNaicsCategories() async {
    final GetNaicsCategoriesResponse response =
        await silaApiClient.getNaicsCategories();
    return response;
  }
}
