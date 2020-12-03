import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity extends Equatable {
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

  const UserEntity(
    this.name,
    this.dateOfBirthYYYYMMDD,
    this.identityValue,
    this.streetAddress,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.phone,
    this.email,
    this.website,
    this.doingBusinessAsName,
    this.businessType,
    this.naicsCode,
    this.privateKey,
    this.silaEntityName,
    this.silaHandle,
    this.isHomeowner,
    this.wallet,
    this.businessAdminDocumentID,
    this.projectID,
    this.bankAccountIsConnected,
  );

  Map<String, Object> toJson() {
    return {
      "user_handle": name,
      "birthdate": dateOfBirthYYYYMMDD,
      "identity_value": identityValue,
      "street_address_1": streetAddress,
      "city": city,
      "state": state,
      "country": country,
      "postal_code": postalCode,
      "phone": phone,
      "email": email,
      "business_website": website,
      "doing_business_as": doingBusinessAsName,
      "business_type": businessType,
      "naics_code": naicsCode,
      "privateKey": privateKey,
      "silaEntityName": silaEntityName,
      "silaHandle": silaHandle,
      "isHomeowner": isHomeowner,
      "wallet": wallet,
      "businessAdminDocumentID": businessAdminDocumentID,
      "project_id": projectID,
      "bankAccountIsConnected": bankAccountIsConnected,
    };
  }

  List<Object> get props => [
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
      ];

  static UserEntity fromJson(Map<String, Object> json) {
    return UserEntity(
      json["name"] as String,
      json["dateOfBirthYYYYMMDD"] as String,
      json["identity_value"] as String,
      json["street_address_1"] as String,
      json["city"] as String,
      json["state"] as String,
      json["country"] as String,
      json["postal_code"] as String,
      json["phone"] as String,
      json["email"] as String,
      json["business_website"] as String,
      json["doing_business_as"] as String,
      json["business_type"] as String,
      json["naics_code"] as int,
      json["privateKey"] as String,
      json["silaEntityName"] as String,
      json["silaHandle"] as String,
      json["isHomeowner"] as bool,
      json["wallet"] as String,
      json["businessAdminDocumentID"] as String,
      json["project_id"] as String,
      json["bankAccountIsConnected"] as bool,
    );
  }

  //Specific to Firestore
  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEntity(
      snap.data['name'],
      snap.data['dateOfBirthYYYYMMDD'],
      snap.data['identity_value'],
      snap.data['street_address_1'],
      snap.data['city'],
      snap.data['state'],
      snap.data['country'],
      snap.data['postal_code'],
      snap.data['phone'],
      snap.data['email'],
      snap.data["business_website"],
      snap.data["doing_business_as"],
      snap.data["business_type"],
      snap.data["naics_code"],
      snap.data['privateKey'],
      snap.data['silaEntityName'],
      snap.data['silaHandle'],
      snap.data['isHomeowner'],
      snap.data['wallet'],
      snap.data['businessAdminDocumentID'],
      snap.data['project_id'],
      snap.data['bankAccountIsConnected'],
    );
  }

  //Specific to Firestore
  Map<String, Object> toDocument() {
    return {
      "name": name,
      "dateOfBirthYYYYMMDD": dateOfBirthYYYYMMDD,
      "identity_value": identityValue,
      "street_address_1": streetAddress,
      "city": city,
      "state": state,
      "country": country,
      "postal_code": postalCode,
      "phone": phone,
      "email": email,
      "business_website": website,
      "doing_business_as": doingBusinessAsName,
      "business_type": businessType,
      "naics_code": naicsCode,
      "privateKey": privateKey,
      "silaEntityName": silaEntityName,
      "silaHandle": silaHandle,
      "isHomeowner": isHomeowner,
      "wallet": wallet,
      "businessAdminDocumentID": businessAdminDocumentID,
      "project_id": projectID,
      "bankAccountIsConnected": bankAccountIsConnected,
    };
  }

  Map<String, Object> toDocumentPersonalInfo() {
    return {
      "name": name,
      "dateOfBirthYYYYMMDD": dateOfBirthYYYYMMDD,
      "identity_value": identityValue,
      "phone": phone,
      "isHomeowner": isHomeowner,
      "bankAccountIsConnected": bankAccountIsConnected,
    };
  }

  Map<String, Object> toDocumentAddresses() {
    return {
      "street_address_1": streetAddress,
      "city": city,
      "state": state,
      "country": country,
      "postal_code": postalCode,
    };
  }

  Map<String, Object> toDocumentAdminInfo() {
    return {
      "name": name,
      "email": email,
      "dateOfBirthYYYYMMDD": dateOfBirthYYYYMMDD,
      "identity_value": identityValue,
      "phone": phone,
      "isHomeowner": isHomeowner,
    };
  }

  Map<String, Object> toDocumentBusinessInfo() {
    return {
      "name": name,
      "doing_business_as": doingBusinessAsName,
      "business_website": website,
      "identity_value": identityValue,
      "business_type": businessType,
      "naics_code": naicsCode,
      "phone": phone,
      "isHomeowner": isHomeowner,
      "bankAccountIsConnected": bankAccountIsConnected,
    };
  }
}
