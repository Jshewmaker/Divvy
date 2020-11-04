import 'package:equatable/equatable.dart';

class OtherServicesExceptPublicAdministration extends Equatable  {
	final int code;
	final String subcategory;

	OtherServicesExceptPublicAdministration({this.code, this.subcategory});

	factory OtherServicesExceptPublicAdministration.fromJson(Map<String, dynamic> json) {
		return OtherServicesExceptPublicAdministration(
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
