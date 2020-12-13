import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:meta/meta.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoadInProgress extends ChatState {}

class NoMessages extends ChatState {}

class ChatLoadSuccess extends ChatState {
  final LineItem lineItem;

  const ChatLoadSuccess({@required this.lineItem});

  @override
  List<Object> get props => [lineItem];

  @override
  String toString() => 'ChatConnected { lineItem: $lineItem}';
}

class ChatLoadFailure extends ChatState {}
