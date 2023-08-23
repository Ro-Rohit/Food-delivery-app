import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:yummy/data/controller/auth_controller.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/utils/dimension.dart';
import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/app_textfield.dart';
import 'package:yummy/data/controller/lock_controller.dart';
import '../../Routes/app_routes.dart';
import '../../widgets/custom_snackbar.dart';


class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  TextEditingController addressController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController personNumberController = TextEditingController();
  late CameraPosition cameraPosition;
  late LatLng _initialCameraPosition;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addressController.dispose();
    personNameController.dispose();
    personNumberController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Get.find<LockController>().userAddressModel!.latitude !=null &&
        Get.find<LockController>().userAddressModel!.latitude !=null
    ){
      _initialCameraPosition = LatLng(
        double.parse(Get.find<LockController>().userAddressModel!.latitude!),
        double.parse(Get.find<LockController>().userAddressModel!.longitude!),
      );
    }else{
      _initialCameraPosition = LatLng(
        Get.find<LockController>().userDefaultPosition.latitude,
        Get.find<LockController>().userDefaultPosition.longitude,
      );
    }
    cameraPosition = CameraPosition(target:_initialCameraPosition,  zoom: 17);

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController){
       if(authController.userData !=null){
        personNameController.text = authController.userData.name?? "" ;
        personNumberController.text = authController.userData.phone ?? "";
      }

      return GetBuilder<LockController>(builder: (lockController){
        addressController.text = "${lockController.placemark.name ?? ""}"
            "${lockController.placemark.locality?? ""}"
            "${lockController.placemark.postalCode?? ""}"
            "${lockController.placemark.country??""}";

        if(lockController.userAddressModel?.address !=null  && authController.userData!=null){
          addressController.text = lockController.userAddressModel!.address!;
          personNameController.text = lockController.userAddressModel!.contactPersonName ?? "";
          personNumberController.text = lockController.userAddressModel!.contactPersonNumber?? "";
        }


        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.mainColor,
            title: const Text("Address Page"),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //map
                Container(
                  height: 140,
                  width: Dimension.screenWidth,
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.mainColor, width: 2),
                  ),
                  child: Stack(
                    children: [
                      GoogleMap(
                        onTap:(LatLng latLng){Get.toNamed(AppRoutes.getPickAddressPage());},
                        initialCameraPosition: cameraPosition,
                        zoomControlsEnabled: false,
                        rotateGesturesEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        indoorViewEnabled: false,
                        onCameraIdle: (){
                          lockController.updatePosition(cameraPosition, true);
                        },
                        onCameraMove: (position){cameraPosition = position;},
                        onMapCreated: (GoogleMapController controller){
                          lockController.setMapController(controller);
                        },
                      )
                    ],
                  ),
                ),


                //addressType
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lockController.addressTypeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          lockController.setAddressTypeIndex(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal: Dimension.width20, vertical: Dimension.height20),
                         decoration: BoxDecoration(
                           color: Theme.of(context).cardColor,
                           borderRadius: BorderRadius.circular(Dimension.radius15/2),
                           boxShadow: [
                             BoxShadow(
                               color: Theme.of(context).shadowColor.withOpacity(0.3),
                               blurRadius: 1,
                               offset: Offset(0,2),
                             )
                           ]
                         ),
                          child: Center(
                            child: Icon(
                              index==0? Icons.home_filled : index==1? Icons.work: Icons.location_on,
                              color: lockController.addressTypeNumber==index ? AppColors.mainColor : Theme.of(context).disabledColor,),
                          ),
                        )
                      );
                    },),
                ),


                //text
                SizedBox(height: Dimension.height30,),
                Padding(
                  padding: EdgeInsets.only(left: Dimension.width20),
                  child: const BigText(text: "Delivery Address"),
                ),

                //address
                SizedBox(height: Dimension.height10,),
                AppTextField(
                    controller: addressController,
                    prefixIcon: Icons.pin_drop,
                    iconColor: AppColors.yellowColor,
                    hintText: "Your address",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.name),



                //text
                SizedBox(height: Dimension.height30,),
                Padding(
                  padding: EdgeInsets.only(left: Dimension.width20),
                  child: const BigText(text: "Contact Name"),
                ),

                //name
                SizedBox(height: Dimension.height10,),
                AppTextField(
                    controller: personNameController,
                    prefixIcon: Icons.person,
                    iconColor: AppColors.yellowColor,
                    hintText: "Your Name",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.name),


                //text
                SizedBox(height: Dimension.height30,),
                Padding(
                  padding: EdgeInsets.only(left: Dimension.width20),
                  child: const BigText(text: "Contact Number"),
                ),

                //number
                SizedBox(height: Dimension.height10,),
                AppTextField(
                    controller: personNumberController,
                    prefixIcon: Icons.phone,
                    iconColor: AppColors.yellowColor,
                    hintText: "Your Phone number",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.name),

              ],
            ),
          ),
          bottomNavigationBar: GetBuilder<LockController>(builder: (lockController){
            return  Container(
              alignment: Alignment.center,
              height: Dimension.bottomHeight120,
              padding: EdgeInsets.symmetric(horizontal: Dimension.width20, vertical: Dimension.height30),
              decoration: BoxDecoration(
                color: AppColors.buttonBgColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimension.radius20 *2),
                  topLeft: Radius.circular(Dimension.radius20 *2),
                ),
              ),
              child: InkWell(
                onTap: (){
                  if(personNumberController.text.isEmpty){
                    showCustomSnackBar("Contant number cannot be empty");
                  }else if(personNameController.text.isEmpty){
                    showCustomSnackBar("Person name cannot be empty");
                  }else{
                    lockController.saveUserAddress(
                        personNameController.text,
                        personNumberController.text,
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude,
                    );
                    Get.back();
                  }

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimension.radius15),
                    color: AppColors.mainColor,
                  ),
                  child:  const Center(
                      child: BigText(text: "Save Address", size: 15, color: Colors.white,)),
                ),
              ),
            );

          }),
        );
      });
    });
  }
}
