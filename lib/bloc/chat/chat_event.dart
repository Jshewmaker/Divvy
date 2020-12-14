import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChat extends ChatEvent {
  final LineItem lineItem;

  const LoadChat(this.lineItem);

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  final UserModel user;
  final Project project;
  final LineItem lineItem;

  const SendMessage(this.user, this.lineItem, this.message, this.project);

  @override
  List<Object> get props => [user, lineItem, message, project];
}
