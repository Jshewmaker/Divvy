import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User(
      {@required this.id,
      @required this.firstName,
       this.lastName,
      @required this.email,
       this.address,
       this.city,
       this.state,
       this.postalCode,
       this.dateOfBirth,
       this.ssn})
      : assert(email != null),
        assert(id != null);

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String city;
  final String state;
  final int postalCode;
  final String dateOfBirth;
  final int ssn;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(
      email: '',
      id: '',
      firstName: null,
      lastName: null,
      address: null,
      city: null,
      state: null,
      postalCode: null,
      dateOfBirth: null,
      ssn: null);

  @override
  List<Object> get props => [email, id, firstName, lastName, address, city, state, postalCode, dateOfBirth, ssn,];
}
