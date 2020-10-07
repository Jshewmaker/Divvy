import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity extends Equatable {
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
  final String silaEntityName;
  final String silaHandle;
  final String silaAuthSignature;
  final String silaUserSignature;
  final String cryptoAddress;

  const UserEntity(
      this.id,
      this.name,
      this.dateOfBirthYYYYMMDD,
      this.ssn,
      this.streetAddress,
      this.city,
      this.state,
      this.country,
      this.postalCode,
      this.phone,
      this.email,
      this.silaEntityName,
      this.silaHandle,
      this.silaAuthSignature,
      this.silaUserSignature,
      this.cryptoAddress,);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "name": name,
      "dateOfBirthYYYYMMDD": dateOfBirthYYYYMMDD,
      "ssn": ssn,
      "streetAddress": streetAddress,
      "city": city,
      "state": state,
      "country": country,
      "postalCode": postalCode,
      "phone": phone,
      "email": email,
      "silaEntityName": silaEntityName,
      "silaHandle": silaHandle,
      "silaAuthSignature": silaAuthSignature,
      "silaUserSignature": silaUserSignature,
      "cryptoAddress": cryptoAddress,
    };
  }

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
        silaEntityName,
        silaHandle,
        silaAuthSignature,
        silaUserSignature,
        cryptoAddress,
      ];

  static UserEntity fromJson(Map<String, Object> json) {
    return UserEntity(
      json["id"] as String,
      json["name"] as String,
      json["dateOfBirthYYYYMMDD"] as String,
      json["ssn"] as String,
      json["streetAddress"] as String,
      json["city"] as String,
      json["state"] as String,
      json["country"] as String,
      json["postalCode"] as String,
      json["phone"] as String,
      json["email"] as String,
      json["silaEntityName"] as String,
      json["silaHandle"] as String,
      json["silaAuthSignature"] as String,
      json["silaUserSignature"] as String,
      json["cryptoAddress"] as String,
    );
  }

  //Specific to Firestore
  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEntity(
      snap.documentID,
      snap.data['name'],
      snap.data['dateOfBirthYYYYMMDD'],
      snap.data['ssn'],
      snap.data['streetAddress'],
      snap.data['city'],
      snap.data['state'],
      snap.data['country'],
      snap.data['postalCode'],
      snap.data['phone'],
      snap.data['email'],
      snap.data['silaEntityName'],
      snap.data['silaHandle'],
      snap.data['silaAuthSignature'],
      snap.data['silaUserSignature'],
      snap.data['cryptoAddress'],
    );
  }

  //Specific to Firestore
  Map<String, Object> toDocument() {
    return {
      "id": id,
      "name": name,
      "dateOfBirthYYYYMMDD": dateOfBirthYYYYMMDD,
      "ssn": ssn,
      "streetAddress": streetAddress,
      "city": city,
      "state": state,
      "country": country,
      "postalCode": postalCode,
      "phone": phone,
      "email": email,
      "silaEntityName": silaEntityName,
      "silaHandle": silaHandle,
      "silaAuthsiganture": silaAuthSignature,
      "silaUserSignature": silaUserSignature,
      "cryptoAddress": cryptoAddress,
    };
  }
}
