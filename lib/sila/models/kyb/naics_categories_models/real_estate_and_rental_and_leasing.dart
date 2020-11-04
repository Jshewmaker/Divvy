import 'package:equatable/equatable.dart';

class RealEstateAndRentalAndLeasing extends Equatable  {
	final int code;
	final String subcategory;

	RealEstateAndRentalAndLeasing({this.code, this.subcategory});

	factory RealEstateAndRentalAndLeasing.fromJson(Map<String, dynamic> json) {
		return RealEstateAndRentalAndLeasing(
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
