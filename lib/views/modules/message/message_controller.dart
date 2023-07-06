import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/data/firebase/firebaseMessage.dart';
import 'package:chat_application/models/conversation.dart';
import 'package:chat_application/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/firebase/firebaseConversation.dart';
import '../../../data/firebase/firebaseUser.dart';
import '../../../models/user.dart';
import 'cubit/message_cubit.dart';

class MessageController {
  BuildContext context;
  MessageController(this.context);

  createNewMessage(
      {required Conversation conversation,
      required String content,
      String? pathFile}) async {
    try {
      var user = Auth.currentUser;
      if (user != null) {
        Message message = Message(
            content: content,
            userId: user.uid,
            contentAt: DateTime.now().millisecondsSinceEpoch);
        message.messageId = await FbMessage.create(conversation.id!, message);
        if (message.messageId != null) {
          await FbConversation.updateMessageNew(conversation.id!, message);
        }
      }
    } catch (e) {
      print("createNewMessage: $e");
    }
  }

  listenUpdate(Conversation conversation) {
    try {
      FbConversation.listenEventById(conversation).listen((event) async {
        if (event.members != conversation.members) {
          List<UserModel> users = [];
          for (var element in event.members) {
            var user = await FbUser.searchById(element.userId!);
            users.add(user!);
          }
          context.read<MessageCubit>().uploatData(
                conversation: event,
                users: users,
              );
        } else {
          context.read<MessageCubit>().reloatData(conversation: event);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
