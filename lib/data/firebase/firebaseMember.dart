import 'dart:async';

import 'package:chat_application/models/member.dart';
import 'package:firebase_database/firebase_database.dart';

class FbMember {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  static Future create(String idConversation, Member data) async {
    try {
      await _db
          .ref("/conversations/$idConversation/members/${data.userId}")
          .set(data.submitAt);
    } catch (e) {
      throw ("Create member failed: $e ");
    }
  }

  static Future<List<Member>> getByIdConversation(String idConversation) async {
    List<Member> res = [];
    try {
      await _db
          .ref("/conversations/$idConversation/members")
          .get()
          .then((value) {
        for (var i in value.children) {
          res.add(Member(userId: i.key, submitAt: i.value as int?));
        }
      });
      return res;
    } catch (e) {
      throw ("getByIdConversation member failed: $e ");
    }
  }

  static Future<Member> getByIdConversationAndUserId(
      String idConversation, String userId) async {
    try {
      var res =
          await _db.ref("/conversations/$idConversation/members/$userId").get();

      return Member(userId: res.key, submitAt: res.value as int);
    } catch (e) {
      throw ("getByIdConversationAndUserId member failed: $e ");
    }
  }

  static Future delete(String idConversation, String userId) async {
    try {
      await _db.ref("/conversations/$idConversation/members/$userId").remove();
    } catch (e) {
      throw ("delete member failed: $e ");
    }
  }

  static Stream<Member> listenAddMember(String conversationId) {
    StreamController<Member> controller = StreamController<Member>();
    try {
      _db
          .ref("/conversations/$conversationId/members")
          .onChildAdded
          .listen((event) {
        var snapshot = event.snapshot;
        int? submitAt = snapshot.value as int?;
        Member member = Member(userId: snapshot.key, submitAt: submitAt);
        controller.add(member);
      });
    } catch (e) {
      controller.addError(("listenAddMember failed: $e"));
    }
    return controller.stream;
  }

  static Stream<Member> listenDeleteMember(String conversationId) {
    StreamController<Member> controller = StreamController<Member>();
    try {
      _db
          .ref("/conversations/$conversationId/members")
          .onChildRemoved
          .listen((event) {
        var snapshot = event.snapshot;
        int? submitAt = snapshot.value as int?;
        Member member = Member(userId: snapshot.key, submitAt: submitAt);
        controller.add(member);
      });
    } catch (e) {
      controller.addError(("listenDeleteMember failed: $e"));
    }
    return controller.stream;
  }
}
