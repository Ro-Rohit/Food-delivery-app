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
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:GetBuilder<AuthController>(builder: (authController){
        bool isLoading = authController.isLoading;
        return  Padding(
          padding:  EdgeInsets.symmetric(horizontal: Dimension.width20, vertical: Dimension.height20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimension.height45 *2,),

              Image.asset("images/yummy-ico.png", height: Dimension.height30 *5, width: Dimension.width30*5,),

              SizedBox(height: Dimension.height10 ,),

              Align(alignment: Alignment.centerLeft, child: BigText( text: 'Email', size: Dimension.iconSize24*3, color: AppColors.mainBlackColor,)),
              const Align( alignment: Alignment.centerLeft, child: Padding( padding: EdgeInsets.only(left: 10), child: SmallText(text: 'Verification', size: 15, color: AppColors.mainBlackColor,))),


              SizedBox(height: Dimension.height45 *2,),


              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      minimumSize: Size(Dimension.screenWidth -Dimension.width45*2, Dimension.height45)
                  ),
                  onPressed: isLoading ? null : (){
                    authController.resendEmailVerification();
                  },
                  child: const Text("Resent Email")),

               SizedBox(height: Dimension.height20 *1.3,),

              //message
               Text(isLoading? "" : "An Email has been sent into your account! ",
                  textAlign: TextAlign.center,
                  style: const  TextStyle(color: AppColors.textColor,),),

              const Spacer(),

              RichText(
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
                                Get.offNamed(AppRoutes.getRegistrationPage());
                              })
                      ])),
            ],
          ),
        );
      })
    );
  }
}
