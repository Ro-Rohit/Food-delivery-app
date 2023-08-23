import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../Model/UserModel.dart';
import '../../widgets/custom_snackbar.dart';
import '../repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Routes/app_routes.dart';
import 'dart:io';

import '../repository/storage_repo.dart';

import 'lock_controller.dart';

class AuthController extends GetxController implements GetxService {
late AuthRepo authRepo;
late StorageRepo storageRepo;
AuthController({required this.authRepo, required this.storageRepo});

late UserModel _userData;
get userData => _userData;
bool _isLoading = false;
bool get isLoading => _isLoading;


void  navigateToScreen(){
  authRepo.listenChanges().listen((User? user) {
    if(user !=null && (user.emailVerified || user.phoneNumber!=null))
    {
      getUserDataFromFireStore();
      Get.find<LockController>().getUserAddress();
      Get.offNamed(AppRoutes.getBottomNavigationPage());
    }
    else if(user !=null && !user.emailVerified && user.phoneNumber==null){
      Get.offNamed(AppRoutes.getEmailVerifyPage());
    }
    else{
      Get.offNamed(AppRoutes.getRegistrationPage());
    }
  });
}


Future<void> createUser(String email, String password, String name,  String phone) async{
  try{
    _isLoading = true;
    update();
    final UserCredential userCredential = await authRepo.signUpWithEmailAndPassword(email, password);
    final User? user = userCredential.user;

    var userModel = UserModel(
        name: name,
        email: email,
        phone: phone,
        timeStamp:FieldValue.serverTimestamp().toString()
    );
    await storageRepo.saveUserDataToFireStore(userModel.toJson());
    _userData = userModel;

    await authRepo.verifyEmail();
  }
  on FirebaseException catch(error){
    showCustomSnackBar(error.code);
  }
  finally{
    _isLoading = false;
    update();
  }

}
Future<void> loginUser(String email, String password) async{
  try{

    _isLoading = true;
    update();

    final UserCredential userCredential = await authRepo.signInWithEmailAndPassword(email, password);
    final User? user = userCredential.user;
    user!.reload();

    await getUserDataFromFireStore();
  }
  on FirebaseException catch(error){
    showCustomSnackBar(error.code);
  }
  finally{
    _isLoading = false;
    update();
  }

}

Future<void> getUserDataFromFireStore() async{
  final  dataSnapshot  = await storageRepo.getUserDataFromFireStore();
  _userData = UserModel.fromFirestore(dataSnapshot as DocumentSnapshot<Map<String, dynamic>>);

}
Future<void> upLoadFile(File file) async{
  try{
    String imgUrl = await storageRepo.uploadFileToFireBase(file);
    await storageRepo.updateUserDataToFireStore({"img" : imgUrl});
    await getUserDataFromFireStore();
    update();
  }
  on FirebaseException catch (e){
    showCustomSnackBar(e.code);
  }
}
Future<void>signInWithGoogle() async {

  try {
    final AuthCredential? credential = await authRepo.googleSignIn();
    final UserCredential userCredential  = await authRepo.takeCredentialToFirebase(credential!);
    final User? user = userCredential.user;

    //save user info if its logged in first time otherwise no need
    await storageRepo.getUserDataFromFireStore().then((documentSnapshot) async {
      if(!documentSnapshot.exists){
        var userModel = UserModel(
            name: user!.displayName ?? "Your name",
            email: user.email,
            phone: user.phoneNumber ?? "phone number",
            userAddress: null,
            timeStamp:FieldValue.serverTimestamp().toString()
        );
        await storageRepo.saveUserDataToFireStore(userModel.toJson());
      }
    } );


  } on FirebaseAuthException catch (e) {
    showCustomSnackBar(e.code);
  }
}



// phone sign in
Future<void>sendCodeToPhone(String phoneNumber) async {
  try {
    _isLoading = true;
    update();
    await authRepo.sendOTP(phoneNumber);
    }
   on FirebaseAuthException catch (e) {
    showCustomSnackBar(e.code);
  }
  finally{
    _isLoading = false;
    update();
  }

}
Future<void>verifyCodeAndSignIn(String otp, String verificationId) async {
  try {
      _isLoading = true;
      update();

    PhoneAuthCredential credential = await authRepo.verifyOTP(otp, verificationId);
    UserCredential userCredential = await  authRepo.signInWithPhoneCredential(credential);
    User? user = userCredential.user;

    await storageRepo.getUserDataFromFireStore().then((documentSnapshot) async {
        if(!documentSnapshot.exists){
          var userModel = UserModel(
              name: user?.displayName ?? "Your name",
              email: user?.email ?? "Your email address" ,
              phone: user?.phoneNumber ?? "phone number",
              userAddress: null,
              timeStamp:FieldValue.serverTimestamp().toString()
          );
          await storageRepo.saveUserDataToFireStore(userModel.toJson());
        }
      } );
    }

   on FirebaseAuthException catch (e) {
    showCustomSnackBar(e.code);
  }
  finally{
    _isLoading = false;
    update();
  }
}



Future<void>resendEmailVerification() async{
  try{
    _isLoading = true;
    update();
    await authRepo.verifyEmail();
  } on FirebaseException catch(e){
    showCustomSnackBar(e.code);
  }
  finally{
    _isLoading = false;
    update();
  }
}


Future<void> updateName(String name) async{
  if(name.isNotEmpty)
  {
    try{
      _isLoading = true;
      update();
      await authRepo.updateName(name);
      await storageRepo.updateUserDataToFireStore({"name" : name});

    } on FirebaseException catch(e){
      showCustomSnackBar(e.code);
    } finally{
      _isLoading =false;
      update();
    }
  }else{
    showCustomSnackBar("Please enter a valid name");
  }
}
Future<void> updateEmail(String email) async{
  if(GetUtils.isEmail(email))
  {
    try{
      _isLoading =true;
      update();
      await authRepo.updateEmail(email);
      await storageRepo.updateUserDataToFireStore({"email" : email});
      await authRepo.updateCurrentUser();

    } on FirebaseException catch(e){
      showCustomSnackBar(e.code);
    } finally{
      _isLoading =false;
      update();
    }
  }else{
    showCustomSnackBar("Invalid email");
  }




}
Future<void> updatePhone(String phone) async{
  if(GetUtils.isPhoneNumber(phone))
  {
    try{
      _isLoading =true;
      update();
      await storageRepo.updateUserDataToFireStore({"phone" : phone});
      await getUserDataFromFireStore();
      update();

    } on FirebaseException catch(e){
      showCustomSnackBar(e.code);
    } finally{
      _isLoading =false;
      update();
    }
  }else{
    showCustomSnackBar("Invalid phone number");
  }




}



Future<void> signOut() async{
  try{
    await authRepo.signOut();

  } on FirebaseException catch(e){
    showCustomSnackBar(e.code);
  }


}
bool isUserExists() {
  if(FirebaseAuth.instance.currentUser ==null){
    return false;
  }
  return true;
}





}