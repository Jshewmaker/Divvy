import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CheckHandleEvent extends Equatable {
  const CheckHandleEvent();
}

class CheckHandleRequest extends CheckHandleEvent {
  final String handle;

  const CheckHandleRequest({@required this.handle}) : assert(handle != null);

  @override
  List<Object> get props => [handle];
}