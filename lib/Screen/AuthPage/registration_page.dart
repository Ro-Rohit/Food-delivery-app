import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yummy/widgets/Big_text.dart';
import '../../data/controller/auth_controller.dart';
import '../../utils/dimension.dart';
import '../../utils/colors.dart';
import '../../widgets/app_textfield.dart';
import '../../widgets/small_text.dart';
import '../../widgets/custom_snackbar.dart';
import '../../Routes/app_routes.dart';
import 'package:get/get.dart';
import '../../widgets/text_icon.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
  }

  void submitForm(){
    if(emailController.text.isEmpty || passController.text.isEmpty || nameController.text.isEmpty || phoneController.text.isEmpty){
      showCustomSnackBar("fields cannot be empty");
    }
    else if(!GetUtils.isEmail(emailController.text)){
      showCustomSnackBar("please enter a valid email");
    }
    else if(!GetUtils.isPhoneNumber(phoneController.text)){
      showCustomSnackBar("please enter a valid phone number");
    }
    else {
      Get.find<AuthController>()
          .createUser(
          emailController.text.trim(),
          passController.text.trim(),
          nameController.text.trim(),
          phoneController.text.trim(),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController){
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Dimension.height45 *2,),

              Align(
                alignment: Alignment.center,
                child: Image.asset("images/yummy-ico.png", height: Dimension.height30 *5, width: Dimension.width30*5,),
              ),

              SizedBox(height: Dimension.height20,),

              Form(
                  child: Column( children: [

                    //email
                    AppTextField(
                      controller: emailController,
                      prefixIcon: Icons.email,
                      iconColor: AppColors.yellowColor,
                      hintText: "Email Address",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                    ),

                    //password
                    AppTextField(
                      controller: passController,
                      prefixIcon: Icons.password,
                      iconColor: AppColors.mainColor,
                      hintText: "password",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.visiblePassword,
                      obscureText: true,
                      isSuffix: true,
                    ),

                    //name
                    AppTextField(
                      controller: nameController,
                      prefixIcon: Icons.person,
                      iconColor: AppColors.yellowColor,
                      hintText: "name",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.name,
                    ),

                    //phone
                    AppTextField(
                      controller: phoneController,
                      prefixIcon: Icons.phone,
                      iconColor: AppColors.mainColor,
                      hintText: "phone number",
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.phone,
                    ),

                    SizedBox(height: Dimension.height20,),

                    //btn
                    InkWell(
                      onTap: () {
                        submitForm();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimension.height20,
                            horizontal: Dimension.width20),
                        width: Dimension.screenWidth / 2.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimension.radius30),
                          color: AppColors.mainColor,
                        ),
                        child:  Center(
                            child: authController.isLoading
                                ? const  CircularProgressIndicator(color: Colors.white,)
                                : const SmallText(
                              text: "Sign up",
                              size: 20,
                              color: Colors.white,
                            )) ,
                      ),
                    ),
                  ],)
              ),

              SizedBox(height: Dimension.height10,),

              RichText(
                  text: TextSpan(
                      text: "Have an account?",
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 16),
                      children: [
                        TextSpan(
                            text: " login",
                            style: const TextStyle(
                                color: AppColors.mainBlackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.offNamed(AppRoutes.getLoginPage());
                              })
                      ])),

              SizedBox(height: Dimension.height20,),

              //text
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: Dimension.width10, vertical: Dimension.height10),
                child: const SmallText(text: "Sign up using one of the following methods", overflow: TextOverflow.ellipsis,),
              ),

              SizedBox(height: Dimension.height10/2,),


              //fang btn
              Wrap(
                  spacing: Dimension.width15,
                  children:[
                    GestureDetector(
                      onTap: (){
                        Get.find<AuthController>().signInWithGoogle();
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage("images/google-logo.png"),
                          radius: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("images/facebook-logo.png"),
                        radius: 25,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){},
                      child: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("images/twitter.png"),
                        radius: 25,
                      ),
                    ),
                  ]
              ),

            ],
          ),
        );
      })
    );
  }
}
