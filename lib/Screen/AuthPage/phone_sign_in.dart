import 'package:flutter/material.dart';
import 'package:yummy/widgets/app_textfield.dart';
import '../../utils/colors.dart';
import 'package:get/get.dart';
import '../../utils/dimension.dart';
import '../../data/controller/auth_controller.dart';
import '../../widgets/Big_text.dart';
import '../../widgets/small_text.dart';

class PhoneSignInPage extends StatelessWidget {
  const PhoneSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController  phoneController  = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        body:GetBuilder<AuthController>(builder: (authController){
          bool isLoading = authController.isLoading;
          return  SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: Dimension.width20, vertical: Dimension.height20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimension.height45 *2,),

                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("images/yummy-ico.png", height: Dimension.height30 *5, width: Dimension.width30*5,),
                  ),

                  SizedBox(height: Dimension.height10 ,),

                  BigText( text: 'Phone', size: Dimension.iconSize24*3, color: AppColors.mainBlackColor,),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child:  SmallText(text: 'Sign In', size: 15, color: AppColors.mainBlackColor,),
                  ),

                  SizedBox(height: Dimension.height30 *2,),


                  //textField
                  AppTextField(
                      controller: phoneController,
                      prefixIcon: Icons.password,
                      iconColor: AppColors.yellowColor,
                      hintText: "Your phone number",
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.phone),

                  SizedBox(height: Dimension.height10,),

                  //button
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            minimumSize: Size(Dimension.screenWidth - Dimension.width45*3, Dimension.height45),
                        ),
                        onPressed: isLoading ? null :  (){
                          authController.sendCodeToPhone(phoneController.text.trim());
                        },
                        child: isLoading
                            ? Transform.scale(
                              scale: 0.6,
                              child: const CircularProgressIndicator(color: Colors.white,))
                            : const Text("Send", style: TextStyle(fontWeight:FontWeight.w500, fontSize: 18),)),


                  ),

                  SizedBox(height: Dimension.height30,),
                ],
              ),
            ),
          );
        })
    );
  }
}
