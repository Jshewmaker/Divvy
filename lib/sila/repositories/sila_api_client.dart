import 'dart:convert';
import 'dart:math';

import 'package:divvy/sila/models/models.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/sila/ethereum_service.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';

class SilaApiClient {
  static const baseUrl = 'https://sandbox.silamoney.com';
  final http.Client httpClient;
  EthereumService eth = EthereumService();

  // TODO: this needs to be singleton someday.
  SilaApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Handle> checkHandle(String handle) async {
    var utcTime = DateTime.now().millisecondsSinceEpoch;

    Map body = {
      "header": {
        "created": utcTime,
        "auth_handle": "divvy",
        "user_handle": handle,
        "version": "0.2",
        "crypto": "ETH",
        "reference": "ref"
      },
    };
    String authsignature = await eth.signing(body);
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

  Future<Handle> register(
    String handle,
    User user,
  ) async {
    
    var utcTime = DateTime.now().millisecondsSinceEpoch;
    var address = await eth.createAddress();
    

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

    String authsignature = await eth.signing(body);

    Map<String, String> header = {
      "Content-Type": "application/json",
      "authsignature": authsignature,
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
}
