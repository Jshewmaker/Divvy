import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class WalletScreenState extends Equatable {
  const WalletScreenState();

  List<Object> get props => [];
}

class WalletScreenInitial extends WalletScreenState {}

class WalletScreenLoadInProgress extends WalletScreenState {}

class WalletScreenLoaded extends WalletScreenState {
  final bool bankAccountIsLinked;

  WalletScreenLoaded({@required this.bankAccountIsLinked})
      : assert(bankAccountIsLinked != null);

  @override
  List<Object> get props => [bankAccountIsLinked];
}

class WalletScreenLoadFailure extends WalletScreenState {}
