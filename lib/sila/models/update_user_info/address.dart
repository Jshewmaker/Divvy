import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final int addedEpoch;
  final int modifiedEpoch;
  final String uuid;
  final String nickname;
  final String streetAddress1;
  final String streetAddress2;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  Address(
      {this.addedEpoch,
      this.modifiedEpoch,
      this.uuid,
      this.nickname,
      this.streetAddress1,
      this.streetAddress2,
      this.city,
      this.state,
      this.country,
      this.postalCode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addedEpoch: json['added_epoch'],
      modifiedEpoch: json['modified_epoch'],
      uuid: json['uuid'],
      nickname: json['nickname'],
      streetAddress1: json['street_address_1'],
      streetAddress2: json['street_address_2'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'],
    );
  }

  @override
  List<Object> get props => [
        this.addedEpoch,
        this.modifiedEpoch,
        this.uuid,
        this.nickname,
        this.streetAddress1,
        this.streetAddress2,
        this.city,
        this.state,
        this.country,
        this.postalCode,
      ];
}
