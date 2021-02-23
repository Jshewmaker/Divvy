import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class KeysEntity extends Equatable {
  final String baseUrl;
  final String privateKey;
  final String authHandle;

  const KeysEntity(this.baseUrl, this.privateKey, this.authHandle);

  Map<String, Object> toJson() {
    return {
      "base_url": baseUrl,
      "private_key": privateKey,
      "auth_handle": authHandle,
    };
  }

  List<Object> get props => [baseUrl, privateKey, authHandle];

  static KeysEntity fromJson(Map<String, Object> json) {
    return KeysEntity(json["base_url"] as String, json["private_key"] as String,
        json["auth_handle"] as String);
  }

  static KeysEntity fromSnapshot(DocumentSnapshot snap) {
    return KeysEntity(
      snap.data['base_url'],
      snap.data['private_key'],
      snap.data['auth_handle'],
    );
  }
}
