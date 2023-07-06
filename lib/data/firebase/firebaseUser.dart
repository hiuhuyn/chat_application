import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FbUser {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  static Future create(UserModel data) async {
    try {
      var user = Auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        await _db.ref("/users/$uid").set(data.toMap());
      } else {
        throw ("User not found");
      }
    } catch (e) {
      throw ("Error creating user : $e");
    }
  }

  static Future update(UserModel data) async {
    try {
      await _db.ref("/users/${data.id}").set(data.toMap());
    } catch (e) {
      throw ("Error update user : $e");
    }
  }

  static Future updateOnline(String id, bool online) async {
    try {
      await _db.ref("/users/$id/isOnline").set(online);
    } catch (e) {
      throw ("Error update online user : $e");
    }
  }

  static Future delete(String id) async {
    try {
      await _db.ref("/users/$id").remove();
    } catch (e) {
      throw ("Error creating user : $e");
    }
  }

  static Future<UserModel?> searchById(String id) async {
    try {
      var res = await _db.ref("/users/$id").get();
      Map<dynamic, dynamic>? data = res.value as Map<dynamic, dynamic>;
      data["id"] = res.key;
      UserModel user = UserModel.fromMap(data);
      return user;
    } catch (e) {
      throw ("Error creating user : $e");
    }
  }

  static Future<List<UserModel>> getAll() async {
    List<UserModel> list = [];
    try {
      var res = await _db.ref("/users").get();
      Map<dynamic, dynamic>? data = res.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        Map<dynamic, dynamic>? data2 = value as Map<dynamic, dynamic>;
        data2["id"] = key;
        UserModel user = UserModel.fromMap(data2);
        if (user.id != Auth.currentUser!.uid) {
          list.add(user);
        }
      });
    } catch (e) {
      throw ("Error getAll user : $e");
    }
    return list;
  }
}
