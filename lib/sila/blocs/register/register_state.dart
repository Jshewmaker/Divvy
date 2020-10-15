import 'package:divvy/sila/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';



abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoadInProgress extends RegisterState {}

class RegisterLoadSuccess extends RegisterState {
  final RegisterResponse handle;

  const RegisterLoadSuccess({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [handle];
}

class RegisterLoadFailure extends RegisterState {
  
}