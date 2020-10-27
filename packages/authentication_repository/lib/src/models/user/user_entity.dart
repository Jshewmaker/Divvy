import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity extends Equatable {
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
  final String privateKey;
  final String silaEntityName;
  final String silaHandle;
  final String silaAuthSignature;
  final String silaUserSignature;
  final String cryptoAddress;
  final String wallet;

  const UserEntity(
    this.id,
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
    this.privateKey,
    this.silaEntityName,
    this.silaHandle,
    this.silaAuthSignature,
    this.silaUserSignature,
    this.cryptoAddress,
    this.wallet,
  );

  Map<String, Object> toJson() {
    return {
      "id": id,
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
      "privateKey": privateKey,
      "silaEntityName": silaEntityName,
      "silaHandle": silaHandle,
      "silaAuthSignature": silaAuthSignature,
      "silaUserSignature": silaUserSignature,
      "cryptoAddress": cryptoAddress,
      "wallet": wallet,
    };
  }

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
        privateKey,
        silaEntityName,
        silaHandle,
        silaAuthSignature,
        silaUserSignature,
        cryptoAddress,
        wallet,
      ];

  static UserEntity fromJson(Map<String, Object> json) {
    return UserEntity(
      json["id"] as String,
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
      json["privateKey"] as String,
      json["silaEntityName"] as String,
      json["silaHandle"] as String,
      json["silaAuthSignature"] as String,
      json["silaUserSignature"] as String,
      json["cryptoAddress"] as String,
      json["wallet"] as String,
    );
  }

  //Specific to Firestore
  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEntity(
      snap.documentID,
      snap.data['name'],
      snap.data['dateOfBirthYYYYMMDD'],
      snap.data['identity_value'],
      snap.data['street_address_a'],
      snap.data['city'],
      snap.data['state'],
      snap.data['country'],
      snap.data['postal_code'],
      snap.data['phone'],
      snap.data['email'],
      snap.data["business_website"],
      snap.data["doing_business_as"],
      snap.data['privateKey'],
      snap.data['silaEntityName'],
      snap.data['silaHandle'],
      snap.data['silaAuthSignature'],
      snap.data['silaUserSignature'],
      snap.data['cryptoAddress'],
      snap.data['wallet'],
    );
  }

  //Specific to Firestore
  Map<String, Object> toDocument() {
    return {
      "id": id,
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
      "privateKey": privateKey,
      "silaEntityName": silaEntityName,
      "silaHandle": silaHandle,
      "silaAuthsiganture": silaAuthSignature,
      "silaUserSignature": silaUserSignature,
      "cryptoAddress": cryptoAddress,
      "wallet": wallet,
    };
  }
}
