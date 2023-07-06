import 'package:chat_application/data/firebase/firebaseUser.dart';
import 'package:chat_application/utils/router/routesName.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_cubit.dart';
import 'package:chat_application/views/modules/chats/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'data/firebase/firebaseAuth.dart';
import 'firebase_options.dart';
import 'utils/router/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/modules/home/cubit/home_cubit.dart';
import 'views/modules/login/cubit/login_cubit.dart';
import 'views/modules/message/cubit/message_cubit.dart';
import 'views/modules/notification_add_friend/cubit/notification_friend_cubit.dart';
import 'views/modules/sign_up/cubit/sign_up_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Thực hiện các hành động trước khi ứng dụng bị thoát
      if (Auth.currentUser != null) {
        FbUser.updateOnline(Auth.currentUser!.uid, false);
      }
    }
    if (state == AppLifecycleState.resumed) {
      // Viết mã xử lý ở đây
      if (Auth.currentUser != null) {
        FbUser.updateOnline(Auth.currentUser!.uid, true);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LoginCubit(),
              ),
              BlocProvider(
                create: (context) => SignUpCubit(),
              ),
              BlocProvider(
                create: (context) => HomeCubit(),
              ),
              BlocProvider(
                create: (context) => ChatCubit(),
              ),
              BlocProvider(
                create: (context) => AllUserCubit(),
              ),
              BlocProvider(
                create: (context) => MessageCubit(),
              ),
              BlocProvider(
                create: (context) => NotificationFriendCubit(),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: RoutesName.DEFAULT,
              onGenerateRoute: Routes.genecateRouteSetting,
            ),
          );
        });
  }
}
