import 'package:chat_application/data/firebase/firebaseConversation.dart';
import 'package:chat_application/data/firebase/firebaseUser.dart';
import 'package:chat_application/models/conversation.dart';
import 'package:chat_application/models/friend.dart';
import 'package:chat_application/models/member.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_cubit.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_cubit.dart';
import 'package:chat_application/views/modules/home/cubit/home_cubit.dart';
import 'package:chat_application/views/modules/message/cubit/message_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/firebase/firebaseAuth.dart';
import '../../../data/firebase/firebaseFriend.dart';
import '../../../utils/notification_app.dart';
import '../../../utils/router/routesName.dart';
import '../notification_add_friend/cubit/notification_friend_cubit.dart';

class ChatController {
  BuildContext context;
  ChatController(this.context);
  Future firstLoadingData() async {
    try {
      try {
        await FbConversation.getAll().then((value) {
          context.read<ChatCubit>().firstLoadConversation(conversations: value);
        });
      } catch (e) {
        print(e);
      }
      try {
        await FbFriend.getAll().then((value) {
          context.read<NotificationFriendCubit>().uploadData(value);
          List<Friend> res =
              List.from(value.where((element) => element.isFriend == true));
          context.read<ChatCubit>().firstLoadFriends(friends: res);
        });
      } catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
    }
  }

  Future onClickUser(UserModel user) async {
    try {
      var state = context.read<ChatCubit>().state;
      User? userMain = Auth.currentUser;
      Conversation? conversation;
      if (userMain != null) {
        List<Conversation> conversations = List.from(state.conversations);
        conversations = List.from(
            conversations.where((element) => element.type == "single"));
        for (var element in conversations) {
          if (element.members.length == 2) {
            if ((element.members[0].userId == user.id &&
                    element.members[1].userId == userMain.uid) ||
                (element.members[1].userId == user.id &&
                    element.members[0].userId == userMain.uid)) {
              UserModel? userM2 = context.read<HomeCubit>().state.user;
              userM2 ??= await FbUser.searchById(userMain.uid);
              if (userM2 != null) {
                conversation = element;
                context
                    .read<MessageCubit>()
                    .uploatData(conversation: element, users: [user, userM2]);
              }
              break;
            }
          }
        }
        if (conversation != null) {
          Navigator.pushNamed(context, RoutesName.MEASSGE);
        } else {
          conversation = Conversation(
              createdAt: DateTime.now().millisecondsSinceEpoch,
              members: [
                Member(
                    submitAt: DateTime.now().millisecondsSinceEpoch,
                    userId: user.id),
                Member(
                    submitAt: DateTime.now().millisecondsSinceEpoch,
                    userId: userMain.uid)
              ],
              messages: []);
          conversation.id = await FbConversation.create(conversation);
          UserModel? userM2 = context.read<HomeCubit>().state.user;
          userM2 ??= await FbUser.searchById(userMain.uid);
          if (userM2 != null) {
            context
                .read<MessageCubit>()
                .reloatData(conversation: conversation, users: [user, userM2]);
            Navigator.pushNamed(context, RoutesName.MEASSGE);
          }
        }
      }
    } catch (e) {
      print("onClickUser: $e");
      NotificationApp.notificationBase(
          context: context, message: e.toString(), title: "Error");
    }
  }

  listenConversationUpdate() {
    try {
      FbConversation.listenChangeConversation().listen((event) {
        context.read<ChatCubit>().setConversationByToList(event);
      });
    } catch (e) {
      print("listenConversationUpdate: $e");
    }
  }

  listenFriendUpdate() {
    try {
      FbFriend.listenChangedFriend().listen((event) {
        context.read<NotificationFriendCubit>().addData(event);
        context.read<ChatCubit>().setFriendByToList(friend: event);
        context.read<AllUserCubit>().addFriend(event);
      });
    } catch (e) {
      print("listenFriendUpdate: $e");
    }
  }
}
