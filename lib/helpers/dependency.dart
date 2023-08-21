import 'package:get/get.dart';
import '../data/api/api_client.dart';
import '../data/controller/auth_controller.dart';
import '../data/controller/cart_controller.dart';
import '../data/controller/lock_controller.dart';
import '../data/controller/popular_product_controller.dart';
import '../data/controller/recommended_product_controller.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/cart_repo.dart';
import '../data/repository/popular_product_repo.dart';
import '../data/repository/recommended_product_repo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../data/repository/location_repo.dart';

import '../data/repository/storage_repo.dart';

Future init() async{
  final sharedPreference = await SharedPreferences.getInstance();
  final FirebaseFirestore  firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth  = FirebaseAuth.instance;
  final  FirebaseStorage  firebaseStorage = FirebaseStorage.instance;

  Get.lazyPut(()=>sharedPreference);

  Get.lazyPut(() => ApiClient(appBaseUrl: dotenv.env["BASE_URL"]!), fenix: true);

  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut(() => AuthRepo(
    auth: firebaseAuth,), fenix: true);
  Get.lazyPut(() => LocationRepo(sharedPreferences: Get.find()),  fenix: true);
  Get.lazyPut(() => StorageRepo(
      fireStore: firebaseFirestore,
      auth: firebaseAuth, firebaseStorage: firebaseStorage ),  fenix: true
  );

  //                    <--------CONTROLLERS ----->


  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()), fenix: true);
  Get.lazyPut(() => RecommendedProductController(recommendedProductRepo: Get.find()), fenix: true);
  Get.lazyPut(() => CartController(cartRepo: Get.find()), fenix: true,);
  Get.lazyPut(() => AuthController(authRepo: Get.find(), storageRepo: Get.find() ), fenix: true,);
  // Get.lazyPut(() => LocationController(locationRepo: Get.find(), storageRepo: Get.find()), fenix: true,);
  Get.lazyPut(() => LockController(locationRepo: Get.find(), storageRepo: Get.find()), fenix: true,);
}