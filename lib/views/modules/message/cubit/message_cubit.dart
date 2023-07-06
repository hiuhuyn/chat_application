import 'package:chat_application/models/conversation.dart';
import 'package:chat_application/views/modules/message/cubit/message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/user.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageStateInit());

  uploatData({
    required Conversation conversation,
    required List<UserModel> users,
  }) {
    emit(MessageState(conversation: conversation, users: users));
  }

  reloatData({Conversation? conversation, List<UserModel>? users}) {
    emit(state.copyWith(conversation: conversation, users: users));
  }

  resetData() {
    emit(MessageStateInit());
  }
}
