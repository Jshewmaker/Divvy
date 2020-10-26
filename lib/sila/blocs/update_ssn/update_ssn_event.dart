import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateSsnEvent extends Equatable {
  const UpdateSsnEvent();
}

class UpdateSsnRequest extends UpdateSsnEvent {
  final String ssn;

  const UpdateSsnRequest({@required this.ssn}) : assert(ssn != null);

  @override
  List<Object> get props => [ssn];
}
