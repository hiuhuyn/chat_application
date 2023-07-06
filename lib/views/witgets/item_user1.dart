import 'package:chat_application/data/firebase/firebaseFriend.dart';
import 'package:chat_application/models/friend.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/views/modules/all_user/all_user_controller.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_cubit.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_cubit.dart';
import 'package:chat_application/views/modules/notification_add_friend/cubit/notification_friend_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/firebase/firebaseAuth.dart';

class ItemUser1 extends StatefulWidget {
  ItemUser1({
    super.key,
    required this.user,
    required this.onPressed,
  });
  UserModel user;
  VoidCallback onPressed;

  @override
  State<ItemUser1> createState() => _ItemUser1State();
}

class _ItemUser1State extends State<ItemUser1> {
  User user = FirebaseAuth.instance.currentUser!;
  ImageProvider image = const AssetImage("assets/images/img2.png");
  int indexFriend = -1;
  List<Friend> allFriend = [];
  Icon icon1 = const Icon(
    Icons.add_circle_outline,
    size: 35,
    color: Colors.blue,
  );
  Icon icon2 = const Icon(
    Icons.close,
    size: 35,
  );
  Icon icon3 = const Icon(Icons.check, size: 35, color: Colors.blue);
  int iconType = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateIconType(context);
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(blurRadius: 3, color: Colors.grey, offset: Offset(2, 2))
            ]),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 44,
              width: 44,
              child: CircleAvatar(
                backgroundImage: image,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${widget.user.name}",
              maxLines: 1,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                await onTapIcon();
              },
              child: SizedBox(
                  height: 44,
                  width: 44,
                  child: iconType == 1
                      ? icon1
                      : iconType == 2
                          ? icon2
                          : icon3),
            )
          ],
        ),
      ),
    );
  }

  Future onTapIcon() async {
    try {
      var state = context.read<AllUserCubit>().state;
      allFriend = List.from(state.allFriend);
      UserModel userModer = widget.user;
      User user = Auth.currentUser!;
      int indexFriend = allFriend.indexWhere((element) =>
          (element.idUser1 == userModer.id) && (user.uid == element.idUser2) ||
          (element.idUser2 == userModer.id) && (user.uid == element.idUser1));
      if (indexFriend != -1) {
        // có tồn tại friend
        if (allFriend[indexFriend].isFriend == false) {
          // nếu chưa phải bạn bè thì xóa, cập nhật
          if (allFriend[indexFriend].idUser1 == user.uid) {
            // hủy yêu cầu kết bạn nếu người gửi là bạn
            await FbFriend.delete(allFriend[indexFriend].id!);
            allFriend.removeAt(indexFriend);
            context.read<AllUserCubit>().reloadData(friends: allFriend);
            setState(() {
              iconType = 1;
            });
            print("Xóa yêu cầu");
          } else if (allFriend[indexFriend].idUser2 == user.uid) {
            //đồng ý yêu cầu kết bạn nếu người gửi là người khác
            List<UserModel> userFriend = List.from(state.usersFriend);
            userFriend.add(userModer);
            List<UserModel> usersOther = List.from(state.usersOther);
            usersOther.remove(userModer);
            allFriend[indexFriend].isFriend = true;
            // cập nhật isFriend lên db
            await FbFriend.updata(allFriend[indexFriend]);
            // yêu cầu load lại dữ liệu AllUserCubit
            context.read<AllUserCubit>().uploadData(
                allFriends: allFriend,
                usersFriend: userFriend,
                usersOther: usersOther);
            // thêm friend và user mới cho trang chat
            context.read<ChatCubit>().setFriendByToList(
                friend: allFriend[indexFriend], userNew: userModer);
            context
                .read<NotificationFriendCubit>()
                .addData(allFriend[indexFriend]);
            print("Đồng ý yêu cầu");
          } else {
            throw ("Không tìm thấy user");
          }
        }
      } else {
        // tạo mới
        await AllUserController(context).createNewFriend(userModer);
        setState(() {
          iconType = 2;
        });
        print("Tạo yêu cầu");
      }
    } catch (e) {
      print(e);
    }
  }

  void _updateIconType(BuildContext context) {
    setState(() {
      allFriend = List.from(context.read<AllUserCubit>().state.allFriend);
      indexFriend = allFriend.indexWhere((element) =>
          (element.idUser1 == widget.user.id) &&
              (user.uid == element.idUser2) ||
          (element.idUser2 == widget.user.id) && (user.uid == element.idUser1));
      if (indexFriend != -1) {
        if (allFriend[indexFriend].isFriend == false) {
          if (allFriend[indexFriend].idUser1 == user.uid) {
            iconType = 2;
          } else if (allFriend[indexFriend].idUser2 == user.uid) {
            iconType = 3;
          } else {
            throw ("${allFriend.toList()}");
          }
        }
      } else {
        iconType = 1;
      }
    });
  }
}
