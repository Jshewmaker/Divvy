import 'package:equatable/equatable.dart';

class BusinessRoles extends Equatable  {
	final String uuid;
	final String name;
	final String label;

	BusinessRoles({this.uuid, this.name, this.label});

	factory BusinessRoles.fromJson(Map<String, dynamic> json) {
		return BusinessRoles(
			uuid: json['uuid'],
			name: json['name'],
			label: json['label'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['uuid'] = this.uuid;
		data['name'] = this.name;
		data['label'] = this.label;
		return data;
	}

	@override
	List<Object> get props => [
		this.uuid,
		this.name,
		this.label
	];
}
