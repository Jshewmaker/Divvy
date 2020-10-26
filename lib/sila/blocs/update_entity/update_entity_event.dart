import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateEntityEvent extends Equatable {
  const UpdateEntityEvent();
}

class UpdateEntityRequest extends UpdateEntityEvent {
  final Map<String, String> entity;

  const UpdateEntityRequest({@required this.entity}) : assert(entity != null);

  @override
  List<Object> get props => [entity];
}
