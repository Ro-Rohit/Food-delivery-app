import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yummy/data/controller/lock_controller.dart';
import '../../data/controller/auth_controller.dart';
import '../../data/controller/popular_product_controller.dart';
import '../../data/controller/recommended_product_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Routes/app_routes.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;

  Future<void> _loadResources() async{
    await Get.find<PopularProductController>().getPopularProductList();
    await  Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  void  navigateToScreen(){
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user !=null && user.emailVerified)
      {
        Get.find<AuthController>().getUserDataFromFireStore();
        Get.find<LockController>().getUserAddress();
        Get.offNamed(AppRoutes.getBottomNavigationPage());
      }
      else if(user !=null && !user.emailVerified){
        Get.offNamed(AppRoutes.getEmailVerifyPage());
      }
      else{
        Get.offNamed(AppRoutes.getLoginPage());
      }
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadResources();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
    scaleAnimation = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInExpo));

    slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutBack));

    controller.addListener(() {
      if(controller.isCompleted){
        Future.delayed(const Duration(seconds: 1), (){
          Get.find<AuthController>().navigateToScreen();
          });
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBgColor,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: Dimension.screenHeight/3,
              child: SlideTransition(
                  position: slideAnimation,
                  child: Image.asset("images/Yummy-logos.jpeg",))),

          //logo
          Positioned(
            left: 0,
            right: 0,
            top: Dimension.screenHeight/5,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Image.asset("images/yummy-ico.png",),
            ),
          ),
        ],
      ),
    );
  }
}
