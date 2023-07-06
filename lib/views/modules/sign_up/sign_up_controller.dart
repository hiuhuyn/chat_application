// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/utils/notification_app.dart';
import 'package:chat_application/views/modules/sign_up/cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpController {
  BuildContext context;
  SignUpController(
    this.context,
  );

  Future<void> signUpEvent() async {
    try {
      var state = context.read<SignUpCubit>().state;
      await Auth.createUserWithEmailAndPassword(
              state.email, state.password, state.displayName)
          .then((value) => Navigator.pop(context));
    } catch (e) {
      NotificationApp.notificationBase(
          context: context,
          message: e.toString(),
          title: "Lỗi tạo tài khoản",
          titleColor: Colors.red);
    }
  }
}
