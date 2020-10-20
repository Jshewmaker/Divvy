import 'package:divvy/sila/plaid/models/plaid_public_token_exchange_response_model.dart';
import 'package:divvy/sila/plaid/plaid_bloc/plaid_event.dart';
import 'package:divvy/sila/plaid/plaid_bloc/plaid_state.dart';
import 'package:divvy/sila/plaid/plaid_network/plaid_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class PlaidBloc extends Bloc<PlaidEvent, PlaidState> {
  final PlaidRepository plaidRepository;

  PlaidBloc({@required this.plaidRepository})
      : assert(plaidRepository != null),
        super(PlaidInitial());

  @override
  Stream<PlaidState> mapEventToState(PlaidEvent event) async* {
    if (event is TokenRequested) {
      yield PlaidLoadInProgress();
      try {
        final PlaidPublicTokenExchangeResponseModel
            plaidPublicTokenExchangeResponseModel =
            await plaidRepository.getAccessToken(event.publicToken);
        yield PlaidLoadSuccess(
            plaidPublicTokenExchangeResponseModel:
                plaidPublicTokenExchangeResponseModel);
      } catch (_) {
        yield PlaidLoadFailure();
      }
    }
  }
}
