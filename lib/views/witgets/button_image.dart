// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ButtonImage extends StatelessWidget {
  VoidCallback onPressed;
  String path;
  double width;
  double height;
  BorderRadius? borderRadius;
  ButtonImage(
      {Key? key,
      required this.onPressed,
      required this.path,
      this.width = 50,
      this.height = 50,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        overlayColor:
            const MaterialStatePropertyAll(Color.fromARGB(83, 212, 231, 252)),
        child: Ink.image(
          image: AssetImage('assets/$path'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
