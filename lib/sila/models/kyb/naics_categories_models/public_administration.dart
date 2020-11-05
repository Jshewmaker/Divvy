import 'package:equatable/equatable.dart';

class PublicAdministration extends Equatable  {
	final int code;
	final String subcategory;

	PublicAdministration({this.code, this.subcategory});

	factory PublicAdministration.fromJson(Map<String, dynamic> json) {
		return PublicAdministration(
			code: json['code'],
			subcategory: json['subcategory'],
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['code'] = this.code;
		data['subcategory'] = this.subcategory;
		return data;
	}

	@override
	List<Object> get props => [
		this.code,
		this.subcategory
	];
}
