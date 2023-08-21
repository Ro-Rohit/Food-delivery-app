import 'package:get/get.dart';
import 'package:yummy/Screen/AuthPage/login_page.dart';
import 'package:yummy/Screen/AuthPage/registration_page.dart';
import 'package:yummy/Screen/bottom_navigation_screen.dart';

import '../Screen/Account/account_page.dart';
import '../Screen/Address/add_address_page.dart';
import '../Screen/cart/cart_page.dart';
import '../Screen/food/popular_food_details.dart';
import '../Screen/home/HomePage.dart';
import '../Screen/recommended_food/recommended_food_detail.dart';
import '../Screen/splash screen/splash_screen.dart';
import '../Screen/AuthPage/email_verification.dart';
import '../Screen/Address/pick_address.dart';


class AppRoutes{
  static const String splashPage = '/splash-page';
  static const String initial = '/';
  static const String bottomNavigationPage = '/bottom-navigation-page';

  static const String registrationPage = '/registration-page';
  static const String loginPage = '/login-page';
  static const String emailVerifyPage = '/emailVerify-page';

  static const String accountPage = '/account-page';
  static const String addAddressPage = '/addAddress-page';
  static const String pickAddressPage = '/pickAddress-page';

  static const String popularFood = '/popular-food';
  static const String recommendedFood = '/recommended-food';
  static const String cartPage = '/cart-page';

  static String getSplashPage() => splashPage;
  static String getBottomNavigationPage() => bottomNavigationPage;
  static String getInitial() => initial;

  static String getRegistrationPage() => registrationPage;
  static String getLoginPage() => loginPage;
  static String getEmailVerifyPage() => emailVerifyPage;

  static String getAccountPage() => accountPage;
  static String getAddAddressPage() => addAddressPage;
  static String getPickAddressPage() => pickAddressPage;


  static String getCartPage() => cartPage;
  static String getPopularFood(int pageId) => '$popularFood?pageId=$pageId';
  static String getRecommendedFood(int pageId) => "$recommendedFood?pageId=$pageId";

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: ()=> const SplashScreen(),),

    GetPage(name: registrationPage, page: ()=> const RegistrationPage(), transition: Transition.fadeIn),
    GetPage(name: loginPage, page: ()=> const LoginPage(), transition: Transition.fadeIn),
    GetPage(name: emailVerifyPage, page: ()=> const EmailVerificationPage(), transition: Transition.fadeIn),

    GetPage(name: accountPage, page: ()=> const AccountPage(), transition: Transition.fadeIn),
    GetPage(name: addAddressPage, page: ()=> const AddAddressPage(), transition: Transition.fadeIn),
    GetPage(name: pickAddressPage, page: ()=> const PickAddress(), transition: Transition.fadeIn),



    GetPage(name: bottomNavigationPage, page: ()=> const BottomNavigationScreen()),
    GetPage(name: initial, page: ()=> const HomePage()),
    GetPage(name: cartPage, page: ()=> const CartPage()),


    GetPage(name: popularFood, page: (){
      var pageId = Get.parameters['pageId'];
      return  PopularFoodDetail(pageId: int.parse(pageId!),);
    }),

    GetPage(name: recommendedFood, page: (){
      var pageId = Get.parameters['pageId'];
      return  RecommendedFoodDetail(pageId: int.parse(pageId!));
    }),
  ];
}