import 'package:equatable/equatable.dart';

abstract class WalletScreenEvent extends Equatable {
  const WalletScreenEvent();
}

class WalletScreenCheck extends WalletScreenEvent {
  const WalletScreenCheck();

  @override
  List<Object> get props => [];
}
