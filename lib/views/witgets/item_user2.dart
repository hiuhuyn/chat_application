import 'package:chat_application/models/user.dart';
import 'package:chat_application/views/modules/all_user/all_user_controller.dart';
import 'package:flutter/material.dart';

class ItemUser2 extends StatefulWidget {
  ItemUser2({super.key, required this.user, required this.onPressed});
  UserModel user;
  VoidCallback onPressed;

  @override
  State<ItemUser2> createState() => _ItemUser2State();
}

class _ItemUser2State extends State<ItemUser2> {
  ImageProvider image = const AssetImage("assets/images/img2.png");
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(blurRadius: 3, color: Colors.grey, offset: Offset(2, 2))
            ]),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 44,
              width: 44,
              child: CircleAvatar(
                backgroundImage: image,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${widget.user.name}",
              maxLines: 1,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
                onPressed: () async {
                  await AllUserController(context).unFriend(widget.user);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
