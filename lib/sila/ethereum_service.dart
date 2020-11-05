import 'dart:convert';

import 'package:bip39/bip39.dart' as bip39;

import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';
import 'package:authentication_repository/authentication_repository.dart';

class EthereumService {
  FirebaseService _firebaseService;
  EthereumService() {
    this._firebaseService = FirebaseService();
  }

  ///Signs any Map you pass it with a private string.
  ///
  ///Returns signature.
  Future<String> signing(Map message, String privateKey) async {
    var encodedMessage = jsonEncode(message);

    Credentials key = EthPrivateKey.fromHex(privateKey);
    key.extractAddress();
    var keySign = key.sign(utf8.encode(encodedMessage));
    String signing =
        await keySign.then((value) => hex.encode(value).toString());

    return signing;
  }

  ///Creates new Eth Wallet address
  ///
  ///When address is created the wallet address is added to the user's firebase
  ///and the address is returned from this function
  Future<String> createEthWallet() async {
    String collection = "users";
    Map<String, String> firebaseData;

    var mnemonic = bip39.generateMnemonic();

    String mnemonicHex = bip39.mnemonicToSeedHex(mnemonic);

    String privateKey = mnemonicHex.substring(0, 64);
    privateKey = privateKey;

    firebaseData = {"privateKey": privateKey};

    _firebaseService.addDataToFirestoreDocument('users', firebaseData);

    Credentials credentials = EthPrivateKey.fromHex(privateKey);

    var wallet =
        await credentials.extractAddress().then((value) => value.toString());
    firebaseData = {"wallet": wallet};
    _firebaseService.addDataToFirestoreDocument(collection, firebaseData);
    return wallet;
  }
}
