import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/sila/models/bank_account_balance_response.dart';
import 'package:divvy/sila/models/get_entity/get_entity_response.dart';
import 'package:divvy/sila/models/get_transactions_response.dart';
import 'package:divvy/sila/models/kyb/certify_business_owner_response.dart';
import 'package:divvy/sila/models/kyb/check_kyb_response/check_kyb_response.dart';
import 'package:divvy/sila/models/kyb/get_business_roles_response/get_business_roles_response.dart';
import 'package:divvy/sila/models/kyb/get_business_type_response.dart';
import 'package:divvy/sila/models/kyb/link_business_member_response.dart';
import 'package:divvy/sila/models/kyb/naics_categories_models/get_naics_categories_response.dart';
import 'package:divvy/sila/models/kyb/register_response.dart';
import 'package:divvy/sila/models/models.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/ethereum_service.dart';
import 'package:divvy/sila/models/redeem_sila_model.dart';
import 'package:divvy/sila/models/transfer_sila_response.dart';
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class SilaApiClient {
  http.Client httpClient;
  EthereumService eth = EthereumService();

  // TODO: this needs to be singleton someday.
  SilaApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Keys> getKeys() async {
    DocumentSnapshot _documentSnapshot =
        await Firestore.instance.collection('keys').document('divvy_api').get();
    return Keys.fromEntity(KeysEntity.fromSnapshot(_documentSnapshot));
  }

  /// Registers user Handle and creates and stores wallet addres in firebase
  /// is SILA ecosystem
  ///
  /// Requires the user handle and the UserModel to fill out body
  ///
  Future<RegisterResponse> register(String userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"user_id": userID};

    final url = '${_keys.baseUrl}/register_user';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error with /register ' + response.body);
    }

    final silaHandleResponse = jsonDecode(response.body);
    return RegisterResponse.fromJson(silaHandleResponse);
  }

  Future<RegisterResponse> requestKYC(userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"user_id": userID};

    final url = '${_keys.baseUrl}/request_kyc';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /request_kyc');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return RegisterResponse.fromJson(silaHandleResponse);
  }

  Future<CheckKybResponse> checkKYB(String userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"user_id": userID};

    final url = '${_keys.baseUrl}/check_kyc';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /check_kyb');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return CheckKybResponse.fromJson(silaHandleResponse);
  }

  Future<CheckKycResponse> checkKYC(String userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"user_id": userID};

    final url = '${_keys.baseUrl}/check_kyc';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /check_KYC');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return CheckKycResponse.fromJson(silaHandleResponse);
  }

  Future<BankAccountBalanceResponse> getBankAccounts(String userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"user_id": userID};

    final url = '${_keys.baseUrl}/0.2/get_bank_accounts';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /get_Accounts');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return BankAccountBalanceResponse.fromJson(silaHandleResponse);
  }

  Future<LinkAccountResponse> linkAccount(
      String userID, String plaidPublicToken) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {
      "user_id": userID,
      "token": plaidPublicToken,
    };

    final url = '${_keys.baseUrl}/link_bank_account';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    final jsonResponse = jsonDecode(response.body);
    final LinkAccountResponse linkAccountResponse =
        LinkAccountResponse.fromJson(jsonResponse);

    if (response.statusCode != 200) {
      throw Exception(linkAccountResponse.message);
    }

    return linkAccountResponse;
  }

  Future<IssueSilaResponse> issueSila(String userID, double amount) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {
      "user_id": userID,
      "amount": amount,
    };

    final url = '${_keys.baseUrl}/issue_sila';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body));
    }

    final silaHandleResponse = jsonDecode(response.body);
    return IssueSilaResponse.fromJson(silaHandleResponse);
  }

  Future<GetSilaBalanceResponse> getSilaBalance(String userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();
    Map body = {"user_id": userID};

    final url = '${_keys.baseUrl}/0.2/get_sila_balance';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body));
    }

    final silaHandleResponse = jsonDecode(response.body);
    return GetSilaBalanceResponse.fromJson(silaHandleResponse);
  }

  Future<GetTransactionsResponse> getTransactions(String userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {
      "user_id": userID,
    };

    final url = '${_keys.baseUrl}/get_transactions';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body));
    }

    final silaHandleResponse = jsonDecode(response.body);
    return GetTransactionsResponse.fromJson(silaHandleResponse);
  }

  Future<GetEntityResponse> getEntity(String userID, bool kyb) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"user_id": userID, "kyb": kyb};

    final url = '${_keys.baseUrl}/get_entity';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /get_entity');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return GetEntityResponse.fromJson(silaHandleResponse);
  }

  Future<UpdateUserInfo> updateEmail(String userID, String newEmail) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {
      "email": newEmail,
    };

    final url = '${_keys.baseUrl}/update/email';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /update_email');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  Future<UpdateUserInfo> updatePhone(String userID, String newPhone) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"phone": newPhone};

    final url = '${_keys.baseUrl}/update/phone';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /update_phone');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  ///You can only update SSN before KYC is processed.
  ///
  ///Only call this if you are writing a flow where KYC hasnt been process yet
  ///or KYC has failed
  Future<UpdateUserInfo> updateIdentity(String userID, String ssn) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {
      "alias": "SSN",
      "value": ssn,
    };

    final url = '${_keys.baseUrl}/update/identity';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /update_identity');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  Future<UpdateUserInfo> updateAddress(
      String userID, Map<String, String> address) async {
    Keys _keys = Keys();
    _keys = await getKeys();
    var _addressList = address.values.toList();
    Map body = {
      "address_alias": 'Main Address',
      "street_address_1": _addressList[0],
      "street_address_2": _addressList[1],
      "city": _addressList[2],
      "state": _addressList[3],
      "country": _addressList[4],
      "postal_code": _addressList[5],
    };

    final url = '${_keys.baseUrl}/update/address';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /update_address');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  ///You can only update Entity info before KYC is processed.
  ///
  ///Only call this if you are writing a flow where KYC hasnt been process yet
  ///or KYC has failed
  ///Entity Info: first_name, last_name, entity_name, birthdate
  Future<UpdateUserInfo> updateEntity(
      String userID, Map<String, String> entity) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    var _listEntity = entity.values.toList();

    Map body = {
      "first_name": _listEntity[0],
      "last_name": _listEntity[1],
      "entity_name": _listEntity[2],
      "birthdate": _listEntity[3]
    };

    final url = '${_keys.baseUrl}/update/entity';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /update_entity');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  Future<GetBusinessTypeResponse> getBusinessTypes() async {
    Keys _keys = Keys();
    _keys = await getKeys();

    final url = '${_keys.baseUrl}/get_business_types';
    final response = await this.httpClient.post(url);

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /get_business_types');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return GetBusinessTypeResponse.fromJson(silaHandleResponse);
  }

  Future<GetNaicsCategoriesResponse> getNaicsCategories() async {
    Keys _keys = Keys();
    _keys = await getKeys();

    final url = '${_keys.baseUrl}/get_naics_categories';
    final response = await this.httpClient.post(url);

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /get_naics_categories');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return GetNaicsCategoriesResponse.fromJson(silaHandleResponse);
  }

  /// Registers Business in SILA and creates and stores wallet address in firebase
  ///
  /// Requires the user handle and the UserModel to fill out body
  ///
  Future<KYBRegisterResponse> registerBusiness(String userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"user_id": userID};

    final url = '${_keys.baseUrl}/register_business';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /register business');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return KYBRegisterResponse.fromJson(silaHandleResponse);
  }

  Future<GetBusinessRolesResponse> getBusinessRoles() async {
    Keys _keys = Keys();
    _keys = await getKeys();

    final url = '${_keys.baseUrl}/get_business_roles';
    final response = await this.httpClient.post(url);

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /get_business_roles');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return GetBusinessRolesResponse.fromJson(silaHandleResponse);
  }

  Future<LinkBusinessMemberResponse> linkBusinessMember(
    String userID,
    String role,
  ) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    var body = {
      "user_id": userID,
      "role": role,
    };

    final url = '${_keys.baseUrl}/link_business_member';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /link_business_member');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return LinkBusinessMemberResponse.fromJson(silaHandleResponse);
  }

  Future<CertifyBeneficialOwnerResponse> certifyBeneficialOwner(
      String userID, String token) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {
      "user_id": userID,
      "token": token,
    };

    final url = '${_keys.baseUrl}/certify_beneficial_owner';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /certify_beneficial_owner');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return CertifyBeneficialOwnerResponse.fromJson(silaHandleResponse);
  }

  Future<CertifyBeneficialOwnerResponse> certifyBusiness(String userID) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {"user_id": userID};

    final url = '${_keys.baseUrl}/certify_business';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception('error connecting to SILA /certify_business');
    }

    final silaHandleResponse = jsonDecode(response.body);
    return CertifyBeneficialOwnerResponse.fromJson(silaHandleResponse);
  }

  Future<RedeemSilaModel> redeemSila(String userID, int amount) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {
      "user_id": userID,
      "amount": amount,
    };

    final url = '${_keys.baseUrl}/redeem_sila';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body));
    }

    final silaHandleResponse = jsonDecode(response.body);
    return RedeemSilaModel.fromJson(silaHandleResponse);
  }

  Future<TransferSilaResponse> transferSila(String userID, double amount,
      String destinationHandle, String descriptor) async {
    Keys _keys = Keys();
    _keys = await getKeys();

    Map body = {
      "user_id": userID,
      "destination_handle": destinationHandle,
      "amount": amount * 100,
      "descriptor": descriptor,
    };

    final url = '${_keys.baseUrl}/transfer_sila';
    final response = await this.httpClient.post(
          url,
          body: json.encode(body),
        );

    if (response.statusCode != 200) {
      //throw Exception('error connecting to SILA /transfer_sila');
      throw Exception(jsonDecode(response.body)["message"]);
    }

    final silaHandleResponse = jsonDecode(response.body);
    return TransferSilaResponse.fromJson(silaHandleResponse);
  }
}
