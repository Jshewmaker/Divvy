import 'package:equatable/equatable.dart';

class Entity extends Equatable {
  final int createdEpoch;

  final String entityName;
  final String birthDay;
  final String firstName;
  final String lastName;

  Entity(
      {this.createdEpoch,
      this.entityName,
      this.birthDay,
      this.firstName,
      this.lastName});

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      createdEpoch: json['added_epoch'],
      entityName: json['entity_name'],
      birthDay: json['birthdate'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  @override
  List<Object> get props => [
        this.createdEpoch,
        this.entityName,
        this.birthDay,
        this.firstName,
        this.lastName
      ];
}
