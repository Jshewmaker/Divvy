import 'package:equatable/equatable.dart';

class MiningQuarryingAndOilAndGasExtraction extends Equatable  {
	final int code;
	final String subcategory;

	MiningQuarryingAndOilAndGasExtraction({this.code, this.subcategory});

	factory MiningQuarryingAndOilAndGasExtraction.fromJson(Map<String, dynamic> json) {
		return MiningQuarryingAndOilAndGasExtraction(
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
