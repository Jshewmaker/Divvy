import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RedeemSilaEvent extends Equatable {
  const RedeemSilaEvent();
}

class RedeemSilaRequest extends RedeemSilaEvent {
  final int amount;

  const RedeemSilaRequest({@required this.amount}) : assert(amount != null);

  @override
  List<Object> get props => [amount];
}
