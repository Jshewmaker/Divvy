import 'memberships.dart';
import 'package:equatable/equatable.dart';
import "entity.dart";
import "addresses.dart";
import "identities.dart";
import "emails.dart";
import "phones.dart";

class GetEntityResponse extends Equatable {
  final bool success;
  final String status;
  final String userHandle;
  final String entityType;
  final Entity entity;
  final List<dynamic> addresses;
  final List<dynamic> identities;
  final List<Emails> emails;
  final List<dynamic> phones;
  final List<dynamic> memberships;

  GetEntityResponse(
      {this.success,
      this.status,
      this.userHandle,
      this.entityType,
      this.entity,
      this.addresses,
      this.identities,
      this.emails,
      this.phones,
      this.memberships});

  factory GetEntityResponse.fromJson(Map<String, dynamic> json) {
    return GetEntityResponse(
      success: json['success'],
      status: json['status'],
      userHandle: json['user_handle'],
      entityType: json['entity_type'],
      entity:
          json['entity'] != null ? new Entity.fromJson(json['entity']) : null,
      addresses: json['addresses'] != null
          ? json['addresses'].map((v) => new Addresses.fromJson(v)).toList()
          : null,
      identities: json['identities'] != null
          ? json['identities'].map((v) => new Identities.fromJson(v)).toList()
          : null,
      emails: json['emails'] != null
          ? json['emails'].map<Emails>((v) => new Emails.fromJson(v)).toList()
          : null,
      phones: json['phones'] != null
          ? json['phones'].map((v) => new Phones.fromJson(v)).toList()
          : null,
      memberships: json['memberships'] != null
          ? json['memberships'].map((v) => new Memberships.fromJson(v)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['user_handle'] = this.userHandle;
    data['entity_type'] = this.entityType;
    if (this.entity != null) {
      data['entity'] = this.entity.toJson();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    if (this.identities != null) {
      data['identities'] = this.identities.map((v) => v.toJson()).toList();
    }
    if (this.emails != null) {
      data['emails'] = this.emails.map((v) => v.toJson()).toList();
    }
    if (this.phones != null) {
      data['phones'] = this.phones.map((v) => v.toJson()).toList();
    }
    if (this.memberships != null) {
      data['members'] = this.memberships.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object> get props => [
        this.success,
        this.status,
        this.userHandle,
        this.entityType,
        this.entity,
        this.addresses,
        this.identities,
        this.emails,
        this.phones,
        this.memberships
      ];
}
