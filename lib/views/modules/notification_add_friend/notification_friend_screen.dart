import 'package:chat_application/views/modules/notification_add_friend/cubit/notification_friend_cubit.dart';
import 'package:chat_application/views/modules/notification_add_friend/cubit/notification_friend_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationFriendScreen extends StatefulWidget {
  const NotificationFriendScreen({super.key});

  @override
  State<NotificationFriendScreen> createState() =>
      _NotificationFriendScreenState();
}

class _NotificationFriendScreenState extends State<NotificationFriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<NotificationFriendCubit, NotificationFriendState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}
