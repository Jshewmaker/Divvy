import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterRequest extends RegisterEvent {
  final String handle;


  const RegisterRequest(
      {@required this.handle,})
      : assert(handle != null);

  @override
  List<Object> get props => [handle];
}
