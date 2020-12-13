import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/bloc/project/project_event.dart';
import 'package:divvy/bloc/project/project_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import 'package:authentication_repository/src/models/project_line_items/messages.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseService firebaseService;

  ChatBloc({@required this.firebaseService})
      : assert(firebaseService != null),
        super(ChatInitial());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is LoadChat) {
      yield ChatLoadInProgress();
      try {
        if (event.lineItem.messages == null) {
          yield NoMessages();
        } else {
          yield ChatLoadSuccess(lineItem: event.lineItem);
        }
        /*
        UserModel user = await firebaseService.getUserData();
        final LineItemListModel lineItems = await firebaseService.g;
        if (project == null) {
          yield ChatNotConnected();
        } else {
          yield ChatLoadSuccess(project: project);
        }
*/
        // final LineItemListModel lineItem =
        //     await firebaseService.getPhaseLineItems(1, event.projectID);
      } catch (_) {
        yield ChatLoadFailure();
      }
    }
    if (event is SendMessage) {
      yield ChatLoadInProgress();
      try {
        Message messageModel = Message(
            id: event.user.id,
            message: event.message,
            timestamp: Timestamp.now());
        firebaseService.addMessageToProjectDocument(
            messageModel.toMap(), event.project.projectID, event.lineItem.id);
        LineItem updatedLineItem = await firebaseService.getLineItem(
            event.project.projectID, event.lineItem.id);
        if (updatedLineItem.messages == null) {
          yield NoMessages();
        } else {
          yield ChatLoadSuccess(lineItem: updatedLineItem);
        }
      } catch (_) {
        yield ChatLoadFailure();
      }
    }
  }
}
