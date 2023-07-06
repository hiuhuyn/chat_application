import 'package:equatable/equatable.dart';
import 'package:chat_application/models/user.dart';

import '../../../../models/conversation.dart';

class MessageState extends Equatable {
  Conversation conversation;
  List<UserModel> users;
  MessageState({
    required this.conversation,
    this.users = const <UserModel>[],
  });
  @override
  // TODO: implement props
  List<Object?> get props => [conversation, users];

  MessageState copyWith({Conversation? conversation, List<UserModel>? users}) {
    return MessageState(
      conversation: conversation ?? this.conversation,
      users: users ?? this.users,
    );
  }
}

class MessageStateInit extends MessageState {
  MessageStateInit() : super(conversation: Conversation());
}

class MessageStateError extends MessageState {
  String error;
  MessageStateError({required super.conversation, required this.error});
}
