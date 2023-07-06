import 'package:chat_application/utils/appColors.dart';
import 'package:chat_application/utils/router/routesName.dart';
import 'package:chat_application/views/modules/login/cubit/login_cubit.dart';
import 'package:chat_application/views/modules/login/cubit/login_state.dart';
import 'package:chat_application/views/modules/login/login_controller.dart';
import 'package:chat_application/views/witgets/edit_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../witgets/button_image.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  late LoginController controller;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller = LoginController(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  top: 40.h, bottom: 60.h, right: 20.w, left: 20.w),
              child: Center(
                child: SizedBox(
                  width: double.infinity > 700 ? 500 : double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      welcomeLess(context),
                      SizedBox(
                        height: 40.h,
                      ),
                      EditTextCustome(
                        titleText: "Enter your email address",
                        radius: 15,
                        hintText: "Email address",
                        controller: emailTextController,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      EditTextCustome(
                        titleText: "Enter your password",
                        radius: 15,
                        hintText: "Password",
                        isPassword: true,
                        controller: passTextController,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.h, bottom: 40.h),
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {},
                          overlayColor: const MaterialStatePropertyAll(
                              Colors.transparent),
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                                fontSize: 13, color: AppColors.blue4285F4),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                        width: double.infinity > 700 ? 500 : double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              context
                                  .read<LoginCubit>()
                                  .signInWithEmailPassword(
                                      emailTextController.text,
                                      passTextController.text);
                              await controller.signInWithEmailPassword();
                            },
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.whiteColor),
                            )),
                      ),
                      // SizedBox(
                      //   height: 30.h,
                      // ),
                      // ButtonImage(
                      //   onPressed: () {},
                      //   path: "images/google_icon.png",
                      //   borderRadius: BorderRadius.circular(30),
                      //   height: 40,
                      //   width: 40,
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget welcomeLess(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "Welcome to ",
                  style: TextStyle(fontSize: 16, color: AppColors.blackColor),
                ),
                Text(
                  "HERE",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue0089ED),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            const Text(
              "Sign in",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("No Account",
                style: TextStyle(fontSize: 13, color: AppColors.grey8D8D8D)),
            const SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.SIGNUP);
                },
                child: const Text(
                  "Sign up",
                  style: TextStyle(fontSize: 13, color: AppColors.blue0089ED),
                ))
          ],
        )
      ],
    );
  }
}
