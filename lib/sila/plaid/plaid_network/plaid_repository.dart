

import 'dart:async';

import 'package:divvy/sila/plaid/models/plaid_public_token_exchange_response_model.dart';
import 'package:divvy/sila/plaid/plaid_network/plaid_api_client.dart';
import 'package:meta/meta.dart';

class PlaidRepository {
  final PlaidAPIClient plaidAPIClient;

  PlaidRepository({@required this.plaidAPIClient})
      : assert(plaidAPIClient != null);

  Future<PlaidPublicTokenExchangeResponseModel> getAccessToken(
      String publicToken) async {
    final PlaidPublicTokenExchangeResponseModel accessToken =
        await plaidAPIClient
            .exchangePlaidPublicTokenForAccessToken(publicToken);
    return accessToken;
  }


}
