import 'package:divvy/sila/models/update_user_info/entity.dart';
import 'package:divvy/sila/models/update_user_info/identity.dart';
import 'package:divvy/sila/models/update_user_info/phone.dart';
import 'package:equatable/equatable.dart';
import 'email.dart';

class UpdateUserInfo extends Equatable {
  final bool success;
  final String message;
  final Email email;
  final Phone phone;
  final Entity entity;
  final Identity identity;
  final String status;

  UpdateUserInfo(
      {this.success,
      this.message,
      this.email,
      this.phone,
      this.entity,
      this.identity,
      this.status});

  factory UpdateUserInfo.fromJson(Map<String, dynamic> json) {
    return UpdateUserInfo(
      success: json['success'],
      message: json['message'],
      email: json['email'] != null ? new Email.fromJson(json['email']) : null,
      phone: json['phone'] != null ? new Phone.fromJson(json['phone']) : null,
      entity:
          json['entity'] != null ? new Entity.fromJson(json['entity']) : null,
      identity: json['identity'] != null
          ? new Identity.fromJson(json['identity'])
          : null,
      status: json['status'],
    );
  }

  @override
  List<Object> get props => [
        this.success,
        this.message,
        this.email,
        this.phone,
        this.entity,
        this.identity,
        this.status
      ];
}
