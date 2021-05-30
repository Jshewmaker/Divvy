import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RedeemSilaEvent extends Equatable {
  const RedeemSilaEvent();
}

class RedeemSilaRequest extends RedeemSilaEvent {
  final int amount;
  final String account;

  const RedeemSilaRequest({@required this.account, @required this.amount})
      : assert(account != null, amount != null);

  @override
  List<Object> get props => [amount];
}
