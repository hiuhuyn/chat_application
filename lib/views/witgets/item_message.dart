import 'package:chat_application/data/firebase/firebaseUser.dart';
import 'package:chat_application/models/message.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_cubit.dart';
import 'package:chat_application/views/modules/home/cubit/home_cubit.dart';
import 'package:chat_application/views/modules/message/cubit/message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemMessage extends StatefulWidget {
  ItemMessage({super.key, required this.message});
  Message message;

  @override
  State<ItemMessage> createState() => _ItemMessageState();
}

class _ItemMessageState extends State<ItemMessage> {
  UserModel _userSend = UserModel();

  bool _checkType = false;
  @override
  void initState() {
    super.initState();
    UserModel? userMain = context.read<HomeCubit>().state.user;
    if (userMain!.id == widget.message.userId) {
      setState(() {
        _userSend = userMain;
        _checkType = userMain.id == _userSend.id;
      });
    } else {
      List<UserModel> users =
          List.from(context.read<AllUserCubit>().state.allUser);
      int index =
          users.indexWhere((element) => element.id == widget.message.userId);
      if (index != -1) {
        _userSend = users[index];
        _checkType = userMain?.id == _userSend.id;
      } else {
        FbUser.searchById(widget.message.userId!).then((value) {
          if (value != null) {
            setState(() {
              _userSend = value;
              _checkType = userMain?.id == _userSend.id;
            });
            users.add(value);
            context.read<MessageCubit>().reloatData(users: users);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _checkType
          ? _body1()
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_avata(), _body2()],
            ),
    );
  }

  Widget _body1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(20)),
          child: Text(
            "${widget.message.content}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          widget.message.createAtString(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _body2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${_userSend.name}",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            "${widget.message.content}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          widget.message.createAtString(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _avata() {
    ImageProvider img = const AssetImage("assets/images/img2.png");
    try {} catch (e) {
      print(e);
    }
    return SizedBox(
      height: 30,
      width: 30,
      child: CircleAvatar(
        backgroundImage: img,
      ),
    );
  }
}
