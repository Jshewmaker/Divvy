import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LinkAccountEvent extends Equatable {
  const LinkAccountEvent();
}

class LinkAccountRequest extends LinkAccountEvent {
  final String plaidPublicToken;
  final String accountID;

  const LinkAccountRequest(
      {@required this.plaidPublicToken, @required this.accountID})
      : assert(plaidPublicToken != null && accountID != null);

  @override
  List<Object> get props => [plaidPublicToken, accountID];
}
