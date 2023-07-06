// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../models/friend.dart';

class NotificationFriendState extends Equatable {
  List<Friend> allFriend = [];
  List<Friend> otherSend = [];
  List<Friend> youSend = [];

  NotificationFriendState(
      {required this.allFriend,
      required this.otherSend,
      required this.youSend});

  @override
  // TODO: implement props
  List<Object?> get props => [allFriend, otherSend, youSend];

  NotificationFriendState copyWith({
    List<Friend>? allFriend,
    List<Friend>? otherSend,
    List<Friend>? youSend,
  }) {
    return NotificationFriendState(
      allFriend: allFriend ?? this.allFriend,
      otherSend: otherSend ?? this.otherSend,
      youSend: youSend ?? this.youSend,
    );
  }
}

class NotificationFriendStateInti extends NotificationFriendState {
  NotificationFriendStateInti()
      : super(allFriend: [], otherSend: [], youSend: []);
}
