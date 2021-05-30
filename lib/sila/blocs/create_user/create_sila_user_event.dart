import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateSilaUserEvent extends Equatable {
  const CreateSilaUserEvent();
}

class CreateSilaUserRequest extends CreateSilaUserEvent {
  final String handle;

  const CreateSilaUserRequest({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [handle];
}
