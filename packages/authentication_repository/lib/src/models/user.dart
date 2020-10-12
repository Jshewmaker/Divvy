import 'package:authentication_repository/src/models/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [UserModel.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}

  final String id;
  final String name;
  final String dateOfBirthYYYYMMDD;
  final String ssn;
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String phone;
  final String email;
  final String privateKey;
  final String silaEntityName;
  final String silaHandle;
  final String silaAuthSignature;
  final String silaUserSignature;
  final String cryptoAddress;
  final String wallet;

  const UserModel(
      {@required this.name,
      this.id,
      this.dateOfBirthYYYYMMDD,
      this.ssn,
      this.streetAddress,
      this.city,
      this.state,
      this.country,
      this.postalCode,
      this.phone,
      this.email,
      this.privateKey,
      this.silaEntityName,
      this.silaHandle,
      this.silaAuthSignature,
      this.silaUserSignature,
      this.cryptoAddress,
      this.wallet,});

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    id: '',
    name: null,
    dateOfBirthYYYYMMDD: null,
    ssn: null,
    streetAddress: null,
    city: null,
    state: null,
    country: null,
    postalCode: null,
    phone: null,
    email: '',
    privateKey: null,
    silaEntityName: null,
    silaHandle: null,
    silaAuthSignature: null,
    silaUserSignature: null,
    cryptoAddress: null,
    wallet: null,
  );

  @override
  List<Object> get props => [
        id,
        name,
        dateOfBirthYYYYMMDD,
        ssn,
        streetAddress,
        city,
        state,
        country,
        postalCode,
        phone,
        email,
        privateKey,
        silaEntityName,
        silaHandle,
        silaAuthSignature,
        silaUserSignature,
        cryptoAddress,
        wallet,
      ];

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      dateOfBirthYYYYMMDD: entity.dateOfBirthYYYYMMDD,
      ssn: entity.ssn,
      streetAddress: entity.streetAddress,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      postalCode: entity.postalCode,
      phone: entity.phone,
      email: entity.email,
      privateKey: entity.privateKey,
      silaHandle: entity.silaHandle,
      silaEntityName: entity.silaEntityName,
      silaAuthSignature: entity.silaAuthSignature,
      silaUserSignature: entity.silaUserSignature,
      cryptoAddress: entity.cryptoAddress,
      wallet: entity.wallet,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id,
      name,
      dateOfBirthYYYYMMDD,
      ssn,
      streetAddress,
      city,
      state,
      country,
      postalCode,
      phone,
      email,
      privateKey,
      silaEntityName,
      silaHandle,
      silaAuthSignature,
      silaUserSignature,
      cryptoAddress,
      wallet,
    );
  }
}
