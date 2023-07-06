import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/utils/router/routesName.dart';
import 'package:chat_application/views/modules/chats/chat_controller.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_cubit.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/appColors.dart';
import '../../witgets/item_chat.dart';
import '../../witgets/item_friend_1.dart';
import '../../witgets/notification_icon.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ChatController(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroudApp,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: _head(context),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (value) {},
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    label: const Icon(Icons.search),
                    hintText: "Search"),
              ),
            ),
            _listFriend(context),
            const Divider(
              height: 1,
            ),
            _listConversation(context),
          ],
        ));
  }

  Widget _head(BuildContext context) {
    User? user = Auth.currentUser;
    if (user == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.LOGIN, (route) => false);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        SizedBox(
          height: 40,
          width: 40,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/img2.png"),
          ),
        ),
        Text(
          "  Chats",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        NotificationIconApp()
      ],
    );
  }

  Widget _listFriend(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      return Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: state.users.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemFriend1(
              user: state.users[index],
              onPressed: () async {
                await _controller.onClickUser(state.users[index]);
              },
            );
          },
        ),
      );
    });
  }

  Widget _listConversation(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      return Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: state.conversations.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemChat(
              conversation: state.conversations[index],
            );
          },
        ),
      );
    });
  }
}
