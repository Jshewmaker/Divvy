import 'dart:convert';

import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';

class SilaApiClient {
  static const baseUrl = 'https://sandbox.silamoney.com';
  final http.Client httpClient;

  SilaApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<CheckHandle> checkHandle(String handle) async {
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
     String authsignature = await signing(body);
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
      throw Exception('error connecting to SILA');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return CheckHandle.fromJson(silaHandleResponse);
  }

  Future<String> signing(Map message) async {
    var privateKey =
        '4fe8271eb3ee4b89d2f8c9da42ba3229672adad2fd9a9245dbf1181a3f7451cd';
  
    var encodedMessage = jsonEncode(message);

    Credentials key = EthPrivateKey.fromHex(privateKey);
    key
        .extractAddress()
        .then((value) => print('key: ' + hex.encode(value.addressBytes)));
    var wtf = key.sign(utf8.encode(encodedMessage));
    String signing = await wtf.then((value) => hex.encode(value).toString());

    return signing;
  }
}
