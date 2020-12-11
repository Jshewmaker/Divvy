import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_event.dart';
import 'package:divvy/sila/blocs/wallet_screen/wallet_screen_state.dart';

class WalletScreenBloc extends Bloc<WalletScreenEvent, WalletScreenState> {
  WalletScreenBloc() : super(WalletScreenInitialState());

  @override
  Stream<WalletScreenState> mapEventToState(WalletScreenEvent event) async* {
    if (event is WalletScreenCheck) {
      yield WalletScreenLoadInProgress();
      try {
        FirebaseService _firebaseService = FirebaseService();
        final UserModel user = await _firebaseService.getUserData();
        if (user.bankAccountIsConnected != true) {
          yield WalletScreenAccountNotLinked(
              bankAccountIsLinked: false /*user.bankAccountIsConnected*/);
        } else {
          yield WalletScreenHasAccountLinked(
              bankAccountIsLinked: user.bankAccountIsConnected);
        }
      } catch (_) {
        yield WalletScreenLoadFailure();
      }
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
