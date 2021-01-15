import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MessageListEntity {
  final List<MessageEntity> messages;

  MessageListEntity({
    this.messages,
  });

  factory MessageListEntity.fromSnapshot(QuerySnapshot snapshot) {
    List<MessageEntity> messages = List<MessageEntity>();
    messages =
        snapshot.documents.map((i) => MessageEntity.fromSnapshot(i)).toList();

    return MessageListEntity(messages: messages);
  }
}

class MessageEntity extends Equatable {
  /// {@macro user}

  final String id;
  final String message;
  final Timestamp timestamp;

  const MessageEntity({
    @required this.id,
    this.message,
    this.timestamp,
  });

  Map<String, Object> toJson() {
    //TODO: messages to json
    return {
      "id": id,
      "message": message,
      "timestamp": timestamp,
    };
  }

  List<Object> get props => [
        id,
        message,
        timestamp,
      ];

  static MessageEntity fromJson(Map<String, Object> json) {
    //TODO: messages from json
    return MessageEntity(
      id: json["id"] as String,
      message: json["message"] as String,
      timestamp: json["timestamp"] as Timestamp,
    );
  }

  //Specific to Firestore
  static MessageEntity fromSnapshot(DocumentSnapshot snap) {
    return MessageEntity(
      id: snap.data['id'],
      message: snap.data['message'],
      timestamp: snap.data['timestamp'],
    );
  }

  //Specific to Firestore
  Map<String, Object> toDocument() {
    return {
      "id": id,
      "message": message,
      "timestamp": timestamp,
    };
  }
}
