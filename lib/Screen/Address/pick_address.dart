import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import 'package:yummy/data/controller/lock_controller.dart';

class PickAddress extends StatefulWidget {
  const PickAddress({Key? key}) : super(key: key);

  @override
  State<PickAddress> createState() => _PickAddressState();
}

class _PickAddressState extends State<PickAddress> {
  TextEditingController addressController = TextEditingController();
  FocusNode addressNode  =  FocusNode();
  late CameraPosition cameraPosition;
  late LatLng _initialCameraPosition;
  bool isTextFieldEnabled = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Get.find<LockController>().userAddressModel?.latitude !=null &&
        Get.find<LockController>().userAddressModel?.longitude !=null
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
    return GetBuilder<LockController>(builder: (lockController){
      addressController.text = "${lockController.pickPlacemark.name ?? ""}"
          "${lockController.pickPlacemark.locality?? ""}"
          "${lockController.pickPlacemark.postalCode?? ""}"
          "${lockController.pickPlacemark.country??""}";

      if(lockController.userAddressModel !=null){
        addressController.text = lockController.userAddressModel!.address!;
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: cameraPosition,
                rotateGesturesEnabled: false,
                onMapCreated: (GoogleMapController mapController){
                  lockController.setMapController(mapController);
                },

                onCameraMove: (CameraPosition position){cameraPosition = position;},
                onCameraIdle: (){lockController.updatePosition(cameraPosition, false);},
              ),
            ),

            Positioned(
                height: 50,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimension.width10/2, vertical: Dimension.height10),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(Dimension.radius15),
                  ),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        controller: addressController,
                        focusNode: addressNode,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.streetAddress,
                        style: const TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          hintText: "Your street Address",
                          prefixIcon: Icon(Icons.pin_drop, color: AppColors.yellowColor,),
                        ),
                      ),

                    ],
                  ),

                ))

          ],
        ),
      );
    });
  }
}
