import 'package:chat_application/views/modules/message/cubit/message_cubit.dart';
import 'package:chat_application/views/modules/message/cubit/message_state.dart';
import 'package:chat_application/views/modules/message/message_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/conversation.dart';
import '../../../utils/appColors.dart';
import '../../witgets/item_message.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _textController = TextEditingController();
  late final MessageController _controller;
  late Conversation _conversation;
  ImageProvider _imageAvt = const AssetImage("assets/images/img2.png");

  @override
  void initState() {
    super.initState();
    _controller = MessageController(context);
  }

  @override
  void dispose() {
    // context.read<MessageCubit>().resetData();
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.blue,
            )),
        title: _headTitle(context
            .watch<MessageCubit>()
            .state
            .conversation
            .getNameChat(context)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: BlocBuilder<MessageCubit, MessageState>(
              builder: (context, state) {
            _conversation = state.conversation;
            _controller.listenUpdate(_conversation);
            return ListView.builder(
              itemCount: state.conversation.getMessageSort().length,
              itemBuilder: (context, index) {
                return ItemMessage(
                  message: state.conversation.getMessageSort()[index],
                );
              },
            );
          })),
          inputContent()
        ],
      ),
    );
  }

  Widget inputContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 20),
      child: TextFormField(
        controller: _textController,
        decoration: InputDecoration(
            hintText: "Nhập nội dung",
            hintStyle:
                const TextStyle(color: AppColors.grey8D8D8D, fontSize: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            suffixIcon: IconButton(
                onPressed: () {
                  if (_conversation.id != null) {
                    _controller.createNewMessage(
                        content: _textController.text,
                        conversation: _conversation);
                    _textController.clear();
                  }
                },
                icon: const Icon(Icons.send))),
      ),
    );
  }

  Row _headTitle(String name) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: CircleAvatar(
            backgroundImage: _imageAvt,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(name,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black))
      ],
    );
  }
}
