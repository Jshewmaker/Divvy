import 'package:equatable/equatable.dart';

class Phone extends Equatable {
  final int addedEpoch;
  final int modifiedEpoch;
  final String uuid;
  final String phone;

  Phone({this.addedEpoch, this.modifiedEpoch, this.uuid, this.phone});

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      addedEpoch: json['added_epoch'],
      modifiedEpoch: json['modified_epoch'],
      uuid: json['uuid'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_epoch'] = this.addedEpoch;
    data['modified_epoch'] = this.modifiedEpoch;
    data['uuid'] = this.uuid;
    data['phone'] = this.phone;
    return data;
  }

  @override
  List<Object> get props =>
      [this.addedEpoch, this.modifiedEpoch, this.uuid, this.phone];
}
