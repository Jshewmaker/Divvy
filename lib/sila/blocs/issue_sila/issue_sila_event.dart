import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class IssueSilaEvent extends Equatable {
  const IssueSilaEvent();
}

class IssueSilaRequest extends IssueSilaEvent {
  final double amount;
  const IssueSilaRequest({@required this.amount}) : assert(amount != null);
  @override
  List<Object> get props => [amount];
}
