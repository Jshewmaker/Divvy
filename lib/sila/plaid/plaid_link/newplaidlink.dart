import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlaidLink {
  Configuration _configuration;

  PlaidLink() {
    bool plaidSandbox = true;
    // String clientID = "5cb68305fede9b00136aebb1";
    // String secret = "54621c4436011f708c7916587c6fa8";

    Configuration configuration = Configuration(
        plaidPublicKey: 'fa9dd19eb40982275785b09760ab79',
        plaidBaseUrl: 'https://cdn.plaid.com/link/v2/stable/link.html',
        plaidEnvironment: plaidSandbox ? 'sandbox' : 'production',
        environmentPlaidPathAccessToken:
            'https://sandbox.plaid.com/item/public_token/exchange',
        // plaidClientId: clientID,
        // secret: plaidSandbox ? secret : '',
        clientName: 'ClientName',
        webhook: 'http://requestb.in',
        product: 'auth',
        selectAccount: 'true');
    this._configuration = configuration;
  }

  launch(
    BuildContext context,
    success(Result result),
  ) {
    _WebViewPage _webViewPage = new _WebViewPage();
    _webViewPage._init(this._configuration, success, context);

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return _webViewPage.build(context);
    }));
  }
}

class _WebViewPage {
  String _url;
  Function(Result) _success;
  // ignore: unused_field
  Configuration _config;
  BuildContext _context;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  _init(Configuration config, success(Result result), BuildContext context) {
    this._success = success;
    this._config = config;
    this._context = context;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _url = config.plaidBaseUrl +
        '?isWebview=true' +
        '&isMobile=true' +
        '&clientName=Your%20App' +
        '&env=' +
        config.plaidEnvironment +
        '&key=' +
        config.plaidPublicKey +
        '&product=auth' +
        '&language=en' +
        '&countryCodes=US,CA' +
        '&webhook=https://requestb.in' +
        '&linkCustomizationName=default';
    //  debugPrint('init plaid: ' + _url);
  }

  _parseUrl(String url) {
    if (url?.isNotEmpty != null) {
      Uri uri = Uri.parse(url);
      //  debugPrint('PLAID uri: ' + uri.toString());
      Map<String, String> queryParams = uri.queryParameters;

      _processParams(queryParams, url);
    }
  }

  _processParams(Map<String, String> queryParams, String url) async {
    if (queryParams != null) {
      String eventName = queryParams['event_name'] ?? 'unknown';
      debugPrint("PLAID Event name: " + eventName);

      if (eventName == 'EXIT' || (url?.contains('/exit?') ?? false)) {
        this._closeWebView();
      } else if (eventName == 'CONNECTED') {
        debugPrint('DOG');
      } else if (eventName == 'HANDOFF') {
        this._closeWebView();
      }
      dynamic token = queryParams['public_token'];
      dynamic accountId = queryParams['account_id'];
      if (token != null && accountId != null) {
        this._success(Result(token, accountId, queryParams));
      }
    }
  }

  _closeWebView() {
    if (_context != null && Navigator.canPop(_context)) {
      Navigator.pop(_context);
    }
  }

  Widget build(BuildContext context) {
    var webView = new WebView(
      initialUrl: _url,
      debuggingEnabled: true,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (NavigationRequest navigation) {
        print('Navigation: ' + navigation.url);
        if (navigation.url.contains('plaidlink://')) {
          this._parseUrl(navigation.url);

          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );

    return Scaffold(body: webView);
  }
}

class Configuration {
  String plaidPublicKey;
  String plaidBaseUrl;
  String plaidEnvironment;
  String environmentPlaidPathAccessToken;
  String clientName;
  String webhook;
  String product;
  String selectAccount;

  Configuration({
    @required this.plaidPublicKey,
    @required this.plaidBaseUrl,
    @required this.plaidEnvironment,
    @required this.environmentPlaidPathAccessToken,
    @required this.clientName,
    @required this.webhook,
    @required this.product,
    @required this.selectAccount,
  });
}

class Result {
  String token;
  String accountId;
  dynamic response;

  Result(this.token, this.accountId, this.response);
}
