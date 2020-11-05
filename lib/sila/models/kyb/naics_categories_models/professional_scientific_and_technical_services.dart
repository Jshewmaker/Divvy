import 'package:equatable/equatable.dart';

class ProfessionalScientificAndTechnicalServices extends Equatable  {
	final int code;
	final String subcategory;

	ProfessionalScientificAndTechnicalServices({this.code, this.subcategory});

	factory ProfessionalScientificAndTechnicalServices.fromJson(Map<String, dynamic> json) {
		return ProfessionalScientificAndTechnicalServices(
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
