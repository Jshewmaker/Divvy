import 'package:equatable/equatable.dart';

abstract class IssueSilaEvent extends Equatable {
  const IssueSilaEvent();
}

class IssueSilaRequest extends IssueSilaEvent {
  const IssueSilaRequest();
  @override
  List<Object> get props => [];
}
