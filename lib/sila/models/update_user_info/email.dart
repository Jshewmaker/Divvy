import 'package:equatable/equatable.dart';

class Email extends Equatable {
  final int addedEpoch;
  final int modifiedEpoch;
  final String uuid;
  final String email;

  Email({this.addedEpoch, this.modifiedEpoch, this.uuid, this.email});

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      addedEpoch: json['added_epoch'],
      modifiedEpoch: json['modified_epoch'],
      uuid: json['uuid'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_epoch'] = this.addedEpoch;
    data['modified_epoch'] = this.modifiedEpoch;
    data['uuid'] = this.uuid;
    data['email'] = this.email;
    return data;
  }

  @override
  List<Object> get props =>
      [this.addedEpoch, this.modifiedEpoch, this.uuid, this.email];
}
