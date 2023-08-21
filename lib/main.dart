import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yummy/Routes/app_routes.dart';
import 'package:yummy/data/controller/cart_controller.dart';
import 'package:yummy/data/controller/popular_product_controller.dart';
import 'data/controller/recommended_product_controller.dart';
import 'helpers/dependency.dart' as dep;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:yummy/Notification/cloud_messaging.dart';
import 'package:yummy/Notification/local_notification.dart';


Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FireMessage.getToken();
  FireMessage.onBackgroundMessage(backgroundHandler);
  await dotenv.load();
  await  dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalNotificationService.initialize(context);
    Get.find<CartController>().setStorageData();
    return GetBuilder<PopularProductController>(builder: (popularProductController){
      return GetBuilder<RecommendedProductController>(builder: (recommendedProductController){
        return GetBuilder<CartController>(builder: (cartController){
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.getSplashPage(),
            getPages: AppRoutes.routes,
          );
        });
      });
    });
  }
}


