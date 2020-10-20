import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LinkAccountEvent extends Equatable {
  const LinkAccountEvent();
}

class LinkAccountRequest extends LinkAccountEvent {
  final String plaidPublicToken;

  const LinkAccountRequest({@required this.plaidPublicToken})
      : assert(plaidPublicToken != null);

  @override
  List<Object> get props => [plaidPublicToken];
}
