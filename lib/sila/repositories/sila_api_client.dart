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

  // TODO: this needs to be singleton someday.
  SilaApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  /// Check if a SILA hande is avaible
  ///
  /// This does not regiester the handle, just makes sure it is avaible
  Future<Handle> checkHandle(String handle) async {
    var privateKey =
        '4fe8271eb3ee4b89d2f8c9da42ba3229672adad2fd9a9245dbf1181a3f7451cd';
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
    String authsignature = await eth.signing(body, privateKey);
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
    return Handle.fromJson(silaHandleResponse);
  }

  /// Registers Handle is SILA ecosystem
  ///
  /// Requires the user handle and the UserModel to fill out body
  ///
  Future<Handle> register(
    String handle,
    UserModel user,
  ) async {
    var privateKey =
        '4fe8271eb3ee4b89d2f8c9da42ba3229672adad2fd9a9245dbf1181a3f7451cd';

    var utcTime = DateTime.now().millisecondsSinceEpoch;
    var address = await eth.createAddress(handle);

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

    String authSignature = await eth.signing(body, privateKey);

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
    return Handle.fromJson(silaHandleResponse);
  }

  Future<Handle> requestKYC(String handle, String signature, String wallet) async {
    int utcTime = DateTime.now().millisecondsSinceEpoch;
    var privateKey =
        '4fe8271eb3ee4b89d2f8c9da42ba3229672adad2fd9a9245dbf1181a3f7451cd';

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": "divvy",
        "user_handle": handle,
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
      "message": "header_msg",
    };
    String authSignature = await eth.signing(body, privateKey);
    String userSignature = await eth.signing( body, signature);

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
      throw Exception('error connecting to SILA /check_handle');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return Handle.fromJson(silaHandleResponse);
  }
}
