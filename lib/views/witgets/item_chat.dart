import 'package:chat_application/data/firebase/firebaseUser.dart';
import 'package:chat_application/models/conversation.dart';
import 'package:chat_application/models/member.dart';
import 'package:chat_application/utils/router/routesName.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_cubit.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_cubit.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_state.dart';
import 'package:chat_application/views/modules/home/cubit/home_cubit.dart';
import 'package:chat_application/views/modules/message/cubit/message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/firebase/firebaseAuth.dart';
import '../../models/user.dart';
import '../modules/all_user/cubit/all_user_state.dart';

class ItemChat extends StatefulWidget {
  ItemChat({super.key, required this.conversation});
  Conversation conversation;

  @override
  State<ItemChat> createState() => _ItemChatState();
}

class _ItemChatState extends State<ItemChat> {
  ImageProvider image = const AssetImage("assets/images/img2.png");
  String content = "";
  List<UserModel> usersMember = [];
  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  getUserMember(AllUserState state) {
    usersMember.clear();
    int index = -1;
    List<UserModel> usersFriend = List.from(state.usersFriend);
    List<Member> listMember = List.from(widget.conversation.members
        .where((element) => element.userId != Auth.currentUser!.uid));
    for (var element in listMember) {
      index = usersFriend.indexWhere((value) => value.id == element.userId);
      if (index != -1) {
        usersMember.add(usersFriend[index]);
      }
    }
    if (usersMember.length != listMember.length) {
      List<UserModel> usersOther = List.from(state.usersOther);
      for (var element in listMember) {
        index = usersOther.indexWhere((value) => value.id == element.userId);
        if (index != -1) {
          usersMember.add(usersOther[index]);
        }
      }
    }
  }

  setUpUi() async {
    content = "${widget.conversation.messageNew?.content}";
    int index = usersMember.indexWhere(
        (element) => element.id == widget.conversation.messageNew?.userId);
    if (index != -1) {
      if (Auth.currentUser?.uid == widget.conversation.messageNew?.userId) {
        content = "You: $content";
      } else {
        content = "${usersMember[index].name}: $content";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserMember(context.watch<AllUserCubit>().state);
    setUpUi();
    return InkWell(
      onTap: () {
        context
            .read<MessageCubit>()
            .uploatData(conversation: widget.conversation, users: usersMember);
        Navigator.pushNamed(context, RoutesName.MEASSGE);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(blurRadius: 2, offset: Offset(1, 1), color: Colors.grey)
          ],
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircleAvatar(
                backgroundImage: image,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.getNameChat(context),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
