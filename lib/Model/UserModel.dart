
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yummy/Model/address_model.dart';

class UserModel {
   String? name;
   String? email;
   String? phone;
   String? img;
   String? timeStamp;
   AddressModel? userAddress;


  UserModel({this.name, this.email, this.phone, this.timeStamp, this.img, this.userAddress});

   factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
     final data = snapshot.data();
     return UserModel(
       name: data?['name'],
       email: data?['email'],
       phone: data?['phone'],
       img: data?['img'],
       timeStamp: data?['timeStamp'],
       userAddress: AddressModel.fromFirestore(snapshot),
     );
   }

   Map<String, dynamic> toJson(){
    return
      {
        "name" : name,
        "email" : email,
        "phone" : phone,
        "img" : img,
        "timeStamp": timeStamp,
        "userAddress": userAddress,
      };

  }


}