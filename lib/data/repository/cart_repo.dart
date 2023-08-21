
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy/utils/app_constants.dart';

import '../../Model/CartModel.dart';

class CartRepo extends GetxService{
  late  SharedPreferences sharedPreferences;

  CartRepo({required this.sharedPreferences});

  List<String> cartStorageList = [];
  List<String> cartHistoryStorageList = [];

  Future<void> addToCartStorage(List<CartModel> cartData) async{
    await clearCartStorageData();

    String time = DateTime.now().toString();

    for (var element in cartData) {
      element.time = time;
      cartStorageList.add(jsonEncode(element.toJson()));
    }
    print(cartStorageList);
    cartData.forEach((element) {print("${element.time!}, ${element.name!}"); });
    sharedPreferences.setStringList(AppConstants.CART_DATA, cartStorageList);
  }
  void addCartDataToHistory(){
    print("cartstorage :\n $cartStorageList");
    for (var element in cartStorageList) {
      cartHistoryStorageList.add(element);
    }
     sharedPreferences.setStringList(AppConstants.CART_HISTORY_DATA, cartHistoryStorageList);
     clearCartStorageData();
  }


  List<CartModel> getCartStorageData(){
    List<String> encodedData  = [];

    if(sharedPreferences.containsKey(AppConstants.CART_DATA))
    {
      encodedData = sharedPreferences.getStringList(AppConstants.CART_DATA)!;

      List<CartModel> decodedData = [];
      for (var element in encodedData) {
        decodedData.add(CartModel.fromJson(jsonDecode(element)));
      }
      return decodedData;
    }
    return [];
  }

  List<CartModel> getCartHistoryData() {
    List<String> encodedData  = [];
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_DATA)){
      encodedData =  sharedPreferences.getStringList(AppConstants.CART_HISTORY_DATA)!;

      List<CartModel> decodedData = [];
      for (var element in encodedData) {
        decodedData.add(CartModel.fromJson(jsonDecode(element)));
      }
      return decodedData;
    }

    return [];
  }


  void clearCartHistory() async{
    await sharedPreferences.remove(AppConstants.CART_HISTORY_DATA);
    cartHistoryStorageList.clear();
  }

  Future<void> clearCartStorageData() async {
    cartStorageList.clear();
    await sharedPreferences.remove(AppConstants.CART_DATA);

  }

}