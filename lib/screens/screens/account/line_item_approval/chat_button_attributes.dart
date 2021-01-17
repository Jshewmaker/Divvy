import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatButtonAttributes {
  final UserModel user;
  final Project project;
  final bool newMessage;

  String title;
  String name;
  IconData icon;
  Color iconColor;

  ChatButtonAttributes(this.user, this.project, this.newMessage) {
    icon = (newMessage) ? Icons.mark_chat_unread : Icons.chat_bubble;
    iconColor = (newMessage) ? Colors.red : Color(0xFF26A69A);
  }

  get props => [title, name, icon, iconColor];
}

class HomeownerChatButtonAttributes extends ChatButtonAttributes {
  HomeownerChatButtonAttributes(
      UserModel user, Project project, bool newMessage)
      : super(user, project, newMessage) {
    title = "General Contractor";
    name = project.generalContractorName;
  }
}

class GCChatButtonAttributes extends ChatButtonAttributes {
  GCChatButtonAttributes(UserModel user, Project project, bool newMessage)
      : super(user, project, newMessage) {
    title = "Homeowner";
    name = project.homeownerName;
  }
}
