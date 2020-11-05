import 'package:equatable/equatable.dart';

class AdministrativeAndSupportAndWasteManagementAndRemediation extends Equatable  {
	final int code;
	final String subcategory;

	AdministrativeAndSupportAndWasteManagementAndRemediation({this.code, this.subcategory});

	factory AdministrativeAndSupportAndWasteManagementAndRemediation.fromJson(Map<String, dynamic> json) {
		return AdministrativeAndSupportAndWasteManagementAndRemediation(
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
