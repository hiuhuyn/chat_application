import 'package:chat_application/data/firebase/firebaseUser.dart';
import 'package:chat_application/models/conversation.dart';
import 'package:chat_application/models/friend.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/firebase/firebaseAuth.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatStateInit());

  firstLoadFriends({
    required List<Friend> friends,
  }) async {
    try {
      List<UserModel> users = [];
      var user = Auth.currentUser;
      if (user != null) {
        for (var element in friends) {
          if (element.isFriend!) {
            String? uid;
            if (user.uid == element.idUser1) {
              uid = element.idUser2!;
            } else if (user.uid == element.idUser2) {
              uid = element.idUser1!;
            }
            if (uid != null) {
              UserModel? userModel = await FbUser.searchById(uid);
              if (userModel != null) {
                users.add(userModel);
              } else {
                print("updatefriends User not found");
              }
            }
          }
        }
        emit(state.copyWith(friends: friends, users: users));
      }
    } catch (e) {
      rethrow;
    }
  }

  firstLoadConversation({List<Conversation>? conversations}) async {
    emit(state.copyWith(conversations: conversations));
  }

  setFriendByToList({required Friend friend, UserModel? userNew}) async {
    try {
      List<Friend> friends = List.from(state.friends);
      List<UserModel> users = List.from(state.users);
      var user = Auth.currentUser;

      if (friend.isFriend == true &&
          (user!.uid == friend.idUser1 || user.uid == friend.idUser2)) {
        if (userNew != null) {
          int i = users.indexWhere((element) => element.id == userNew.id);
          if (i == -1) {
            users.add(userNew);
          } else {
            users[i] = userNew;
          }
          i = friends.indexWhere((element) => element.id == friend.id);
          if (i == -1) {
            friends.add(friend);
          } else {
            friends[i] = friend;
          }
        } else {
          String? uid;
          if (user.uid == friend.idUser1) {
            uid = friend.idUser2!;
          } else if (user.uid == friend.idUser2) {
            uid = friend.idUser1!;
          }
          if (uid != null) {
            UserModel? userNew = await FbUser.searchById(uid);
            if (userNew != null) {
              int i = users.indexWhere((element) => element.id == userNew.id);
              if (i == -1) {
                users.add(userNew);
              } else {
                users[i] = userNew;
              }
              i = friends.indexWhere((element) => element.id == friend.id);
              if (i == -1) {
                friends.add(friend);
              } else {
                friends[i] = friend;
              }
            }
          }
        }
      } else if (friend.isFriend == false &&
          (user!.uid == friend.idUser1 || user.uid == friend.idUser2)) {
        int i = friends.indexWhere((element) => friend.id == element.id);
        if (i != -1) {
          friends.removeAt(i);
        }
        i = users.indexWhere((element) =>
            element.id == friend.idUser1 || element.id == friend.idUser2);
        if (i != -1) {
          users.removeAt(i);
        }
      }
      emit(state.copyWith(friends: friends, users: users));
    } catch (e) {
      rethrow;
    }
  }

  setConversationByToList(Conversation data) {
    List<Conversation> list = List.from(state.conversations);
    int index = list.indexWhere((element) => element.id == data.id);
    if (index != -1) {
      list[index] = data;
    } else {
      list.add(data);
    }

    emit(state.copyWith(conversations: list));
  }

  removeFriendAndUser({required Friend friend, UserModel? userModel}) {
    List<Friend> friends = List.from(state.friends);
    List<UserModel> users = List.from(state.users);
    friends.remove(friend);
    if (userModel != null) {
      users.removeWhere((element) => element.id == userModel.id);
    } else {
      users.removeWhere((element) =>
          element.id == friend.idUser1 || element.id == friend.idUser2);
    }
    emit(state.copyWith(friends: friends, users: users));
  }
}
