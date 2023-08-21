import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yummy/data/controller/auth_controller.dart';
import '../../Routes/app_routes.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../widgets/Big_text.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/small_text.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late Timer? timer;
  bool isEmailVerified = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      await user.reload();
      setState(() { isEmailVerified = user.emailVerified;});
    }

    if (isEmailVerified) {
      showCustomSnackBar("email verified successfully", isError: false, title: "Email Verification");
      Get.offNamed(AppRoutes.bottomNavigationPage);
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:GetBuilder<AuthController>(builder: (authController){
        // Get.find<AuthController>().resendEmailVerification();
        return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: Dimension.height45 *2,),

              Align(
                alignment: Alignment.center,
                child: Image.asset("images/yummy-ico.png", height: Dimension.height30 *5, width: Dimension.width30*5,),
              ),

              SizedBox(height: Dimension.height10 ,),

              Container(
                alignment: Alignment.topLeft,
                width: Dimension.screenWidth,
                padding: EdgeInsets.symmetric(horizontal: Dimension.height15),
                child: Column(
                  children: [
                    BigText( text: 'Email', size: Dimension.iconSize24*3, color: AppColors.mainBlackColor,),
                    SmallText(text: 'Verification', size: 15, color: AppColors.mainBlackColor,)
                  ],
                ),
              ),

              SizedBox(height: Dimension.height45 *2,),

              const Align(
                alignment: Alignment.center,
                child: Text("An Email is sent into your account", style: TextStyle(color: AppColors.textColor),),
              ),

              SizedBox(height: 5,),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor
                    ),
                    onPressed: (){
                      authController.resendEmailVerification();
                    },
                    child: const Text("Resent Email")),
              ),

              SizedBox(height: Dimension.height30,),


              Align(
                alignment: Alignment.center,
                child:RichText(
                    text: TextSpan(
                        text: "Don't have an account?",
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 16),
                        children: [
                          TextSpan(
                              text: " Create",
                              style: const TextStyle(
                                  color: AppColors.mainBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(AppRoutes.getRegistrationPage());
                                })
                        ])),

              ),

            ],
          ),
        );
      })
    );
  }
}
