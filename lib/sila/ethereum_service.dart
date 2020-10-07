import 'dart:convert';
import 'dart:math';

import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';
import 'package:authentication_repository/authentication_repository.dart';

class EthereumService {
  FirebaseService _firebaseService;
  EthereumService() {
    this._firebaseService = FirebaseService();
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

  Future<String> createAddress() async {
    var data;
    var randomNum =  Random.secure().nextInt(1000000);
    print('random: ' + randomNum);
    data = {"userPrivateKey": randomNum.toString()};
    _firebaseService.addDataToFirestoreDocument('users', data);

    Credentials privateKey = EthPrivateKey.createRandom(randomNum);
    print('privateKey: ' );
    var wallet =
        await privateKey.extractAddress().then((value) => value.toString());
    return wallet;
  }
}
