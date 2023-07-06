import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../models/friend.dart';
import 'firebaseAuth.dart';

class FbFriend {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  static Future<String?> create(Friend data) async {
    try {
      var ref = _db.ref("/friends").push();
      await ref.set(data.toMap());
      return ref.key;
    } catch (e) {
      throw ("Add friend failed: $e");
    }
  }

  static Future updata(Friend data) async {
    try {
      await _db.ref("/friends/${data.id}").set(data.toMap());
    } catch (e) {
      throw ("updata friend failed: $e");
    }
  }

  static Future delete(String id) async {
    try {
      await _db.ref("/friends/$id").remove();
    } catch (e) {
      throw ("delete friend failed: $e");
    }
  }

  static Future<List<Friend>> getAll() async {
    try {
      User? user = Auth.currentUser;
      if (user == null) {
        throw ("User not found");
      }
      List<Friend> friendList = [];
      await _db.ref("/friends").get().then((snapshot) {
        if (snapshot.value != null) {
          Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>;
          data.forEach((key, value) {
            Map<dynamic, dynamic>? friendMap = value as Map<dynamic, dynamic>;
            Friend friend = Friend.fromMap(id: key.toString(), map: friendMap);
            if (friend.idUser1 == user.uid || friend.idUser2 == user.uid) {
              friendList.add(friend);
            }
          });
        }
      });
      return friendList;
    } catch (e) {
      throw ("Get friend failed: $e");
    }
  }

  static Stream<Friend> listenAddFriend() {
    StreamController<Friend> controller = StreamController();
    try {
      User? user = Auth.currentUser;
      if (user == null) {
        throw ("User not found");
      }
      _db.ref("/friends").onChildAdded.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>;
        Friend friend = Friend.fromMap(id: snapshot.key.toString(), map: data);
        if (friend.idUser1 == user.uid || friend.idUser2 == user.uid) {
          controller.add(friend);
        }
      });
    } catch (e) {
      controller.addError("Failed to load add friend: $e");
    }
    return controller.stream;
  }

  static Stream<Friend> listenChangedFriend() {
    StreamController<Friend> controller = StreamController();
    try {
      User? user = Auth.currentUser;
      if (user == null) {
        throw ("User not found");
      }
      _db.ref("/friends").onChildChanged.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>;
        Friend friend = Friend.fromMap(id: snapshot.key.toString(), map: data);
        if (friend.idUser1 == user.uid || friend.idUser2 == user.uid) {
          controller.add(friend);
        }
      });
    } catch (e) {
      controller.addError("Failed to load update friend: $e");
    }
    return controller.stream;
  }

  Stream<Friend> listenDeleteFriend() {
    StreamController<Friend> controller = StreamController();
    try {
      User? user = Auth.currentUser;
      if (user == null) {
        throw ("User not found");
      }
      _db.ref("/friends").onChildRemoved.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>;
        Friend friend = Friend.fromMap(id: snapshot.key.toString(), map: data);
        if (friend.idUser1 == user.uid || friend.idUser2 == user.uid) {
          controller.add(friend);
        }
      });
    } catch (e) {
      controller.addError("Failed to load delete friend: $e");
    }
    return controller.stream;
  }
}
