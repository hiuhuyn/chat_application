import 'package:flutter/material.dart';

import '../../../data/firebase/firebaseAuth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {
        Auth.signOut(context);
      },
      child: const Center(child: Text("Double Tap\nĐăng xuất!")),
    );
  }
}
