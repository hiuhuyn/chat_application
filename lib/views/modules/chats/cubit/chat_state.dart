// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_application/models/user.dart';
import 'package:equatable/equatable.dart';

import 'package:chat_application/models/conversation.dart';

import '../../../../models/friend.dart';

class ChatState extends Equatable {
  List<Conversation> conversations;
  List<Friend> friends;
  List<UserModel> users;

  ChatState(
      {required this.conversations,
      required this.friends,
      required this.users}) {
    if (conversations.length > 1) {
      for (int i = 0; i < conversations.length; i++) {
        for (int j = 1; j < conversations.length; j++) {
          if (conversations[i].messageNew != null &&
              conversations[j].messageNew != null) {
            if (conversations[i].messageNew!.contentAt! <
                conversations[j].messageNew!.contentAt!) {
              var t = conversations[i];
              conversations[i] = conversations[j];
              conversations[j] = t;
            }
          }
        }
      }
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [conversations, friends, users];

  ChatState copyWith(
      {List<Conversation>? conversations,
      List<Friend>? friends,
      List<UserModel>? users}) {
    return ChatState(
        conversations: conversations ?? this.conversations,
        friends: friends ?? this.friends,
        users: users ?? this.users);
  }
}

class ChatStateInit extends ChatState {
  ChatStateInit() : super(conversations: [], friends: [], users: []);
}
