import 'package:chat_application/data/firebase/firebaseAuth.dart';
import 'package:chat_application/utils/router/pageEntry.dart';
import 'package:chat_application/utils/router/routesName.dart';
import 'package:chat_application/views/modules/home/home_screen.dart';
import 'package:chat_application/views/modules/widget_tree.dart';
import 'package:flutter/material.dart';

import '../../views/modules/login/login_screen.dart';
import '../../views/modules/message/message_screen.dart';
import '../../views/modules/notification_add_friend/notification_friend_screen.dart';
import '../../views/modules/sign_up/sign_up_screen.dart';

class Routes {
  static List<PageEntry> listRoutes() {
    return [
      PageEntry(path: RoutesName.DEFAULT, page: const WidgetTree()),
      PageEntry(path: RoutesName.LOGIN, page: LoginScreen()),
      PageEntry(path: RoutesName.SIGNUP, page: SignUpScreen()),
      PageEntry(path: RoutesName.HOMEPAGE, page: const MyHomePage()),
      PageEntry(path: RoutesName.MEASSGE, page: MessageScreen()),
      PageEntry(
          path: RoutesName.NotificationFriend,
          page: const NotificationFriendScreen()),
    ];
  }

  static MaterialPageRoute genecateRouteSetting(RouteSettings settings) {
    if (settings.name != null) {
      var result =
          listRoutes().where((element) => element.path == settings.name);
      if (result.isNotEmpty) {
        print(result.first.path);
        return MaterialPageRoute(
            builder: (context) => result.first.page, settings: settings);
      }
    }
    return MaterialPageRoute(
      builder: (context) => Container(),
      settings: settings,
    );
  }
}
