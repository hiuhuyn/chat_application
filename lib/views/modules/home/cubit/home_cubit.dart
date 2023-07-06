import 'package:chat_application/models/user.dart';
import 'package:chat_application/views/modules/home/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/firebase/firebaseAuth.dart';
import '../../../../data/firebase/firebaseUser.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());
  changePage(int index) {
    emit(state.copyWith(index: index));
  }

  loadingUser(String uid) async {
    try {
      UserModel? user = await FbUser.searchById(uid);
      if (user != null) {
        user.isOnline = true;
        await FbUser.updateOnline(user.id!, user.isOnline);
        emit(state.copyWith(user: user));
      }
    } catch (e) {
      print(e);
    }
  }
}
