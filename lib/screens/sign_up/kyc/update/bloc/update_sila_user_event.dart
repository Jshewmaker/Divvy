import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateSilaUserEvent extends Equatable {
  const UpdateSilaUserEvent();
}

class UpdateAddress extends UpdateSilaUserEvent {
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  const UpdateAddress({
    @required this.streetAddress,
    @required this.city,
    @required this.state,
    @required this.country,
    @required this.postalCode,
  }) : assert(
          streetAddress != null,
          city != null,
        );

  @override
  List<Object> get props => [streetAddress, city, country, state, postalCode];
}

class UpdateUserInfo extends UpdateSilaUserEvent {
  final String firstName;
  final String lastName;
  final String birthday;
  final String phone;

  const UpdateUserInfo({
    @required this.firstName,
    @required this.lastName,
    @required this.birthday,
    @required this.phone,
  }) : assert(
          firstName != null,
          lastName != null,
        );

  @override
  List<Object> get props => [firstName, lastName, birthday, phone];
}

class UpdateSSN extends UpdateSilaUserEvent {
  final String ssn;

  const UpdateSSN({@required this.ssn}) : assert(ssn != null);

  @override
  List<Object> get props => [ssn];
}
