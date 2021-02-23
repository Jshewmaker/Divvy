import 'package:authentication_repository/src/models/keys/keys_entity.dart';
import 'package:equatable/equatable.dart';

class Keys extends Equatable {
  final String baseUrl;
  final String privateKey;
  final String authHandle;

  const Keys({this.baseUrl, this.privateKey, this.authHandle});

  @override
  List<Object> get props => [baseUrl, privateKey, authHandle];

  static const empty = Keys(baseUrl: '', privateKey: '', authHandle: '');

  static Keys fromEntity(KeysEntity entity) {
    return Keys(
      baseUrl: entity.baseUrl,
      privateKey: entity.privateKey,
      authHandle: entity.authHandle,
    );
  }

  KeysEntity toEntity() {
    return KeysEntity(baseUrl, privateKey, authHandle);
  }
}
