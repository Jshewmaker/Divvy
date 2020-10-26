import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateEmailEvent extends Equatable {
  const UpdateEmailEvent();
}

class UpdateEmailRequest extends UpdateEmailEvent {
  final String email;

  const UpdateEmailRequest({@required this.email}) : assert(email != null);

  @override
  List<Object> get props => [email];
}
