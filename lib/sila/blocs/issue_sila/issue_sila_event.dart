import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class IssueSilaEvent extends Equatable {
  const IssueSilaEvent();
}

class IssueSilaRequest extends IssueSilaEvent {
  final double amount;
  final String account;
  const IssueSilaRequest({@required this.amount, this.account})
      : assert(amount != null);
  @override
  List<Object> get props => [amount];
}
