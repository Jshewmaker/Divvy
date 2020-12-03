import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WalletScreenState extends Equatable {
  const WalletScreenState();

  List<Object> get props => [];
}

class WalletScreenInitialState extends WalletScreenState {}

class WalletScreenLoadInProgress extends WalletScreenState {}

class WalletScreenAccountNotLinked extends WalletScreenState {
  final bool bankAccountIsLinked;

  WalletScreenAccountNotLinked({@required this.bankAccountIsLinked})
      : assert(bankAccountIsLinked != null);

  @override
  List<Object> get props => [bankAccountIsLinked];
}

class WalletScreenHasAccountLinked extends WalletScreenState {
  final bool bankAccountIsLinked;

  WalletScreenHasAccountLinked({@required this.bankAccountIsLinked})
      : assert(bankAccountIsLinked != null);

  @override
  List<Object> get props => [bankAccountIsLinked];
}

class WalletScreenLoadFailure extends WalletScreenState {}
