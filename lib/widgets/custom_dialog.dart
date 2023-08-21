import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yummy/data/controller/auth_controller.dart';
import './app_textfield.dart';
import 'Big_text.dart';
import '../utils/colors.dart';


void showCustomDialog(
    BuildContext context, String title, Function fnc,
    TextEditingController controller, TextInputType textInputType, IconData prefixIcon){
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOutExpo.transform(a1.value);
      return Transform.scale(
          scale: curve,
          child: _dialog(context, title, fnc,  controller, textInputType, prefixIcon),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}


Widget _dialog(BuildContext context, String title, Function fnc,
    TextEditingController controller, TextInputType textInputType, IconData prefixIcon,) {
  return GetBuilder<AuthController>(builder: (authController){
    return AlertDialog(
      backgroundColor: Colors.white,
      title:  Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BigText(text:"Update $title", size:21, color: AppColors.mainColor, overflow: TextOverflow.ellipsis,),
          const SizedBox(width: 5,),
          authController.isLoading
              ? Transform.scale(
              scale: 0.5,
              child: const CircularProgressIndicator(color: AppColors.mainColor, value: 5,))
              : Container(),
        ],
      ),
      content: AppTextField(
        controller: controller,
        prefixIcon: prefixIcon,
        textInputType: textInputType,
        hintText: "New $title",
        iconColor: AppColors.mainColor,
        textInputAction: TextInputAction.done,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              controller.clear();
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.yellowColor, fontSize: 17),
            )),
        TextButton(
            onPressed: () {
              fnc();
            },
            child: const Text(
              "Okay",
              style: TextStyle(color: AppColors.mainColor, fontSize: 17),
            )),
      ],
    );
  });
}

