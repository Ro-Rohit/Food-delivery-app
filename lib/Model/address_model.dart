
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel{
  int? _id;
  String? _addressType;
  String? _contactPersonName;
  String? _contactPersonNumber;
  String?  _address;
  String?  _latitude;
  String?  _longitude;

 AddressModel({
   id,  addressType, contactPersonName,contactPersonNumber, address, latitude, longitude
 }){
  _id = id;
  _addressType = addressType;
  _contactPersonName = contactPersonName;
  _contactPersonNumber = contactPersonNumber;
  _address = address;
  _latitude = latitude;
  _longitude = longitude;
}


 String? get addressType => _addressType;
 String? get contactPersonName => _contactPersonName;
 String? get contactPersonNumber => _contactPersonNumber;
 String? get address=> _address;
 String? get latitude=> _latitude;
 String? get longitude=> _longitude;

 factory AddressModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  final data = snapshot.data();
  final addressData = data?["userAddress"];

  return AddressModel(
   id: addressData?['id'],
   addressType: addressData?['addressType'],
   address: addressData?['address'],
   contactPersonNumber: addressData?['contactPersonNumber'],
   contactPersonName: addressData?['contactPersonName'],
   longitude: addressData?['longitude'],
   latitude: addressData?['latitude'],
  );
 }


 Map<String, dynamic> toJson(){
  return
   {
    "id" : _id,
    "address" : _address,
    "addressType" : _addressType,
    "contactPersonName" : _contactPersonName,
    "contactPersonNumber": _contactPersonNumber,
    "longitude" : _longitude,
    "latitude" : _latitude,
   };

 }

}

//
// AddressModel.fromJson(Map<String, dynamic> json){
//
//  _id = json["id"];
//  _address = json["address"];
//  _addressType = json["addressType"] ?? "";
//  _contactPersonNumber = json["contactPersonNumber"] ?? "";
//  _contactPersonName = json["contactPersonName"] ?? "";
//  _longitude = json["longitude"];
//  _latitude = json["latitude"];
// }
