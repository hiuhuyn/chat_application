import 'package:chat_application/views/modules/login/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  void signInWithEmailPassword(String email, String password) {
    emit(state.copyWith(email: email, password: password));
  }
}
