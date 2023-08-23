import 'package:flutter/material.dart';
import 'package:yummy/Notification/local_notification.dart';
import 'package:yummy/Screen/AuthPage/email_verification.dart';
import 'package:yummy/Screen/home/HomePage.dart';
import 'package:yummy/utils/colors.dart';
import '../Notification/cloud_messaging.dart';

import '../data/controller/lock_controller.dart';
import '../data/controller/popular_product_controller.dart';
import '../data/controller/recommended_product_controller.dart';
import 'Account/account_page.dart';
import 'History/history_page.dart';
import './AuthPage/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';


class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {


  List<Widget> pages = [
    const HomePage(),
    const EmailVerificationPage(),
    const HistoryPage(),
    const AccountPage(),
  ];

  int pageIndex  = 0;
  void onTapNav(int index){
    setState(() {pageIndex = index;});
  }

  void handleMessage(RemoteMessage? message){
    if(message !=null) LocalNotificationService.displayNotification(message);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<LockController>().getCurrentUserLocation();
    FireMessage.requestForNotificationPermission();
     FireMessage.onForeGroundNotification(handleMessage);
     FireMessage.onBackGroundNotification(handleMessage);
     FireMessage.onTerminatedNotification(handleMessage);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        await Get.find<PopularProductController>().getPopularProductList();
        await Get.find<RecommendedProductController>().getRecommendedProductList();
      },
      child: Scaffold(
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          onTap: (int index){
            onTapNav(index);
          },
          unselectedFontSize: 0,
          selectedFontSize: 0,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: AppColors.yellowColor,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
          ],
        ),
      ),
    );
  }
}
