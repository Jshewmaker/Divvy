import 'dart:convert';

import "package:pointycastle/pointycastle.dart";

void main() {
  Digest sha3 = new Digest("SHA3Digest");
  String privateKey =
      '4fe8271eb3ee4b89d2f8c9da42ba3229672adad2fd9a9245dbf1181a3f7451cd';
  var messageJSON = {'test': 'message'};
  var json = jsonEncode(messageJSON);
  var encodedJSON = Utf8Encoder().convert(json);

  var messageHased = sha3.process(encodedJSON);
  print(messageHased);
}
