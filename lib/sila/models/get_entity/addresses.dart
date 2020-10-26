import 'package:equatable/equatable.dart';

class Addresses extends Equatable  {
	final int addedEpoch;
	final int modifiedEpoch;
	final String uuid;
	final String nickname;
	final String streetAddress_1;
	final String streetAddress_2;
	final String city;
	final String state;
	final String country;
	final String postalCode;

	Addresses({this.addedEpoch, this.modifiedEpoch, this.uuid, this.nickname, this.streetAddress_1, this.streetAddress_2, this.city, this.state, this.country, this.postalCode});

	factory Addresses.fromJson(Map<String, dynamic> json) {
		return Addresses(
			addedEpoch: json['added_epoch'],
			modifiedEpoch: json['modified_epoch'],
			uuid: json['uuid'],
			nickname: json['nickname'],
			streetAddress_1: json['street_address_1'],
			streetAddress_2: json['street_address_2'],
			city: json['city'],
			state: json['state'],
			country: json['country'],
			postalCode: json['postal_code'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['added_epoch'] = this.addedEpoch;
		data['modified_epoch'] = this.modifiedEpoch;
		data['uuid'] = this.uuid;
		data['nickname'] = this.nickname;
		data['street_address_1'] = this.streetAddress_1;
		data['street_address_2'] = this.streetAddress_2;
		data['city'] = this.city;
		data['state'] = this.state;
		data['country'] = this.country;
		data['postal_code'] = this.postalCode;
		return data;
	}

	@override
	List<Object> get props => [
		this.addedEpoch,
		this.modifiedEpoch,
		this.uuid,
		this.nickname,
		this.streetAddress_1,
		this.streetAddress_2,
		this.city,
		this.state,
		this.country,
		this.postalCode
	];
}
