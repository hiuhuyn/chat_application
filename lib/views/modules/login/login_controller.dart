import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/utils/router/routesName.dart';
import 'package:chat_application/views/modules/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/notification_app.dart';

class LoginController {
  BuildContext context;
  LoginController(this.context);

  Future<void> signInWithEmailPassword() async {
    try {
      var state = context.read<LoginCubit>().state;
      if (state.email.isEmpty) {
        throw ("Please enter your email");
      }
      if (state.password.isEmpty) {
        throw ("Please enter your password");
      }

      await Auth.signInWithEmailAndPassword(
              email: state.email, password: state.password)
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.HOMEPAGE, (route) => false);
      });
    } catch (e) {
      NotificationApp.notificationBase(
          context: context,
          message: e.toString(),
          title: "Error sign in",
          titleColor: Colors.red);
    }
  }
}
