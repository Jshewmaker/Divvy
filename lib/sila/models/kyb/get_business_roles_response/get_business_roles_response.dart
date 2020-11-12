import 'package:equatable/equatable.dart';
import "business_roles.dart";

class GetBusinessRolesResponse extends Equatable  {
	final bool success;
	final String status;
	final List<BusinessRoles> businessRoles;

	GetBusinessRolesResponse({this.success, this.status, this.businessRoles});

	factory GetBusinessRolesResponse.fromJson(Map<String, dynamic> json) {
		return GetBusinessRolesResponse(
			success: json['success'],
			status: json['status'],
			businessRoles: json['business_roles'] != null ? json['business_roles'].map((v) => new BusinessRoles.fromJson(v)).toList() : null,
		);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['success'] = this.success;
		data['status'] = this.status;
		if (this.businessRoles!= null) {
      data['business_roles'] = this.businessRoles.map((v) => v.toJson()).toList();
    }
		return data;
	}

	@override
	List<Object> get props => [
		this.success,
		this.status,
		this.businessRoles
	];
}
