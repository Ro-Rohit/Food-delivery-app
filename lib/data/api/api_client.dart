import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient extends GetConnect implements GetxService{
  late String token;
  late Map<String, String> _mainHeader;
  late String appBaseUrl;

  ApiClient({required this.appBaseUrl}){
    token = dotenv.env["TOKEN"] ?? "token_not_found";
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 40);
    _mainHeader = {
      'Content-Type':'application/json',
      'Accept': 'application/json',
      'Authorization' : 'Bearer $token',
    };
  }

  Future<Response> getData(String url) async{
    try{
       Response res = await get(url, headers: _mainHeader,);
       return res;
    }catch(e)
    {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}