import 'package:chat_application/utils/router/routesName.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_cubit.dart';
import 'package:chat_application/views/modules/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/firebase/firebaseAuth.dart';
import '../../../data/firebase/firebaseFriend.dart';
import '../../../data/firebase/firebaseUser.dart';
import '../../../models/user.dart';
import '../all_user/all_user_controller.dart';
import '../all_user/all_user_screen.dart';
import '../chats/chat_controller.dart';
import '../chats/chat_screen.dart';
import '../chats/cubit/chat_cubit.dart';
import '../notification_add_friend/cubit/notification_friend_cubit.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Auth.currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.LOGIN, (route) => false);
    } else {
      var chatController = ChatController(context);
      context.read<HomeCubit>().loadingUser(Auth.currentUser!.uid);
      chatController.firstLoadingData();
      AllUserController(context).getData();
      chatController.listenFriendUpdate();
      chatController.listenConversationUpdate();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) {
          context.read<HomeCubit>().changePage(value);
        },
        children: [
          ChatScreen(
            key: UniqueKey(),
          ),
          AllUserScreen(
            key: UniqueKey(),
          ),
          ProfileScreen(
            key: UniqueKey(),
          )
        ],
      ),
      bottomNavigationBar:
          BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.message_rounded), label: "Message"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_to_photos_rounded,
                ),
                label: "Add to friends"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "You"),
          ],
          onTap: (value) {
            _pageController.animateToPage(value,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear);
          },
          currentIndex: state.index,
        );
      }),
    ));
  }
}
