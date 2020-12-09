import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/line_items/line_item_event.dart';
import 'package:divvy/bloc/line_items/line_item_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class LineItemBloc extends Bloc<LineItemEvent, LineItemState> {
  final FirebaseService firebaseService;

  LineItemBloc({@required this.firebaseService})
      : assert(firebaseService != null),
        super(LineItemInitial());

  @override
  Stream<LineItemState> mapEventToState(LineItemEvent event) async* {
    if (event is LineItemRequested) {
      yield LineItemLoadInProgress();
      try {
        UserModel user = await firebaseService.getUserData();
        final LineItemListModel lineItems = await firebaseService
            .getPhaseLineItems(event.phase, user.projectID);
        yield LineItemLoadSuccess(lineItems: lineItems);
      } catch (_) {
        yield LineItemLoadFailure();
      }
    }
  }
}
