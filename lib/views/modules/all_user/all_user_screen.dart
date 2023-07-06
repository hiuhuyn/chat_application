import 'package:chat_application/views/modules/all_user/all_user_controller.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_cubit.dart';
import 'package:chat_application/views/modules/all_user/cubit/all_user_state.dart';
import 'package:chat_application/views/witgets/item_user1.dart';
import 'package:chat_application/views/witgets/item_user2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  late final AllUserController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AllUserController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AllUserCubit, AllUserState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      label: const Icon(Icons.search),
                      hintText: "Search"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Bạn bè",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.blue,
                            offset: Offset(2, 2),
                            blurRadius: 5)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: ListView.builder(
                    itemCount: state.usersFriend.length,
                    itemBuilder: (context, index) => ItemUser2(
                      user: state.usersFriend[index],
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Những người bạn có thể biết",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2, 2),
                            blurRadius: 5)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: ListView.builder(
                    itemCount: state.usersOther.length,
                    itemBuilder: (context, index) => ItemUser1(
                      user: state.usersOther[index],
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
