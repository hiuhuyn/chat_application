import 'package:chat_application/models/user.dart';
import 'package:chat_application/utils/appColors.dart';
import 'package:flutter/material.dart';

class ItemFriend1 extends StatefulWidget {
  ItemFriend1({super.key, required this.user, required this.onPressed});
  UserModel user;
  VoidCallback onPressed;

  @override
  State<ItemFriend1> createState() => _ItemFriend1State();
}

class _ItemFriend1State extends State<ItemFriend1> {
  @override
  Widget build(BuildContext context) {
    ImageProvider image = const AssetImage("assets/images/img2.png");
    if (widget.user.photoUrl != null) {
      // image = NetworkImage("");
    }

    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        height: 80,
        width: 65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            boxShadow: const [
              BoxShadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.blue)
            ]),
        padding: const EdgeInsets.symmetric(horizontal: 7),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    top: 0,
                    right: 0,
                    left: 0,
                    child: CircleAvatar(
                      backgroundImage: image,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.backgroudApp,
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                            color: widget.user.isOnline
                                ? Colors.green
                                : Colors.grey),
                      ))
                ],
              ),
            ),
            Text(
              widget.user.name!,
              maxLines: 1,
              style: const TextStyle(fontSize: 14, color: AppColors.grey8D8D8D),
            )
          ],
        ),
      ),
    );
  }
}
