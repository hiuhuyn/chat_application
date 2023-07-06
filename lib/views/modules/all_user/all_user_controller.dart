import 'package:chat_application/data/firebase/firebaseUser.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_cubit.dart';
import 'package:chat_application/views/modules/notification_add_friend/cubit/notification_friend_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/firebase/firebaseAuth.dart';
import '../../../data/firebase/firebaseFriend.dart';
import '../../../models/friend.dart';
import '../../../models/user.dart';
import 'cubit/all_user_cubit.dart';

class AllUserController {
  BuildContext context;
  AllUserController(this.context);

  getData() async {
    try {
      List<UserModel> allUsers = [];
      List<Friend> allFriends = [];
      List<UserModel> userFriend = [];
      List<UserModel> userOther = [];
      var user = Auth.currentUser;
      if (user == null) {
        throw ("User is not logged in");
      }
      try {
        allUsers = await FbUser.getAll();
      } catch (e) {
        print(e);
      }
      try {
        allFriends =
            List.from(context.read<NotificationFriendCubit>().state.allFriend);
        if (allFriends.isEmpty) {
          allFriends = await FbFriend.getAll();
        }
      } catch (e) {
        print(e);
      }

      List<Friend> friends =
          List.from(allFriends.where((element) => element.isFriend == true));
      await Future.forEach(allUsers, (itemUser) {
        int lengthUF = userFriend.length;
        for (var friend in friends) {
          if (friend.idUser1 == user.uid && friend.idUser2 == itemUser.id ||
              friend.idUser2 == user.uid && friend.idUser1 == itemUser.id) {
            userFriend.add(itemUser);
            break;
          }
        }
        if (lengthUF == userFriend.length) {
          userOther.add(itemUser);
        }
      }).then((value) {
        context.read<AllUserCubit>().uploadData(
            usersFriend: userFriend,
            allFriends: allFriends,
            allUser: allUsers,
            usersOther: userOther);
      });
    } catch (e) {
      print("getDataUserFriend $e");
    }
  }

  Future<Friend?> createNewFriend(UserModel user) async {
    try {
      var userMain = Auth.currentUser;
      if (userMain != null) {
        Friend friend = Friend(idUser1: userMain.uid, idUser2: user.id);
        await FbFriend.create(friend).then((value) {
          if (value != null) {
            friend.id = value;
            context.read<AllUserCubit>().addFriend(friend);
            return friend;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future unFriend(UserModel value) async {
    try {
      var state = context.read<AllUserCubit>().state;
      var user = Auth.currentUser!;
      List<Friend> allFriend = List.from(state.allFriend);
      List<UserModel> usersFriend = List.from(state.usersFriend);
      List<UserModel> usersOther = List.from(state.usersOther);
      int index = allFriend.indexWhere((element) =>
          (user.uid == element.idUser1 && value.id == element.idUser2) ||
          (user.uid == element.idUser2 && value.id == element.idUser1));
      if (index != -1) {
        await FbFriend.delete(allFriend[index].id!);
        context
            .read<ChatCubit>()
            .removeFriendAndUser(friend: allFriend[index], userModel: value);
        allFriend.removeAt(index);
      }
      index = usersFriend.indexWhere((element) => element.id == value.id);
      if (index != -1) {
        usersOther.add(value);
        usersFriend.removeAt(index);
      }

      context.read<AllUserCubit>().uploadData(
          usersOther: usersOther,
          usersFriend: usersFriend,
          allFriends: allFriend);
    } catch (e) {
      print(e);
    }
  }
}
