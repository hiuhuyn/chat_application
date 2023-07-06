import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/views/modules/notification_add_friend/cubit/notification_friend_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/firebase/firebaseFriend.dart';
import '../../models/friend.dart';

class NotificationIconApp extends StatefulWidget {
  const NotificationIconApp({super.key});

  @override
  State<NotificationIconApp> createState() => _NotificationIconAppState();
}

class _NotificationIconAppState extends State<NotificationIconApp> {
  @override
  Widget build(BuildContext context) {
    List<Friend> listNotification =
        List.from(context.watch<NotificationFriendCubit>().state.otherSend);
    return StreamBuilder<Friend>(
        stream: FbFriend.listenAddFriend(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userId = Auth.currentUser!.uid;
            if (userId == snapshot.data!.idUser2 &&
                snapshot.data!.isFriend == false) {
              int index = listNotification
                  .indexWhere((element) => element.id == snapshot.data!.id);
              if (index == -1) {
                print("List notification add: ${snapshot.data}");
                listNotification.add(snapshot.data!);
              }
            }
          }

          return SizedBox(
            height: 50,
            width: 50,
            child: Stack(
              children: [
                const Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.notifications_none,
                      size: 40,
                    )),
                listNotification.isNotEmpty
                    ? Positioned(
                        right: 5,
                        top: 5,
                        child: Text(
                          listNotification.length.toString(),
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          );
        });
  }
}
