import 'dart:async';

import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/models/conversation.dart';
import 'package:chat_application/models/member.dart';
import 'package:chat_application/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FbConversation {
  static final _db = FirebaseDatabase.instance;

  static Future<String?> create(Conversation data) async {
    try {
      DatabaseReference ref = _db.ref("/conversations").push();
      await ref.set(data.toMap());
      return ref.key;
    } catch (e) {
      throw ("Create conversation failed: $e");
    }
  }

  static Future update(Conversation data) async {
    try {
      await _db.ref().update({"/conversations/${data.id}": data.toMap()});
    } catch (e) {
      throw ("update conversation failed: $e");
    }
  }

  static Future updateMessageNew(String id, Message data) async {
    try {
      await _db.ref("/conversations/$id/messageNew").set(data.toMap());
    } catch (e) {
      throw ("update conversation failed: $e");
    }
  }

  static Future delete(Conversation data) async {
    try {
      await _db.ref("/conversations/${data.id}").remove();
    } catch (e) {
      throw ("delete conversation failed: $e");
    }
  }

  static Future<Conversation> getById(String id) async {
    try {
      var res = await _db.ref("/conversations/$id").get();
      Map<dynamic, dynamic>? data =
          Map<dynamic, dynamic>.from(res.value as Map<dynamic, dynamic>);
      return Conversation.fromMap(id, data);
    } catch (e) {
      throw ("getById conversation failed: $e");
    }
  }

  static Future<List<Conversation>> getAll() async {
    List<Conversation> conversations = [];
    try {
      User? user = Auth.currentUser;
      if (user != null) {
        await _db.ref("/conversations").get().then((snapshot) {
          if (snapshot.value != null) {
            Map<dynamic, dynamic>? data =
                snapshot.value as Map<dynamic, dynamic>;
            data.forEach((key, value) {
              Map<dynamic, dynamic>? memberMap =
                  value["members"] as Map<dynamic, dynamic>;
              if (memberMap.containsKey(user.uid)) {
                Map<dynamic, dynamic>? dataConver =
                    value as Map<dynamic, dynamic>;
                Conversation conversation =
                    Conversation.fromMap(key, dataConver);
                conversations.add(conversation);
              }
            });
          }
        });
        return conversations;
      } else {
        throw ("User is not sign in");
      }
    } catch (e) {
      throw ("getByUserId conversation failed: $e");
    }
  }

  static Stream<Conversation> listenChangeConversation() {
    final StreamController<Conversation> controller =
        StreamController<Conversation>();
    try {
      User? user = Auth.currentUser;
      if (user != null) {
        _db.ref("/conversations").onChildChanged.listen((event) {
          var snapshot = event.snapshot;
          if (snapshot.value != null) {
            Map<dynamic, dynamic>? data =
                snapshot.value as Map<dynamic, dynamic>;
            Map<dynamic, dynamic>? memberMap =
                data["members"] as Map<dynamic, dynamic>;
            if (memberMap.containsKey(user.uid)) {
              Conversation conversation =
                  Conversation.fromMap(snapshot.key, data);
              controller.add(conversation);
            }
          }
        });
      } else {
        controller.addError("User is not sign in");
      }
    } catch (e) {
      controller.addError("listenChangeConversation conversation failed: $e");
    }
    return controller.stream;
  }

  static Stream<Conversation> listenEventById(Conversation conversation) {
    StreamController<Conversation> controller =
        StreamController<Conversation>();
    try {
      _db
          .ref("/conversations/${conversation.id}")
          .onChildChanged
          .listen((event) {
        var snapshot = event.snapshot;
        switch (snapshot.key) {
          case "avatar":
            conversation =
                conversation.copyWith(avatar: snapshot.value.toString());
            break;
          case "type":
            conversation =
                conversation.copyWith(type: snapshot.value.toString());
            break;
          case "conversationName":
            conversation = conversation.copyWith(
                conversationName: snapshot.value.toString());
            break;
          case "createdAt":
            int createAt = int.parse(snapshot.value.toString());
            conversation = conversation.copyWith(createdAt: createAt);
            break;
          case "messageNew":
            try {
              Map<dynamic, dynamic>? data =
                  snapshot.value as Map<dynamic, dynamic>;
              Message messageNew = Message.fromMap(null, data);
              conversation = conversation.copyWith(messageNew: messageNew);
            } catch (e) {
              throw ("messageNew add error: $e");
            }
            break;
          case "members":
            Map<dynamic, dynamic> membersMap =
                snapshot.value as Map<dynamic, dynamic>;
            List<Member> members = [];
            membersMap.forEach((key, value) {
              String? idUser = key.toString();
              int? submitAt = value;
              Member member = Member(userId: idUser, submitAt: submitAt);
              members.add(member);
            });
            conversation = conversation.copyWith(members: members);
            break;
          case "messages":
            Map<dynamic, dynamic> messagesMap =
                snapshot.value as Map<dynamic, dynamic>;
            List<Message> messages = conversation.messages;
            messagesMap.forEach((key, value) {
              Map<dynamic, dynamic>? data = value as Map<dynamic, dynamic>;
              Message message = Message.fromMap(key.toString(), data);
              int index = messages.indexWhere(
                  (element) => element.messageId == message.messageId);
              if (index != -1) {
                messages[index] = message;
              } else {
                messages.add(message);
              }
            });
            conversation = conversation.copyWith(messages: messages);
            break;
          default:
            print(
                "listenEventById conversation Default: key: ${snapshot.key}, value: ${snapshot.value}");
        }
        controller.add(conversation);
      });
    } catch (e) {
      controller.addError(("listenEvent by id failed: $e"));
    }
    return controller.stream;
  }
}
