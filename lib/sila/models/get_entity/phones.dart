import 'package:equatable/equatable.dart';

class Phones extends Equatable  {
	final int addedEpoch;
	final int modifiedEpoch;
	final String uuid;
	final String phone;

	Phones({this.addedEpoch, this.modifiedEpoch, this.uuid, this.phone});

	factory Phones.fromJson(Map<String, dynamic> json) {
		return Phones(
			addedEpoch: json['added_epoch'],
			modifiedEpoch: json['modified_epoch'],
			uuid: json['uuid'],
			phone: json['phone'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['added_epoch'] = this.addedEpoch;
		data['modified_epoch'] = this.modifiedEpoch;
		data['uuid'] = this.uuid;
		data['phone'] = this.phone;
		return data;
	}

	@override
	List<Object> get props => [
		this.addedEpoch,
		this.modifiedEpoch,
		this.uuid,
		this.phone
	];
}
