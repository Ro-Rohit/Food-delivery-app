import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/widgets/Big_text.dart';

void showCustomSnackBar(String message, {bool isError=true, String title="Error"}){
   Get.snackbar(title, message, 
       titleText : BigText(text: title, color: Colors.white,),
       messageText: Text(message, style: const TextStyle(color: Colors.white,),),
       backgroundColor: isError ?Colors.red : AppColors.mainColor,
       colorText: Colors.white,
       snackPosition: SnackPosition.TOP,
       duration: const Duration(milliseconds: 3000),
   );
}