import 'package:equatable/equatable.dart';

class Information extends Equatable  {
	final int code;
	final String subcategory;

	Information({this.code, this.subcategory});

	factory Information.fromJson(Map<String, dynamic> json) {
		return Information(
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
