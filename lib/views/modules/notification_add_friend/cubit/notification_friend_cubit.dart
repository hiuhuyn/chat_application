import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/views/modules/notification_add_friend/cubit/notification_friend_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/friend.dart';

class NotificationFriendCubit extends Cubit<NotificationFriendState> {
  NotificationFriendCubit() : super(NotificationFriendStateInti());
  uploadData(List<Friend> allFriend) {
    try {
      List<Friend> otherSend = [];
      List<Friend> youSend = [];
      var user = Auth.currentUser;
      if (user != null) {
        for (var element in allFriend) {
          if (element.isFriend != true) {
            if (element.idUser1 == user.uid) {
              youSend.add(element);
            } else {
              otherSend.add(element);
            }
          }
        }
        emit(state.copyWith(
            allFriend: allFriend, otherSend: otherSend, youSend: youSend));
      }
    } catch (e) {
      print("NotificationFriendCubit uploadData: $e");
    }
  }

  addData(Friend friend) {
    try {
      var user = Auth.currentUser;
      List<Friend> allFriend = List.from(state.allFriend);
      int indexFriend =
          allFriend.indexWhere((element) => element.id == friend.id);
      if (indexFriend == -1) {
        allFriend.add(friend);
      } else {
        allFriend[indexFriend] = friend;
      }

      if (user != null) {
        if (friend.idUser1 == user.uid) {
          List<Friend> youSend = List.from(state.youSend);
          int i = youSend.indexWhere((element) => element.id == friend.id);
          if (friend.isFriend == true) {
            if (i != -1) {
              youSend.removeAt(i);
            }
          } else {
            if (i == -1) {
              youSend.add(friend);
            } else {
              youSend[i] = friend;
            }
          }

          emit(state.copyWith(allFriend: allFriend, youSend: youSend));
        } else if (friend.idUser2 == user.uid) {
          List<Friend> otherSend = List.from(state.otherSend);
          int i = otherSend.indexWhere((element) => element.id == friend.id);
          if (friend.isFriend == true) {
            if (i != -1) {
              otherSend.removeAt(i);
            }
          } else {
            if (i != -1) {
              otherSend[i] = friend;
            } else {
              otherSend.add(friend);
            }
          }
          emit(state.copyWith(allFriend: allFriend, otherSend: otherSend));
        }
      }
    } catch (e) {
      print("NotificationFriendCubit uploadData: $e");
    }
  }
}
