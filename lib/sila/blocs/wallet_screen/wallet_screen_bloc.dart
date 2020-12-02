import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_event.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_state.dart';

class WalletScreenBloc extends Bloc<WalletScreenEvent, WalletScreenState> {
  WalletScreenBloc() : super(WalletScreenInitial());

  @override
  Stream<WalletScreenState> mapEventToState(WalletScreenEvent event) async* {
    if (event is WalletScreenCheck) {
      yield WalletScreenLoadInProgress();
    }
    try{
      FirebaseService _firebaseService = FirebaseService();
      UserModel user = await _firebaseService.getUserData();
      yield WalletScreenLoaded(bankAccountIsLinked: user.)
    }
  }
}
