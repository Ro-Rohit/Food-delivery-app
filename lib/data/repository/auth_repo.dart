import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/custom_snackbar.dart';

class AuthRepo extends GetxService{
  late FirebaseAuth auth;

  AuthRepo({required this.auth});

  Stream<User?> listenChanges(){return auth.authStateChanges();}

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password)async {
      final UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return credential;
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password)async {
    final UserCredential credential =
    await auth.signInWithEmailAndPassword(email: email, password: password);

    return credential;
  }

  Future<AuthCredential?> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
       return credential;
     }
  }

  Future<UserCredential> takeCredentialToFirebase(AuthCredential credential) async{
    UserCredential userCredential = await auth.signInWithCredential(credential);
    return userCredential;

  }


  Future<void> verifyEmail() async{
      showCustomSnackBar("An Email has been sent in your account", title: "Email Verification",
          isError: false);
      await  auth.currentUser!.sendEmailVerification();
  }


  Future<void> updateCurrentUser() async{
    auth.currentUser!.reload();
    print(auth.currentUser);
  }

  Future<void> updateEmail(String emailAddress) async{
    await auth.currentUser!.updateEmail(emailAddress);
  }

  Future<void> updateName(String name) async{
    await auth.currentUser!.updateDisplayName(name);
  }


  Future<void> signOut() async{
    await auth.signOut();
  }








}