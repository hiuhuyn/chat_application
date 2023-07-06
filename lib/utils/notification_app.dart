import 'package:chat_application/utils/appColors.dart';
import 'package:flutter/material.dart';

class NotificationApp {
  static notificationBase(
      {required BuildContext context,
      required String message,
      required String title,
      Color titleColor = Colors.black}) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.3,
              horizontal: MediaQuery.of(context).size.width * 0.2),
          decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 10,
                    color: AppColors.grey8D8D8D,
                    offset: Offset(2, 2))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      color: titleColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                height: 2,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.blue4285F4)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Ok",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static loading() {}
}
