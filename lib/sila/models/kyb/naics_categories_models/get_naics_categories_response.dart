import 'package:equatable/equatable.dart';
import 'naics_categories.dart';

class GetNaicsCategoriesResponse extends Equatable {
  final bool success;
  final NaicsCategories naicsCategories;
  final String status;

  GetNaicsCategoriesResponse({this.success, this.naicsCategories, this.status});

  factory GetNaicsCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return GetNaicsCategoriesResponse(
      success: json['success'],
      naicsCategories: json['naics_categories'] != null
          ? new NaicsCategories.fromJson(json['naics_categories'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.naicsCategories != null) {
      data['naics_categories'] = this.naicsCategories.toJson();
    }
    data['status'] = this.status;
    return data;
  }

  @override
  List<Object> get props => [this.success, this.naicsCategories, this.status];
}
