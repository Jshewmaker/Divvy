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
  final String kyc_status;

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
    this.projectList,
    this.projectName,
    this.kyc_status,
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
      "business_type": businessType,
      "naics_code": naicsCode,
      "private_key": privateKey,
      "sila_entity_name": silaEntityName,
      "sila_handle": silaHandle,
      "is_homeowner": isHomeowner,
      "wallet": wallet,
      "business_admin_document_id": businessAdminDocumentID,
      "project_id": projectID,
      "bank_account_is_connected": bankAccountIsConnected,
      "project_list": projectList,
      "project_name": projectName,
      "kyc_status": kyc_status,
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
        kyc_status,
      ];

  static UserEntity fromJson(Map<String, Object> json) {
    return UserEntity(
      json["id"] as String,
      json["name"] as String,
      json["birthdate"] as String,
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
      json["private_key"] as String,
      json["sila_entity_name"] as String,
      json["sila_handle"] as String,
      json["is_homeowner"] as bool,
      json["wallet"] as String,
      json["business_admin_document_id"] as String,
      json["project_id"] as String,
      json["bank_account_is_connected"] as bool,
      json["project_list"] as List<dynamic>,
      json["project_name"] as String,
      json["kyc_status"] as String,
    );
  }

  //Specific to Firestore
  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEntity(
      snap.documentID,
      snap.data['name'],
      snap.data['birthdate'],
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
      snap.data['private_key'],
      snap.data['sila_entity_name'],
      snap.data['sila_handle'],
      snap.data['is_homeowner'],
      snap.data['wallet'],
      snap.data['business_admin_document_id'],
      snap.data['project_id'],
      snap.data['bank_account_is_connected'],
      snap.data['project_list'],
      snap.data['project_name'],
      snap.data['kyc_status'],
    );
  }

  //Specific to Firestore
  Map<String, Object> toDocument() {
    return {
      "name": name,
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
      "private_key": privateKey,
      "sila_entity_name": silaEntityName,
      "sila_handle": silaHandle,
      "is_homeowner": isHomeowner,
      "wallet": wallet,
      "business_admin_document_id": businessAdminDocumentID,
      "project_id": projectID,
      "bank_account_is_connected": bankAccountIsConnected,
      "project_list": projectList,
      "project_name": projectName,
      "kyc_status": kyc_status,
    };
  }

  Map<String, Object> toDocumentPersonalInfo() {
    return {
      "name": name,
      "birthdate": dateOfBirthYYYYMMDD,
      "identity_value": identityValue,
      "phone": phone,
      "is_homeowner": isHomeowner,
      "bank_account_is_connected": bankAccountIsConnected,
      "kyc_status": kyc_status,
    };
  }

  Map<String, Object> toDocumentAddresses() {
    return {
      "street_address_1": streetAddress,
      "city": city,
      "state": state,
      "country": country,
      "postal_code": postalCode,
      "kyc_status": kyc_status,
    };
  }

  Map<String, Object> toDocumentAdminInfo() {
    return {
      "name": name,
      "email": email,
      "birthdate": dateOfBirthYYYYMMDD,
      "identity_value": identityValue,
      "phone": phone,
      "is_homeowner": isHomeowner,
      "kyc_status": kyc_status,
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
      "is_homeowner": isHomeowner,
      "bank_account_is_connected": bankAccountIsConnected,
      "kyc_status": kyc_status,
    };
  }
}
