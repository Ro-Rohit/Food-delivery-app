import 'package:firebase_messaging/firebase_messaging.dart';

class FireMessage{
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


  static Future<void> requestForNotificationPermission() async{

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User authorised");
    } else if(settings.authorizationStatus == AuthorizationStatus.denied){
      print("User denied");
    }else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      print("user provisioned");
    }else{
      print("user not determined");
    }

  }

 static Future<String?> getToken() async{
    try{
      String? token = await firebaseMessaging.getToken();
      print(token);
      return token;
    }catch(e){
      print(e);
    }
  }


  static void onBackgroundMessage(backgroundHandler){
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }




  // 1. This method call when app in terminated state and you get a notification
  // when you click on notification app open from terminated state and you can get notification data in this method
  static onTerminatedNotification (handleMessage){
    firebaseMessaging.getInitialMessage().then((message) => handleMessage(message));
  }



  // 2. This method only call when App in forground it mean app must be opened
  static onForeGroundNotification(handleMessage){
    FirebaseMessaging.onMessage.listen((RemoteMessage message)=> handleMessage(message));
  }


  static onBackGroundNotification(handleMessage){
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)=> handleMessage(message));
  }



}