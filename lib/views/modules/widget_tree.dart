import 'dart:async';

import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/utils/notification_app.dart';
import 'package:flutter/material.dart';

import '../../utils/router/routesName.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    if (Auth.currentUser == null) {
      Timer(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.LOGIN, (route) => false);
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.HOMEPAGE, (route) => false);
      });
    }

    return const Center(
        child: SizedBox(
            height: 50, width: 50, child: CircularProgressIndicator()));
  }
}
