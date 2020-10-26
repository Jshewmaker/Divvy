import 'package:equatable/equatable.dart';

class Identities extends Equatable  {
	final int addedEpoch;
	final int modifiedEpoch;
	final String uuid;
	final String identityType;
	final String identity;

	Identities({this.addedEpoch, this.modifiedEpoch, this.uuid, this.identityType, this.identity});

	factory Identities.fromJson(Map<String, dynamic> json) {
		return Identities(
			addedEpoch: json['added_epoch'],
			modifiedEpoch: json['modified_epoch'],
			uuid: json['uuid'],
			identityType: json['identity_type'],
			identity: json['identity'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['added_epoch'] = this.addedEpoch;
		data['modified_epoch'] = this.modifiedEpoch;
		data['uuid'] = this.uuid;
		data['identity_type'] = this.identityType;
		data['identity'] = this.identity;
		return data;
	}

	@override
	List<Object> get props => [
		this.addedEpoch,
		this.modifiedEpoch,
		this.uuid,
		this.identityType,
		this.identity
	];
}
