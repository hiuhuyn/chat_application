// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class EditTextCustome extends StatefulWidget {
  Color? titleColor;
  String titleText;
  double fontSizeTitle = 16;

  Color? hintColor;
  String? hintText;
  double fontSizeHint = 14;

  TextEditingController? controller;
  FocusNode? focusNode;
  Function(String)? onChanged;
  double radius = 0;
  Widget? prefixIcon;

  bool isPassword;
  String? errorText;

  EditTextCustome(
      {Key? key,
      this.titleColor,
      required this.titleText,
      this.fontSizeTitle = 16,
      this.hintColor,
      this.hintText,
      this.fontSizeHint = 14,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.radius = 5,
      this.prefixIcon,
      this.isPassword = false,
      this.errorText})
      : super(key: key);

  @override
  State<EditTextCustome> createState() => _EditTextCustome();
}

class _EditTextCustome extends State<EditTextCustome> {
  bool obscureText = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isPassword) {
      setState(() {
        obscureText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.titleText,
          style: TextStyle(
              color: widget.titleColor ?? Colors.black,
              fontSize: widget.fontSizeTitle),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.radius)),
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              errorText: widget.errorText,
              suffixIcon: widget.isPassword == false
                  ? null
                  : InkWell(
                      onTap: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      overlayColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                      child: obscureText
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.visibility_outlined)),
              hintStyle: TextStyle(
                  color: widget.hintColor ?? Colors.grey,
                  fontSize: widget.fontSizeHint)),
        )
      ],
    );
  }
}
