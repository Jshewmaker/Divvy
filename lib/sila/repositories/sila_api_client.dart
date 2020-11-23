import 'dart:convert';

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
import 'package:divvy/sila/models/update_user_info/update_user_info_response.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class SilaApiClient {
  String baseUrl = 'https://sandbox.silamoney.com';
  http.Client httpClient;
  EthereumService eth = EthereumService();
  final String divvyPrivateKey =
      '4fe8271eb3ee4b89d2f8c9da42ba3229672adad2fd9a9245dbf1181a3f7451cd';
  String authHandle = "divvy.silamoney.eth";

  // TODO: this needs to be singleton someday.
  SilaApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  /// Check if a SILA hande is avaible
  ///
  /// This does not regiester the handle, just makes sure it is avaible
  Future<RegisterResponse> checkHandle(String handle) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": handle,
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
    };
    String authsignature = await eth.signing(body, divvyPrivateKey);
    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authsignature,
    };

    final silaURL = '$baseUrl/0.2/check_handle';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /check_handle');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return RegisterResponse.fromJson(silaHandleResponse);
  }

  /// Registers user Handle and creates and stores wallet addres in firebase
  /// is SILA ecosystem
  ///
  /// Requires the user handle and the UserModel to fill out body
  ///
  Future<RegisterResponse> register(String handle, UserModel user,
      {bool isbusinessUser = false}) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;

    String address = await eth.createEthWallet(isBusinessUser: isbusinessUser);

    Map body = {
      "header": {
        "reference": '1',
        "created": utcTime,
        "auth_handle": authHandle,
        //"user_handle": user.silaHandle,
        "user_handle": handle,
        "version": "0.2",
        "crypto": "ETH",
      },
      "message": "entity_msg",
      "address": {
        "address_alias": "home",
        "street_address_1": user.streetAddress,
        "city": user.city,
        "state": user.state,
        "country": user.country,
        "postal_code": user.postalCode,
      },
      "identity": {
        "identity_alias": "SSN",
        "identity_value": user.identityValue.replaceAll(r'-', '')
      },
      "contact": {
        "phone": user.phone,
        "contact_alias": "",
        "email": user.email,
      },
      "crypto_entry": {
        "crypto_alias": "Address 1",
        "crypto_address": "$address",
        "crypto_code": "ETH"
      },
      "entity": {
        "birthdate": user.dateOfBirthYYYYMMDD,
        "entity_name": "",
        "first_name": user.name.split(" ")[0],
        "last_name": user.name.split(" ")[1],
        "relationship": "user"
      }
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
    };

    final silaURL = '$baseUrl/0.2/register';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /register');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return RegisterResponse.fromJson(silaHandleResponse);
  }

  Future<RegisterResponse> requestKYC(
      String handle, String userPrivateKey) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": "$handle.silamoney.eth",
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      }
    };
    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/request_kyc';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /request_kyc');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return RegisterResponse.fromJson(silaHandleResponse);
  }

  Future<RegisterResponse> requestKYB(
      String handle, String userPrivateKey) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": handle,
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      }
    };
    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/request_kyc';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /request_kyb');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return RegisterResponse.fromJson(silaHandleResponse);
  }

  Future<CheckKybResponse> checkKYB(
      String handle, String userPrivateKey) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": "$handle.silamoney.eth",
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      }
    };
    String authSignature = await eth.signing(body, divvyPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
    };

    final silaURL = '$baseUrl/0.2/check_kyc';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /check_kyb');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return CheckKybResponse.fromJson(silaHandleResponse);
  }

  Future<CheckKycResponse> checkKYC(
      String handle, String userPrivateKey) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": "$handle.silamoney.eth",
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
      "message": "header_msg"
    };
    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/check_kyc';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /check_KYC');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return CheckKycResponse.fromJson(silaHandleResponse);
  }

  Future<BankAccountBalanceResponse> getBankAccountBalance(
      String handle, String userPrivateKey) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": "$handle.silamoney.eth",
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
      "account_name": "$handle plaid account"
    };
    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/get_account_balance';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /get_account_balance');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return BankAccountBalanceResponse.fromJson(silaHandleResponse);
  }

  Future<LinkAccountResponse> linkAccount(
      String handle, String userPrivateKey, String plaidPublicToken) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;
    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": "$handle.silamoney.eth",
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
      "message": "link_account_msg",
      "public_token": plaidPublicToken,
      "account_name": "$handle plaid account",
    };
    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/link_account';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /link_account');
    }

    final response = jsonDecode(silaResponse.body);
    return LinkAccountResponse.fromJson(response);
  }

  Future<IssueSilaResponse> issueSila(
      String handle, String userPrivateKey) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": "$handle.silamoney.eth",
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
      "message": "issue_msg",
      "amount": 100,
      "account_name": "$handle plaid account",
      "descriptor": "showing that transactions are not working",
      "processing_type": "STANDARD_ACH"
    };
    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/issue_sila';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /issue_sila');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return IssueSilaResponse.fromJson(silaHandleResponse);
  }

  Future<GetSilaBalanceResponse> getSilaBalance(String address) async {
    Map body = {"address": address};

    Map<String, String> header = {
      "Content-Type": "application/json",
    };

    final silaURL = '$baseUrl/0.2/get_sila_balance';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /get_sila_balance');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return GetSilaBalanceResponse.fromJson(silaHandleResponse);
  }

  Future<GetTransactionsResponse> getTransactions(
      String handle, userPrivateKey) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": "$handle.silamoney.eth",
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
      "message": "get_transactions_msg",
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/get_transactions';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /get_transactions');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return GetTransactionsResponse.fromJson(silaHandleResponse);
  }

  Future<GetEntityResponse> getEntity(
      String handle, String userPrivateKey) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": handle.split(" ")[0]
      }
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/get_entity';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /get_entity');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return GetEntityResponse.fromJson(silaHandleResponse);
  }

  Future<UpdateUserInfo> updateEmail(String handle, String userPrivateKey,
      String uuid, String newEmail) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": handle
      },
      "uuid": uuid,
      "email": newEmail,
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/update/email';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /update_email');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  Future<UpdateUserInfo> updatePhone(String handle, String userPrivateKey,
      String uuid, String newPhone) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": handle
      },
      "uuid": uuid,
      "phone": newPhone
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/update/phone';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /update_phone');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  ///You can only update SSN before KYC is processed.
  ///
  ///Only call this if you are writing a flow where KYC hasnt been process yet
  ///or KYC has failed
  Future<UpdateUserInfo> updateIdentity(
      String handle, String userPrivateKey, String uuid, String ssn) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": handle
      },
      "uuid": uuid,
      "identity_alias": "SSN",
      "identity_value": ssn
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/update/identity';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /update_identity');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  Future<UpdateUserInfo> updateAddress(String handle, String userPrivateKey,
      String uuid, Map<String, String> address) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;
    var _addressList = address.values.toList();
    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": handle
      },
      "uuid": uuid,
      "address_alias": 'Main Address',
      "street_address_1": _addressList[0],
      "street_address_2": _addressList[1],
      "city": _addressList[2],
      "state": _addressList[3],
      "country": _addressList[4],
      "postal_code": _addressList[5],
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/update/address';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /update_address');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  ///You can only update Entity info before KYC is processed.
  ///
  ///Only call this if you are writing a flow where KYC hasnt been process yet
  ///or KYC has failed
  ///Entity Info: first_name, last_name, entity_name, birthdate
  Future<UpdateUserInfo> updateEntity(
      String handle, String userPrivateKey, Map<String, String> entity) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;
    var _listEntity = entity.values.toList();

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": handle
      },
      "first_name": _listEntity[0],
      "last_name": _listEntity[1],
      "entity_name": _listEntity[2],
      "birthdate": _listEntity[3]
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, userPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
    };

    final silaURL = '$baseUrl/0.2/update/entity';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /update_entity');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return UpdateUserInfo.fromJson(silaHandleResponse);
  }

  Future<GetBusinessTypeResponse> getBusinessTypes() async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
      }
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
    };

    final silaURL = '$baseUrl/0.2/get_business_types';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /get_business_types');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return GetBusinessTypeResponse.fromJson(silaHandleResponse);
  }

  Future<GetNaicsCategoriesResponse> getNaicsCategories() async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {"created": utcTime, "auth_handle": authHandle}
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
    };

    final silaURL = '$baseUrl/0.2/get_naics_categories';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /get_naics_categories');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return GetNaicsCategoriesResponse.fromJson(silaHandleResponse);
  }

  /// Registers Business in SILA and creates and stores wallet address in firebase
  ///
  /// Requires the user handle and the UserModel to fill out body
  ///
  Future<KYBRegisterResponse> registerBusiness(
    UserModel user,
  ) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;
    String address = await eth.createEthWallet(isBusinessUser: false);

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": user.silaHandle + ".silamoney.eth",
        "reference": "ref",
        "crypto": "ETH",
        "version": "0.2"
      },
      "message": "entity_msg",
      "identity": {
        "identity_alias": "EIN",
        "identity_value": user.identityValue
      },
      "address": {
        "address_alias": "Office",
        "street_address_1": user.streetAddress,
        "city": user.city,
        "state": user.state,
        "country": user.country,
        "postal_code": user.postalCode,
      },
      "contact": {"phone": user.phone, "email": user.email},
      "entity": {
        "type": "business",
        "entity_name": user.name,
        "business_type": user.businessType,
        "business_website": user.website,
        "doing_business_as": user.doingBusinessAsName,
        "naics_code": user.naicsCode
      },
      "crypto_entry": {
        "crypto_code": "ETH",
        "crypto_address": address,
      }
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
    };

    final silaURL = '$baseUrl/0.2/register';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /register business');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return KYBRegisterResponse.fromJson(silaHandleResponse);
  }

  Future<GetBusinessRolesResponse> getBusinessRoles() async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {"created": utcTime, "auth_handle": authHandle}
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
    };

    final silaURL = '$baseUrl/0.2/get_business_roles';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /get_business_roles');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return GetBusinessRolesResponse.fromJson(silaHandleResponse);
  }

  Future<LinkBusinessMemberResponse> linkBusinessMember(
      String role, UserModel businessUser, UserModel user,
      {double ownershipStake}) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;
    Map body;

    if (ownershipStake != null) {
      body = {
        "header": {
          "created": utcTime,
          "auth_handle": authHandle,
          "user_handle": user.silaHandle,
          "business_handle": businessUser.silaHandle
        },
        "role": role,
        "ownership_stake": 66.7
      };
    } else {
      body = {
        "header": {
          "created": utcTime,
          "auth_handle": authHandle,
          "user_handle": user.silaHandle,
          "business_handle": businessUser.silaHandle
        },
        "role": role,
      };
    }

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, user.privateKey);
    String businessSignature = await eth.signing(body, businessUser.privateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
      "businesssignature": businessSignature,
    };

    final silaURL = '$baseUrl/0.2/link_business_member';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /link_business_member');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return LinkBusinessMemberResponse.fromJson(silaHandleResponse);
  }

  Future<CertifyBusinessOwnerResponse> certifyBusinessOwner(
      UserModel user, UserModel businessUser, String token) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": user.silaHandle,
        "business_handle": businessUser.silaHandle
      },
      "member_handle": user.silaHandle,
      "certification_token": token,
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, user.privateKey);
    String businessSignature = await eth.signing(body, businessUser.privateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
      "businesssignature": businessSignature,
    };

    final silaURL = '$baseUrl/0.2/certify_beneficial_owner';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /certify_beneficial_owner');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return CertifyBusinessOwnerResponse.fromJson(silaHandleResponse);
  }

  Future<CertifyBusinessOwnerResponse> certifyBusiness(
      UserModel user, UserModel businessUser) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": authHandle,
        "user_handle": user.silaHandle,
        "business_handle": businessUser.silaHandle,
      }
    };

    String authSignature = await eth.signing(body, divvyPrivateKey);
    String userSignature = await eth.signing(body, user.privateKey);
    String businessSignature = await eth.signing(body, businessUser.privateKey);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authSignature,
      "usersignature": userSignature,
      "businesssignature": businessSignature,
    };

    final silaURL = '$baseUrl/0.2/certify_business';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: header,
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA /certify_business');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return CertifyBusinessOwnerResponse.fromJson(silaHandleResponse);
  }
}
