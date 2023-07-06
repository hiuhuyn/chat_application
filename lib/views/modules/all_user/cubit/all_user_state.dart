// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:chat_application/models/user.dart';

import '../../../../models/friend.dart';

class AllUserState extends Equatable {
  List<UserModel> usersOther;
  List<UserModel> usersFriend;
  List<UserModel> allUser;
  List<Friend> allFriend;

  AllUserState({
    this.usersOther = const <UserModel>[],
    this.usersFriend = const <UserModel>[],
    this.allUser = const <UserModel>[],
    this.allFriend = const <Friend>[],
  });
  @override
  // TODO: implement props
  List<Object?> get props => [usersOther, usersFriend, allFriend];

  AllUserState copyWith({
    List<UserModel>? usersOther,
    List<UserModel>? usersFriend,
    List<UserModel>? allUser,
    List<Friend>? allFriend,
  }) {
    return AllUserState(
      usersOther: usersOther ?? this.usersOther,
      usersFriend: usersFriend ?? this.usersFriend,
      allUser: allUser ?? this.allUser,
      allFriend: allFriend ?? this.allFriend,
    );
  }
}

class AllUserError extends AllUserState {
  String error;
  AllUserError({required this.error});
}
