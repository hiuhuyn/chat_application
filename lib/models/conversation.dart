import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/data/firebase/firebaseUser.dart';
import 'package:chat_application/models/user.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'member.dart';
import 'message.dart';

class Conversation {
  String? id;
  String? conversationName;
  String? avatar;
  int? createdAt;
  List<Member> members;
  List<Message> messages;
  Message? messageNew;
  String? type;

  Conversation(
      {this.id,
      this.messageNew,
      this.conversationName,
      this.avatar,
      this.createdAt,
      this.members = const <Member>[],
      this.messages = const <Message>[],
      this.type = 'single'});

  Map<dynamic, dynamic> toMap() {
    Map<dynamic, dynamic> memberMap = {};
    for (var element in members) {
      memberMap[element.userId] = element.submitAt;
    }
    Map<dynamic, dynamic> msgMap = {};
    for (var element in messages) {
      msgMap[element.messageId] = element.toMap();
    }

    return <dynamic, dynamic>{
      'conversationName': conversationName,
      'avatar': avatar,
      'createdAt': createdAt,
      'members': memberMap,
      'messages': msgMap,
      'messageNew': messageNew?.toMap(),
      'type': type
    };
  }

  factory Conversation.fromMap(String? id, Map<dynamic, dynamic> map) {
    List<Member> membersList = [];
    List<Message> messagesList = [];
    try {
      Map<dynamic, dynamic>? mapMember = map['members'];
      mapMember?.forEach(
        (key, value) {
          String? idUser = key.toString();
          int? submitAt = value;
          Member member = Member(userId: idUser, submitAt: submitAt);
          membersList.add(member);
        },
      );
    } catch (e) {
      throw ("members add error: $e");
    }
    try {
      Map<dynamic, dynamic>? mapMsg = map['messages'];
      if (mapMsg != null) {
        mapMsg.forEach(
          (key, value) {
            Map<dynamic, dynamic>? data = value as Map<dynamic, dynamic>;
            Message message = Message.fromMap(key.toString(), data);
            messagesList.add(message);
          },
        );
      }
    } catch (e) {
      throw ("messages add error: $e");
    }
    Message? messageNew;
    try {
      if (map["messageNew"] != null) {
        Map<dynamic, dynamic>? data =
            map["messageNew"] as Map<dynamic, dynamic>;
        messageNew = Message.fromMap(null, data);
      }
    } catch (e) {
      throw ("messageNew add error: $e");
    }

    return Conversation(
      id: id,
      conversationName: map['conversationName'],
      avatar: map['avatar'],
      createdAt: map['createdAt'],
      members: membersList,
      messages: messagesList,
      messageNew: messageNew,
      type: map['type'],
    );
  }

  @override
  String toString() {
    return 'Conversation(id: $id, conversationName: $conversationName, avatar: $avatar, createdAt: $createdAt, members: $members, messages: $messages, messageNew: $messageNew, type: $type)';
  }

  Conversation copyWith(
      {String? id,
      String? conversationName,
      String? avatar,
      int? createdAt,
      List<Member>? members,
      List<Message>? messages,
      String? type,
      Message? messageNew}) {
    return Conversation(
      id: id ?? this.id,
      conversationName: conversationName ?? this.conversationName,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
      messages: messages ?? this.messages,
      messageNew: messageNew ?? this.messageNew,
      type: type ?? this.type,
    );
  }

  String getNameChat(BuildContext context) {
    String name = "";
    if (type == "single") {
      var user = Auth.currentUser;
      List<UserModel> allUser =
          List.from(context.read<AllUserCubit>().state.allUser);
      int index = -1;
      if (members.length == 2) {
        if (user!.uid == members[0].userId) {
          index =
              allUser.indexWhere((element) => element.id == members[1].userId);
        } else {
          index =
              allUser.indexWhere((element) => element.id == members[0].userId);
        }
      }
      if (index != -1) {
        name = "${allUser[index].name}";
      }
    } else {
      name = "$conversationName";
    }
    return name;
  }

  List<Message> getMessageSort() {
    List<Message> res = List.from(messages);
    res.sort((a, b) => a.contentAt!.compareTo(b.contentAt!));
    return res;
  }
}
