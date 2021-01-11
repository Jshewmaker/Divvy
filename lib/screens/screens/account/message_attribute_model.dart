import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// [MessageAttributes.sent] represents a message sent by the current user.
/// [MessageAttributes.sent] represents a message sent by an account other than the current user.
/// {@endtemplate}
class MessageAttributes extends Equatable {
  /// {@macro user}

  final Color color;
  final Alignment messageAlignment;
  final TextAlign textAlignment;

  const MessageAttributes({
    this.color,
    this.messageAlignment,
    this.textAlignment,
  });

  static const sent = MessageAttributes(
    color: Color(0xFF80CBC4),
    messageAlignment: Alignment.topRight,
    textAlignment: TextAlign.right,
  );

  static const recieved = MessageAttributes(
    color: Color(0xFFEEEEEE),
    messageAlignment: Alignment.topLeft,
    textAlignment: TextAlign.left,
  );

  @override
  List<Object> get props => [
        color,
        messageAlignment,
        textAlignment,
      ];
}
