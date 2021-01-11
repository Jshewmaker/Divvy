import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class WalletScreenEvent extends Equatable {
  const WalletScreenEvent();
}

class WalletScreenCheck extends WalletScreenEvent {
  final bool initial;
  const WalletScreenCheck({@required this.initial});

  @override
  List<Object> get props => [initial];
}
