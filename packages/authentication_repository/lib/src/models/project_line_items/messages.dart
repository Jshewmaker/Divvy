import 'package:authentication_repository/src/models/project_line_items/messages_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MessageListModel {
  final List<Message> messages;

  MessageListModel({
    this.messages,
  });

  factory MessageListModel.fromList(List<dynamic> messageList) {
    List<Message> messages = List<Message>();
    messages = messageList.map((i) => Message.fromList(i)).toList();

    return MessageListModel(messages: messages);
  }

  factory MessageListModel.fromEntity(MessageListEntity entityList) {
    List<Message> messages = List<Message>();
    messages = entityList.messages.map((i) => Message.fromEntity(i)).toList();

    return MessageListModel(messages: messages);
  }

  List<Map> toList() {
    List<Map> messageList;
    messageList = messages.map((i) => i.toMap()).toList();
    return messageList;
  }
}

class Message extends Equatable {
  /// {@macro user}

  final String id;
  final String message;
  final Timestamp timestamp;

  const Message({
    @required this.id,
    this.message,
    this.timestamp,
  });

  /// Empty user which represents an unauthenticated user.
  static const empty = Message(
    id: '',
    message: '',
    timestamp: null,
  );

  static Message fromEntity(MessageEntity entity) {
    return Message(
      id: entity.id != null ? entity.id : '',
      message: entity.message != null ? entity.message : '',
      timestamp: entity.timestamp,
    );
  }

  @override
  List<Object> get props => [
        id,
        message,
        timestamp,
      ];

  static Message fromList(Map message) {
    return Message(
      id: message['id'],
      message: message['message'],
      timestamp: message['timestamp'],
    );
  }

  Map<String, Object> toMap() {
    return {
      "id": id,
      "message": message,
      "timestamp": timestamp,
    };
  }
}
