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
    if (event is LineItemRequestedForInvoice) {
      yield LineItemLoadInProgress();
      try {
        UserModel user = await firebaseService.getUserData();
        final LineItem lineItem =
            await firebaseService.getLineItem(user.projectID, event.lineItemID);
        final Project project =
            await firebaseService.getProjects(user.projectID);
        yield LineItemForInvoiceLoadSuccess(
            lineItem: lineItem, project: project);
      } catch (_) {
        yield LineItemLoadFailure();
      }
    }
  }
}
