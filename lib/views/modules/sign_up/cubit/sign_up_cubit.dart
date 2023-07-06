import 'package:chat_application/views/modules/sign_up/cubit/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpStateInit());

  signUpAccount(
      {required String email,
      required String password,
      required String displayName}) {
    emit(SignUpState(
        email: email, password: password, displayName: displayName));
  }
}
