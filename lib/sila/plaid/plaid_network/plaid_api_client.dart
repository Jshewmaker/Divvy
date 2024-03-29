import 'dart:convert';

import 'package:divvy/sila/plaid/models/plaid_public_token_exchange_response_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class PlaidAPIClient {
  static const baseUrl = 'https://sandbox.plaid.com';
  final http.Client httpClient;

  Map plaidKeys = {};

  PlaidAPIClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<PlaidPublicTokenExchangeResponseModel>
      exchangePlaidPublicTokenForAccessToken(String publicToken) async {
    plaidKeys['public_token'] = publicToken;
    plaidKeys.addAll(plaidKeys);
    final plaidLinkURL = '$baseUrl/item/public_token/exchange';
    final plaidLinkResponse = await this.httpClient.post(
          plaidLinkURL,
          headers: {"Content-Type": "application/json"},
          body: json.encode(plaidKeys),
        );

    if (plaidLinkResponse.statusCode != 200) {
      throw Exception('error connecting to Plaid Link');
    }

    final plaidLinkTokensJson = jsonDecode(plaidLinkResponse.body);
    return PlaidPublicTokenExchangeResponseModel.fromJson(plaidLinkTokensJson);
  }
}
