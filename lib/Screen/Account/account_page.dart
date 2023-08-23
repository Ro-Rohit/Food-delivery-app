import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yummy/Model/UserModel.dart';
import 'package:yummy/data/controller/auth_controller.dart';
import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/custom_snackbar.dart';
import '../../Routes/app_routes.dart';
import '../../utils/dimension.dart';
import '../../utils/colors.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/app_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
   late File? pickedFile;
   bool isPicLoading = false;


   Future<void> _getImageFileFromDevice() async{
     FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
     if (result != null) {
       setState(() {
         isPicLoading = true;
         pickedFile = File(result.files.first.path!);
       });
     }
    }


  Future<void> _getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load("images/$path");
    Directory appDocDir = await getTemporaryDirectory();
    final file = File('${appDocDir.path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    setState(() {
      isPicLoading = true;
      pickedFile = file;});
   }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const BigText(text: "Profile", color: Colors.white,),
        backgroundColor: AppColors.mainColor,
        elevation: 5,
      ),

      backgroundColor: AppColors.buttonBgColor,

      body: GetBuilder<AuthController>(builder: (controller){
        UserModel user = controller.userData;
        final FirebaseAuth auth = FirebaseAuth.instance;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Dimension.height45 *1.5,),

               Stack(
                 clipBehavior: Clip.none,
                children: [

                   Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: AppColors.mainColor,
                        backgroundImage:  user.img ==null
                            ? const AssetImage("images/profile-logo.png")
                            :NetworkImage(user.img!) as ImageProvider),
                  ),

                  Positioned(
                      left: Dimension.screenWidth/1.75,
                      top: Dimension.height45*2.9,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.mainColor,
                        ),
                        child: isPicLoading
                            ? Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator(color: Colors.white,))
                            : IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              optionForProfilePic(
                                      () async {
                                    Navigator.pop(context);
                                    await _getImageFileFromDevice();

                                    if (pickedFile != null) await controller.upLoadFile(File(pickedFile!.path!));
                                    setState(() {isPicLoading = false;});
                                  },


                                      () async {
                                    Navigator.pop(context);
                                    await _getImageFileFromAssets("profile-logo.png");
                                    if (pickedFile != null) await controller.upLoadFile(pickedFile!);
                                    setState(() {isPicLoading = false;});
                                  });
                            },
                            icon: Icon(Icons.camera_alt, color: Colors.white, size: Dimension.iconSize24,))
                      )
                  ),
                ],
              ),

              SizedBox(height: Dimension.height30,),

               Column( children: [
                //name
                GestureDetector(
                  onTap: (){
                    showCustomDialog(
                      context, "Name",
                          () async{
                        await controller.updateName(nameController.text.trim());
                        nameController.clear();
                        Navigator.pop(context);
                      },
                      nameController, TextInputType.name, Icons.person,
                    );
                  },
                  child: AccountTile(
                      iconBgColor: AppColors.mainColor,
                      icon: Icons.person,
                      text:  auth.currentUser!.displayName ?? "Your name",
                  ),
                ),

                //phone
                GestureDetector(
                  onTap: (){

                    showCustomDialog(
                      context, "phone",
                          () async{
                        await controller.updatePhone(phoneController.text.trim());
                        phoneController.clear();
                        Navigator.pop(context);
                      },
                       phoneController, TextInputType.phone, Icons.person,
                    );

                  },
                  child: AccountTile(
                      iconBgColor: AppColors.yellowColor,
                      icon: Icons.phone,
                      text: auth.currentUser!.phoneNumber ?? "Your phone number"
                  ),
                ),



                //email
                GestureDetector(
                  onTap: (){

                    showCustomDialog(
                      context, "Email",
                          () async{
                        await controller.updateName(emailController.text.trim());
                        emailController.clear();
                        Navigator.pop(context);
                      },
                        emailController, TextInputType.emailAddress, Icons.email,
                    );

                  },
                  child: AccountTile(
                      iconBgColor: AppColors.mainColor,
                      icon: Icons.email,
                      text: auth.currentUser!.email ?? "email Address"
                  ),
                ),


                //address
                GestureDetector(
                  onTap: (){
                    if(controller.isUserExists()){
                      Get.toNamed(AppRoutes.getAddAddressPage());
                    }else{
                      showCustomSnackBar("Please Login first", title: "User sign in");
                    }
                  },
                  child: const AccountTile(
                      iconBgColor: AppColors.mainColor,
                      icon: Icons.pin_drop,
                      text: "Your Location"
                  ),
                ),

                //Login
                GestureDetector(
                  onTap: (){
                    if(controller.isUserExists()){
                      controller.signOut();
                    }else{
                      Get.toNamed(AppRoutes.getLoginPage());
                    }
                  },
                  child:  AccountTile(
                      iconBgColor: AppColors.yellowColor,
                      icon:  controller.isUserExists() ?  Icons.logout : Icons.login ,
                      text: controller.isUserExists() ? "Logout"  : "Login",
                  ),
                ),
              ],
              ),
            ],
          ),
        );
      })
    );
  }

  void optionForProfilePic(Function fnc1, Function func2){
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.mainColor.withOpacity(0.7),
        isScrollControlled: false,
        enableDrag: false,
        elevation: 5,
        builder: (context){
          return Container(
            height: 200,
            width: Dimension.screenWidth,
            padding: EdgeInsets.all(Dimension.height10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 5, top: 5),
                  child: Text("Profile Photo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white, letterSpacing: 2),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        AppIcon(
                            onTap: (){fnc1();},
                            icon: Icons.camera_alt,
                            fgColor: Colors.white,
                            bgColor: AppColors.yellowColor,
                            size: Dimension.iconSize24 *2),
                        const SizedBox(height: 2,),
                        const BigText(text: "Gallery", color: Colors.white,)

                      ],
                    ),
                    SizedBox(width: Dimension.width20 * 3,),
                    Column(
                      children: [
                        AppIcon(
                            onTap: (){func2();},
                            icon: Icons.person,
                            fgColor: Colors.white,
                            bgColor: AppColors.yellowColor,
                            size: Dimension.iconSize24 *2),
                        const SizedBox(height: 2,),
                        const BigText(text: "Remove", color: Colors.white,)
                      ],
                    ),
                  ],
                ),

              ],
            ),
          );
        });
  }
}

