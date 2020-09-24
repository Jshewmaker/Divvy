import 'dart:convert';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:divvy/app.dart';
import 'package:divvy/simple_bloc_observer.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/digests/sha3.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:convert/convert.dart';
import "package:pointycastle/pointycastle.dart";
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  var privateKey =
      'badba7368134dcd61c60f9b56979c09196d03f5891a20c1557b1afac0202a97c';
  var message = {"test": "message"};
  var encodedMessage = jsonEncode(message);

  Credentials key = EthPrivateKey.fromHex(privateKey);
  var wtf = key.sign(utf8.encode(encodedMessage));
  wtf.then((value) => print('wtf ' + hex.encode(value).toString()));

  // var result = hex.encode(key.hashCode);
  print('Result: $key');

  // //Secondn works
  // final ECDomainParameters _params = ECCurve_secp256k1();
  // final BigInt _halfCurveOrder = _params.n >> 1;
  // const int _shaBytes = 256 ~/ 8;
  // var privateKey =
  //     'badba7368134dcd61c60f9b56979c09196d03f5891a20c1557b1afac0202a97c';
  // var message = 'Sila';
  // SHA3Digest sha3 = new SHA3Digest(_shaBytes * 8);
  // var key = utf8.encode(privateKey);

  // // final hmac = HMac(SHA3Digest(256), 64)..init(KeyParameter(key));
  // // final value = hmac.process(Uint8List.fromList(utf8.encode(message)));
  // var value = sha3.process(Uint8List.fromList(utf8.encode(message)));
  // var signer = ECDSASigner(null, HMac(sha3, 64));
  // var ecKey = ECPrivateKey(bytesToInt(key), ECCurve_secp256k1());
  // signer.init(true, PrivateKeyParameter(ecKey));
  // var sig = signer.generateSignature(utf8.encode(message)) as ECSignature;

  //  if (sig.s.compareTo(_halfCurveOrder) > 0) {
  //   final canonicalisedS = _params.n - sig.s;
  //   sig = ECSignature(sig.r, canonicalisedS);
  // }

  // var result = hex.encode(value);
  // print('Result: $result');

  // var signer = ECDSASigner(SHA3Digest(256), hmac);

  // print('Signer: $signer');

  //this works kinda
  // var keyPair = new KeyPair.fromJwk({
  //   "kty": "EC",
  //   "d": "badba7368134dcd61c60f9b56979c09196d03f5891a20c1557b1afac0202a97c",
  //   "crv" : "P-256",
  // });

  // var privateKey = keyPair.privateKey;
  // var signer = privateKey.createSigner(algorithms.signing.ecdsa.sha256);

  // var json1 = {'test': 'message'};
  // var encodedJSON = jsonEncode(json1);
  // var signature = signer.sign(utf8.encode('0x65a796a4bD3AaF6370791BefFb1A86EAcfdBc3C1'));
  // print('signature: ${signature.data}');
  // print('message $encodedJSON');

  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();

  final CheckHandleRepository checkHandleRepository = CheckHandleRepository(
    silaApiClient: SilaApiClient(
      httpClient: http.Client(),
    ),
  );

  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    checkHandleRepository: checkHandleRepository,
  ));
}
