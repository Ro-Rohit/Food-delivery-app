import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../Routes/app_routes.dart';
import '../../data/controller/auth_controller.dart';
import '../../utils/dimension.dart';
import '../../widgets/Big_text.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/small_text.dart';
import '../../utils/colors.dart';
import '../../widgets/app_textfield.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }


  void submitForm(){
    if(emailController.text.isEmpty || passController.text.isEmpty){
      showCustomSnackBar("fields cannot be empty");
    }
    else if(!GetUtils.isEmail(emailController.text)){
      showCustomSnackBar("please enter a valid email");
    }
    else {
      Get.find<AuthController>().loginUser(emailController.text.trim(), passController.text.trim());
      passController.clear();
      emailController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:GetBuilder<AuthController>(builder: (authController){
        return  SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Dimension.height45 *2,
              ),

              Align(
                alignment: Alignment.center,
                child: Image.asset("images/yummy-ico.png", height: Dimension.height30 *5, width: Dimension.width30*5,),
              ),

              SizedBox(
                height: Dimension.height20,
              ),

              Container(
                alignment: Alignment.topLeft,
                width: Dimension.screenWidth,
                padding: EdgeInsets.symmetric(horizontal: Dimension.height15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BigText( text: 'Hello', size: Dimension.iconSize24*3, color: AppColors.mainBlackColor,),
                    const SmallText(text: 'Sign into your account', size: 15, color: AppColors.mainBlackColor,)
                  ],
                ),
              ),

              SizedBox(
                height: Dimension.height20,
              ),

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
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      obscureText: true,
                      isSuffix: true,
                    ),

                    //text
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: Dimension.width20),
                        child: const SmallText(
                          text: "Forget Password?",
                          size: 13,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: Dimension.height30,
                    ),

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
                                ? const CircularProgressIndicator(color: Colors.white,)
                                : const SmallText(
                              text: "Sign in",
                              size: 20,
                              color: Colors.white,
                            )),
                      ),
                    ),

                    SizedBox(
                      height: Dimension.height30,
                    ),

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
                  )),
            ],
          ),
        );
      })
    );
  }
}
