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

/*
  static Message fromEntity(Map message) {
    return Message(
      generalContractorApprovalDate: entity.generalContractorApprovalDate,
      cost: entity.cost,
      homeownerApprovalDate: entity.homeownerApprovalDate,
      datePaid: entity.datePaid,
      phase: entity.phase,
      title: entity.title,
      subContractor: entity.subContractor,
      comments: entity.comments,
      id: entity.id,
      expectFinishedDate: entity.expectFinishedDate,
    );
  }

  LineItemEntity toEntity() {
    return LineItemEntity(
      generalContractorApprovalDate,
      cost,
      homeownerApprovalDate,
      datePaid,
      phase,
      title,
      subContractor,
      comments,
      id,
      expectFinishedDate,
    );
  }
  */
}
