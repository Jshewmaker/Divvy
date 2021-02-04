import 'package:authentication_repository/src/models/user/user_entity.dart';
import 'package:equatable/equatable.dart';

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
  final String identityValue;
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String phone;
  final String email;
  final String website;
  final String doingBusinessAsName;
  final String businessType;
  final int naicsCode;
  final String privateKey;
  final String silaEntityName;
  final String silaHandle;
  final bool isHomeowner;
  final String wallet;
  final String businessAdminDocumentID;
  final String projectID;
  final bool bankAccountIsConnected;
  final List<dynamic> projectList;
  final String projectName;

  const UserModel({
    this.name,
    this.id,
    this.dateOfBirthYYYYMMDD,
    this.identityValue,
    this.streetAddress,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.phone,
    this.email,
    this.doingBusinessAsName,
    this.businessType,
    this.naicsCode,
    this.website,
    this.privateKey,
    this.silaEntityName,
    this.silaHandle,
    this.isHomeowner,
    this.wallet,
    this.businessAdminDocumentID,
    this.projectID,
    this.bankAccountIsConnected,
    this.projectList,
    this.projectName,
  });

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    id: '',
    name: null,
    dateOfBirthYYYYMMDD: null,
    identityValue: null,
    streetAddress: null,
    city: null,
    state: null,
    country: null,
    postalCode: null,
    phone: null,
    email: '',
    website: null,
    doingBusinessAsName: null,
    businessType: null,
    naicsCode: null,
    privateKey: null,
    silaEntityName: null,
    silaHandle: null,
    isHomeowner: null,
    wallet: null,
    businessAdminDocumentID: null,
    projectID: null,
    bankAccountIsConnected: null,
    projectList: null,
    projectName: null,
  );

  @override
  List<Object> get props => [
        id,
        name,
        dateOfBirthYYYYMMDD,
        identityValue,
        streetAddress,
        city,
        state,
        country,
        postalCode,
        phone,
        email,
        website,
        doingBusinessAsName,
        businessType,
        naicsCode,
        privateKey,
        silaEntityName,
        silaHandle,
        isHomeowner,
        wallet,
        businessAdminDocumentID,
        projectID,
        bankAccountIsConnected,
        projectList,
        projectName,
      ];

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      dateOfBirthYYYYMMDD: entity.dateOfBirthYYYYMMDD,
      identityValue: entity.identityValue,
      streetAddress: entity.streetAddress,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      postalCode: entity.postalCode,
      phone: entity.phone,
      email: entity.email,
      website: entity.website,
      doingBusinessAsName: entity.doingBusinessAsName,
      businessType: entity.businessType,
      naicsCode: entity.naicsCode,
      privateKey: entity.privateKey,
      silaHandle: entity.silaHandle,
      silaEntityName: entity.silaEntityName,
      isHomeowner: entity.isHomeowner,
      wallet: entity.wallet,
      businessAdminDocumentID: entity.businessAdminDocumentID,
      projectID: entity.projectID,
      bankAccountIsConnected: entity.bankAccountIsConnected,
      projectList: entity.projectList,
      projectName: (entity.projectName == null) ? "" : entity.projectName,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id,
      name,
      dateOfBirthYYYYMMDD,
      identityValue,
      streetAddress,
      city,
      state,
      country,
      postalCode,
      phone,
      email,
      website,
      doingBusinessAsName,
      businessType,
      naicsCode,
      privateKey,
      silaEntityName,
      silaHandle,
      isHomeowner,
      wallet,
      businessAdminDocumentID,
      projectID,
      bankAccountIsConnected,
      projectList,
      projectName,
    );
  }
}
