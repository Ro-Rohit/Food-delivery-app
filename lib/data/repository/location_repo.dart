import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy/data/repository/storage_repo.dart';
import '../../utils/app_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class LocationRepo extends GetxService{
  late SharedPreferences sharedPreferences;

  LocationRepo({required this.sharedPreferences,});



  Future<Placemark> getAddressFromGeoCode(LatLng latLng)async{
    try{
      List<Placemark> placeMarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      return placeMarks.first;
    }catch(e){
      print(e);
      return Placemark();
    }
  }


   getUserAddress() {
    return sharedPreferences.get(AppConstants.USER_ADDRESS);
  }

  Future<Position?> getUserCurrentPosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled  = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled){
        Future.error("Service is not enabled");
      }

      permission  = await Geolocator.checkPermission();

      if(permission == LocationPermission.denied){
        permission  = await Geolocator.requestPermission();
        if(permission ==LocationPermission.denied){
          Future.error("User denied to access location");
          return null;
        }
      }

      if(permission == LocationPermission.deniedForever){
         Future.error("user denied forever");
         return null;
      }

       return await getUserLocation();
  }

  Future<Position> getUserLocation() async{
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
  }
}