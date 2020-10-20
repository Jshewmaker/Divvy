import 'dart:convert';

import 'package:divvy/sila/models/models.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/ethereum_service.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class SilaApiClient {
  static const baseUrl = 'https://sandbox.silamoney.com';
  final http.Client httpClient;
  EthereumService eth = EthereumService();
  final String divvyPrivateKey =
      '4fe8271eb3ee4b89d2f8c9da42ba3229672adad2fd9a9245dbf1181a3f7451cd';

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
        "auth_handle": "divvy",
        "user_handle": "divvy-$handle",
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

  /// Registers Handle is SILA ecosystem
  ///
  /// Requires the user handle and the UserModel to fill out body
  ///
  Future<RegisterResponse> register(
    String handle,
    UserModel user,
  ) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;
    String address = await eth.createEthWallet();

    Map body = {
      "header": {
        "reference": '1',
        "created": utcTime,
        "auth_handle": "divvy",
        "user_handle": "divvy-$handle",
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
        "identity_value": user.ssn.replaceAll(r'-', '')
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
        "auth_handle": "divvy.silamoney.eth",
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
      throw Exception('error connecting to SILA /request_handle');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return RegisterResponse.fromJson(silaHandleResponse);
  }

  Future<CheckKycResponse> checkKYC(
      String handle, String userPrivateKey) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": "divvy.silamoney.eth",
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

  Future<LinkAccountResponse> linkAccount(
      String handle, String userPrivateKey, String plaidPublicToken) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;
    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": "divvy.silamoney.eth",
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
        "auth_handle": "divvy.silamoney.eth",
        "user_handle": "$handle.silamoney.eth",
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
      "message": "issue_msg",
      "amount": 100420,
      "account_name": "$handle plaid account",
      "descriptor": "optional transaction descriptor",
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
}
