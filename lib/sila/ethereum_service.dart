import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto_keys/crypto_keys.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';
import 'package:authentication_repository/authentication_repository.dart';

class EthereumService {
  FirebaseService _firebaseService;
  EthereumService() {
    this._firebaseService = FirebaseService();
  }

  Future<String> signing(Map message, String privateKey) async {
    var encodedMessage = jsonEncode(message);

    Credentials key = EthPrivateKey.fromHex(privateKey);
    key
        .extractAddress()
        .then((value) => print('key: ' + hex.encode(value.addressBytes)));
    var wtf = key.sign(utf8.encode(encodedMessage));
    String signing = await wtf.then((value) => hex.encode(value).toString());

    return signing;
  }

  Future<String> createAddress(String handle) async {
    String collection = "users";
    var data;
    // var mnemonic = bip39.generateMnemonic({64});
    String privateKey = //bip39.mnemonicToSeedHex(mnemonic);
        "badba7368134dcd61c60f9b56979c09196d03f5891a20c1557b1afac0202a97c";

    data = {"privateKey": privateKey};

    _firebaseService.addDataToFirestoreDocument('users', data);

    Credentials credentials =
        EthPrivateKey(Uint8List.fromList(privateKey.codeUnits));

    print('privateKey: ' + privateKey.toString());
    var wallet =
        await credentials.extractAddress().then((value) => value.toString());
    data = {"wallet": wallet};
    _firebaseService.addDataToFirestoreDocument(collection, data);
    return wallet;
  }
}
