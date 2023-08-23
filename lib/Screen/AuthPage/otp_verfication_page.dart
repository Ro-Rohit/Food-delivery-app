import 'package:flutter/material.dart';
import 'package:yummy/widgets/app_textfield.dart';
import '../../utils/colors.dart';
import '../../Routes/app_routes.dart';
import 'package:get/get.dart';
import '../../utils/dimension.dart';
import '../../data/controller/auth_controller.dart';
import '../../widgets/Big_text.dart';
import '../../widgets/small_text.dart';

class OTPVerificationPage extends StatelessWidget {
  final String verificationId;
  const OTPVerificationPage({Key? key, required this.verificationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController  otpController  = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        body:GetBuilder<AuthController>(builder: (authController){
          bool isLoading = authController.isLoading;
          return  SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: Dimension.width20, vertical: Dimension.height20),
              child: SizedBox(
                height: Dimension.screenHeight,
                width: Dimension.screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: Dimension.height45 *2,),

                        Image.asset("images/yummy-ico.png", height: Dimension.height30 *5, width: Dimension.width30*5,),

                        SizedBox(height: Dimension.height10 ,),

                        Align(
                            alignment:Alignment.centerLeft,
                            child: BigText( text: 'SMS', size: Dimension.iconSize24*3, color: AppColors.mainBlackColor,)),

                        const Align(alignment:Alignment.centerLeft,
                            child: Padding(
                                padding:EdgeInsets.only(left: 10),
                                child: SmallText(text: 'Verification', size: 15, color: AppColors.mainBlackColor,))),

                        SizedBox(height: Dimension.height45 *1.5,),



                        //textField
                        AppTextField(
                            controller: otpController,
                            prefixIcon: Icons.password,
                            iconColor: AppColors.yellowColor,
                            hintText: " Enter SMS Code",
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.number),

                        SizedBox(height: Dimension.height10,),

                        //button
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  minimumSize: Size(Dimension.screenWidth-Dimension.width45*3, Dimension.height45)
                              ),
                              onPressed: isLoading ? null : (){
                                authController.verifyCodeAndSignIn(otpController.text.trim(), verificationId);
                              },
                              child: isLoading
                                  ? Transform.scale(
                                    scale: 0.6,
                                    child: const CircularProgressIndicator(color: Colors.white, ))
                                  : const Text("Verify")),
                        ),

                      ],
                    ),

                     Padding(
                       padding: const EdgeInsets.only(bottom: 30),
                       child: TextButton(
                          onPressed: (){
                            Get.offNamed(AppRoutes.getPhoneSignInPage());
                          },
                          child: const Text("Edit Phone Number?",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: AppColors.mainBlackColor, fontSize: 15),)),
                     ),
                  ],
                ),
              ),
            ),
          );
        })
    );
  }
}
