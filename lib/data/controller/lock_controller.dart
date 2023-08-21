import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Model/address_model.dart';
import '../../widgets/custom_snackbar.dart';
import '../repository/location_repo.dart';
import '../repository/storage_repo.dart';

class LockController extends GetxController implements GetxService {
  late LocationRepo locationRepo;
  late StorageRepo storageRepo;
  LockController({required this.locationRepo, required this.storageRepo});

  bool _isLoading = false;
  final  bool _updateAddressData = true;
  final List<String> _addressTypeList = ["home", "office", "other"];
  List<String> get addressTypeList => _addressTypeList;

  int  _addressTypeNumber = 0;
  int get addressTypeNumber => _addressTypeNumber;

  late Position _userDefaultPosition;
  Position get userDefaultPosition => _userDefaultPosition;
  late Position _position;
  late Position _pickPosition;

  late GoogleMapController _mapController;

  Placemark _placemark = Placemark();
  Placemark get placemark =>  _placemark ;
  Placemark _pickPlacemark = Placemark();
  Placemark get pickPlacemark =>  _pickPlacemark ;
  AddressModel? _userAddressModel;
  AddressModel? get userAddressModel => _userAddressModel;


  void setMapController(GoogleMapController controller){
    _mapController = controller;
  }

  void setAddressTypeIndex(int index){
    _addressTypeNumber = index;
    update();
  }

  void getCurrentUserLocation()async{
    _userDefaultPosition = await locationRepo.getUserCurrentPosition()
        ?? Position(
            longitude: 82.321701,
            latitude: 20.948130,
            timestamp: DateTime.now(),
            accuracy: 1,
            altitude: 1,
            heading: 1,
            speed: 1,
            speedAccuracy: 1);
    print(_userDefaultPosition);
  }




  Future<void> updatePosition(CameraPosition cameraPosition, bool fromAddress) async{

    if(_updateAddressData){
      _isLoading = true;
      update();

      try{
        if(fromAddress) {
          _position = Position(
              longitude: cameraPosition.target.longitude, latitude: cameraPosition.target.latitude,
              timestamp: DateTime.now(), accuracy:1, heading: 1, speed: 1,
              speedAccuracy: 1, altitude: 0);
          _placemark = await getAddressFromGeoCode(
              LatLng(cameraPosition.target.latitude, cameraPosition.target.latitude,));

        }else{
          _pickPosition = Position(
              longitude: cameraPosition.target.longitude,
              latitude: cameraPosition.target.latitude,
              timestamp: DateTime.now(),
              accuracy:1, heading: 1, speed: 1, speedAccuracy: 1, altitude: 0);
          _pickPlacemark = await getAddressFromGeoCode(
              LatLng(cameraPosition.target.latitude, cameraPosition.target.latitude,));

        }
      }
      catch (e){showCustomSnackBar(e.toString());}
      finally{_isLoading = false; update();}
    }
  }

  Future<Placemark> getAddressFromGeoCode(LatLng latLng)async{
    Placemark placemark = await locationRepo.getAddressFromGeoCode(latLng);
    return placemark;
  }

  Future<void> saveUserAddress(
      String contactPersonName, String contactPersonNumber,
      double latitude, double longitude) async{

    AddressModel addressModel = AddressModel(
      addressType: _addressTypeList[_addressTypeNumber],
      contactPersonName: contactPersonName,
      contactPersonNumber: contactPersonNumber,
      latitude: latitude,
      longitude: _mapController,

    );
    _isLoading= true;
    update();
    try{
      await storageRepo.updateUserDataToFireStore({"userAddress" :addressModel.toJson()});
      showCustomSnackBar("updated successfully", isError: false, title: " User Address");
    }
    on FirebaseException catch(e){
      showCustomSnackBar(e.code);
    }
    finally{
      _isLoading = false;
      update();
    }

  }

  Future<void> getUserAddress() async{
    try{
      final documentSnapshot = await storageRepo.getUserDataFromFireStore();
      _userAddressModel = AddressModel.fromFirestore(
          documentSnapshot as DocumentSnapshot<Map<String, dynamic>> );
      print(_userAddressModel);
    } on FirebaseException catch(e){
      showCustomSnackBar("unable to fetch user address data");
    }

  }

















}