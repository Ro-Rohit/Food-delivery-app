import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../widgets/custom_snackbar.dart';


class StorageRepo extends GetxService{
  late FirebaseFirestore fireStore;
  late FirebaseAuth auth;
  late FirebaseStorage firebaseStorage;

  StorageRepo({required this.fireStore, required this.auth, required this.firebaseStorage});

  // <------- cloud fireStore ----->


  Future<void>saveUserDataToFireStore( Map<String, dynamic>data) async{
    await fireStore.collection("users").doc(auth.currentUser!.uid).set(data, SetOptions(merge: true));
  }


  Future<void>updateUserDataToFireStore( Map<String, dynamic>data) async{
    await fireStore.collection("users").doc(auth.currentUser!.uid).update(data)
        .then((value) => showCustomSnackBar("Updated Successfully", isError: false, title: "Done"),
      onError: (e) => showCustomSnackBar(e),
    );
  }

  Future<DocumentSnapshot> getUserDataFromFireStore() async{
    final DocumentSnapshot snapshot =  await fireStore.collection("users").doc(auth.currentUser!.uid).get();
    return snapshot;

  }



  // <---- Firebase Storage --->

  Future<String> uploadFileToFireBase( File file) async{
    final userId = auth.currentUser!.uid;
    final Reference storageRef = firebaseStorage.ref().child("users/$userId");

    TaskSnapshot? snapshot = await storageRef.putFile(file);

    return snapshot.ref.getDownloadURL();
  }

  Future<String> getUserImgUrl() async{
    final userId = auth.currentUser!.uid;
    final Reference storageRef = firebaseStorage.ref().child("users/$userId");
    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }
}