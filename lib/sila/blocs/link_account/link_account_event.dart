import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LinkAccountEvent extends Equatable {
  const LinkAccountEvent();
}

class LinkAccountRequest extends LinkAccountEvent {
  final String plaidPublicToken;
  final String accountID;
  final String accountName;

  const LinkAccountRequest(
      {@required this.plaidPublicToken,
      @required this.accountID,
      @required this.accountName})
      : assert(plaidPublicToken != null &&
            accountID != null &&
            accountName != null);

  @override
  List<Object> get props => [plaidPublicToken, accountID];
}
