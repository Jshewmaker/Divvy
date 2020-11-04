import 'package:equatable/equatable.dart';

class FinanceAndInsurance extends Equatable  {
	final int code;
	final String subcategory;

	FinanceAndInsurance({this.code, this.subcategory});

	factory FinanceAndInsurance.fromJson(Map<String, dynamic> json) {
		return FinanceAndInsurance(
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
