import 'dart:async';

import 'package:chat_application/models/message.dart';
import 'package:firebase_database/firebase_database.dart';

class FbMessage {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  static Future<String?> create(String idConversation, Message data) async {
    try {
      var ref = _db.ref("/conversations/$idConversation/messages").push();
      await ref.set(data.toMap());
      return ref.key;
    } catch (e) {
      throw ("Create Message failed: $e ");
    }
  }

  static Future<List<Message>> getByIdConversation(
      String idConversation) async {
    List<Message> res = [];
    try {
      await _db
          .ref("/conversations/$idConversation/messages")
          .get()
          .then((value) {
        for (var i in value.children) {
          Map<dynamic, dynamic>? data =
              Map<dynamic, dynamic>.from(value.value as Map<dynamic, dynamic>);
          res.add(Message.fromMap(i.key, data));
        }
      });
      return res;
    } catch (e) {
      throw ("getByIdConversation Message failed: $e ");
    }
  }

  static Future<Message> getByIdConversationAndUserId(
      String idConversation, String messageId) async {
    try {
      var res = await _db
          .ref("/conversations/$idConversation/messages/$messageId")
          .get();
      Map<dynamic, dynamic>? data =
          Map<dynamic, dynamic>.from(res.value as Map<dynamic, dynamic>);
      return Message.fromMap(res.key, data);
    } catch (e) {
      throw ("getByIdConversationAndMessageId Message failed: $e ");
    }
  }

  static Future delete(String idConversation, String messageId) async {
    try {
      await _db
          .ref("/conversations/$idConversation/messages/$messageId")
          .remove();
    } catch (e) {
      throw ("delete Message failed: $e ");
    }
  }

  static Stream<Message> listenAddMessage(String conversationId) {
    StreamController<Message> controller = StreamController<Message>();
    try {
      _db
          .ref("/conversations/$conversationId/messages")
          .onChildAdded
          .listen((event) {
        var snapshot = event.snapshot;
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>;
        Message message = Message.fromMap(snapshot.key, data);
        controller.add(message);
      });
    } catch (e) {
      controller.addError(("Listening for conversation messages failed: $e"));
    }
    return controller.stream;
  }
}
