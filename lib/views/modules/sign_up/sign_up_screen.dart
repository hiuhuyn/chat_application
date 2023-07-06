import 'package:chat_application/views/modules/sign_up/cubit/sign_up_cubit.dart';
import 'package:chat_application/views/modules/sign_up/cubit/sign_up_state.dart';
import 'package:chat_application/views/modules/sign_up/sign_up_controller.dart';
import 'package:chat_application/views/witgets/edit_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final SignUpController _controller = SignUpController(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<SignUpCubit, SignUpState>(builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Đăng ký",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Nhanh chóng và dễ dàng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 2,
                ),
              ),
              EditTextCustome(
                titleText: "Họ và tên",
                hintText: "Nguyễn Văn A",
                controller: _nameCtrl,
              ),
              const SizedBox(
                height: 20,
              ),
              EditTextCustome(
                titleText: "Email",
                hintText: "exem@gmail.com",
                controller: _emailCtrl,
              ),
              const SizedBox(
                height: 20,
              ),
              EditTextCustome(
                titleText: "Password",
                hintText: "password...",
                isPassword: true,
                controller: _passCtrl,
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      context.read<SignUpCubit>().signUpAccount(
                          email: _emailCtrl.text,
                          password: _passCtrl.text,
                          displayName: _nameCtrl.text);
                      await _controller.signUpEvent();
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 15, 146, 19))),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      child: const Text(
                        "Đăng ký",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )),
              )
            ],
          );
        }),
      ),
    );
  }
}
