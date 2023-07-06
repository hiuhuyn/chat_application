import 'package:chat_application/data/firebase/firebaseUser.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/firebase/firebaseAuth.dart';
import '../../../../models/friend.dart';
import '../../../../models/user.dart';

class AllUserCubit extends Cubit<AllUserState> {
  AllUserCubit() : super(AllUserState());
  uploadData({
    required List<UserModel> usersOther,
    required List<UserModel> usersFriend,
    List<UserModel>? allUser,
    required List<Friend> allFriends,
  }) async {
    try {
      emit(state.copyWith(
          allUser: allUser,
          usersOther: usersOther,
          usersFriend: usersFriend,
          allFriend: allFriends));
    } catch (e) {
      print(e);
    }
  }

  reloadData(
      {List<UserModel>? usersOther,
      List<UserModel>? usersFriend,
      List<Friend>? friends}) async {
    try {
      emit(state.copyWith(
          usersOther: usersOther,
          usersFriend: usersFriend,
          allFriend: friends));
    } catch (e) {
      print(e);
    }
  }

  removeUserOther(UserModel userModel) {
    try {
      List<UserModel> list = List.from(state.usersOther);
      list.remove(userModel);
      emit(state.copyWith(usersOther: list));
    } catch (e) {
      print(e);
    }
  }

  addFriend(Friend friend) async {
    try {
      List<Friend> listAll = List.from(state.allFriend);
      List<UserModel> userFriend = List.from(state.usersFriend);
      List<UserModel> userOther = List.from(state.usersOther);
      int indexFriend =
          listAll.indexWhere((element) => element.id == friend.id);
      if (indexFriend == -1) {
        listAll.add(friend);
      } else {
        listAll[indexFriend] = friend;
      }
      var user = Auth.currentUser!;

      if (user.uid == friend.idUser1) {
        int indexUser =
            userFriend.indexWhere((element) => element.id == friend.idUser2);
        if (indexUser != -1) {
          // user có trong userFriend thì xóa và thêm vào other
          userOther.add(userFriend[indexUser]);
          userFriend.removeAt(indexUser);
        } else {
          // kiểm tra ở list userOther
          indexUser =
              userOther.indexWhere((element) => element.id == friend.idUser2);
          if (indexUser != -1) {
            if (friend.isFriend == true) {
              userFriend.add(userOther[indexUser]);
              userOther.removeAt(indexUser);
            }
          } else {
            // user chưa được tải -> tải mới
            var userNew = await FbUser.searchById(friend.idUser2!);
            if (friend.isFriend == true) {
              userFriend.add(userNew!);
            } else {
              userOther.add(userNew!);
            }
          }
        }
      } else if (user.uid == friend.idUser2) {
        int indexUser =
            userFriend.indexWhere((element) => element.id == friend.idUser1);
        if (indexUser != -1) {
          // user có trong userFriend thì xóa và thêm vào other
          userOther.add(userFriend[indexUser]);
          userFriend.removeAt(indexUser);
        } else {
          // tiếp tục kiểm tra ở list userOther
          indexUser =
              userOther.indexWhere((element) => element.id == friend.idUser1);
          if (indexUser != -1) {
            if (friend.isFriend == true) {
              userFriend.add(userOther[indexUser]);
              userOther.removeAt(indexUser);
            }
          } else {
            // user chưa được tải -> tải mới
            var userNew = await FbUser.searchById(friend.idUser1!);
            if (friend.isFriend == true) {
              userFriend.add(userNew!);
            } else {
              userOther.add(userNew!);
            }
          }
        }
      } else {
        // trường hợp chưa biết nên tải user nào
        int index1 =
            userOther.indexWhere((element) => element.id == friend.idUser1);
        if (index1 == -1) {
          var userNew = await FbUser.searchById(friend.idUser1!);
          userOther.add(userNew!);
        }
        int index2 =
            userOther.indexWhere((element) => element.id == friend.idUser2);
        if (index2 == -1) {
          // idUser2 ko tồn tại trong other -> tải idUser2
          var userNew = await FbUser.searchById(friend.idUser2!);
          userOther.add(userNew!);
        } // trường hợp còn lại thì kho tải vì đã tìm thấy trong userother
      }
      emit(state.copyWith(
          allFriend: listAll, usersFriend: userFriend, usersOther: userOther));
    } catch (e) {
      print(e);
    }
  }
}
