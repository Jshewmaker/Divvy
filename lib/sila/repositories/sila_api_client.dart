import 'dart:convert';

import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class SilaApiClient {
  static const baseUrl = 'https://sandbox.silamoney.com';
  final http.Client httpClient;

  SilaApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<CheckHandle> checkHandle(String handle) async {
    Map body = {"auth_handle": "divvy", "user_handle": "divvy3"};

    final silaURL = '$baseUrl/check_handle?';
    final silaResponse = await this.httpClient.post(
          silaURL,
          headers: {
            "Content-Type": "application/json",
            "X-Forward-To-URL": "https://sandbox.silamoney.com/0.2/check_handle",
            "X-Set-Epoch": "header.created",
            "X-Set-UUID": "header.reference"
            },
          body: json.encode(body),
        );

    if (silaResponse.statusCode != 200) {
      throw Exception('error connecting to SILA');
    }

    final silaHandleResponse = jsonDecode(silaResponse.body);
    return CheckHandle.fromJson(silaHandleResponse);
  }
}
