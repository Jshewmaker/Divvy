import 'package:equatable/equatable.dart';

class Entity extends Equatable  {
	final int createdEpoch;
	final String entityName;
	final String birthdate;
	final String firstName;
	final String lastName;

	Entity({this.createdEpoch, this.entityName, this.birthdate, this.firstName, this.lastName});

	factory Entity.fromJson(Map<String, dynamic> json) {
		return Entity(
			createdEpoch: json['created_epoch'],
			entityName: json['entity_name'],
			birthdate: json['birthdate'],
			firstName: json['first_name'],
			lastName: json['last_name'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['created_epoch'] = this.createdEpoch;
		data['entity_name'] = this.entityName;
		data['birthdate'] = this.birthdate;
		data['first_name'] = this.firstName;
		data['last_name'] = this.lastName;
		return data;
	}

	@override
	List<Object> get props => [
		this.createdEpoch,
		this.entityName,
		this.birthdate,
		this.firstName,
		this.lastName
	];
}
