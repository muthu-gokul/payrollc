import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart' as locSettings ;
import 'package:cybertech/main.dart';
import 'package:cybertech/notifier/mySharedPref.dart';
import 'package:cybertech/pages/admin/adminHomePage.dart';
import 'package:cybertech/pages/generalUser/attendance/location_callback_handler.dart';
import 'package:cybertech/pages/generalUser/attendance/location_service_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as locPer;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/authentication.dart';
import 'constants/size.dart';
import 'notifier/timeNotifier.dart';
import 'pages/generalUser/generalUserHomePage.dart';
import 'widgets/alertDialog.dart';
import 'widgets/loader.dart';

import 'package:location_permissions/location_permissions.dart' as locPerm;





class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  TextEditingController jfdgj=new TextEditingController();

  late bool passwordvisible;
  late bool loginvalidation;
  late AnimationController shakecontroller;
  late Animation<double> offsetAnimation;
  bool isLoading=false;
  bool isVisible=false;
  bool isEmailInvalid=false;
  bool ispasswordInvalid=false;
  bool _keyboardVisible = false;

  bool passwordGlow=false;
  bool emailGlow=false;


  late SharedPreferences _Loginprefs;
  static const String useremail = 'email';
  static const String passwordd = 'password';
  static const String Uid = 'Uid';

  AuthenticationHelper authenticationHelper=new AuthenticationHelper();

  void _loadCredentials() {

    setState(() {
     // AuthenticationHelper().pref_Email;
      prefEmail = this._Loginprefs.getString(useremail) ?? "";
      prefPassword= this._Loginprefs.getString(passwordd) ?? "";
    });

    if(prefEmail.isNotEmpty && prefPassword.isNotEmpty){
      setState(() {
        username.text=prefEmail;
        password.text=prefPassword;
      });
    }
  }

  Future<Null> _setCredentials(String email,String pass,String uid) async {
    await this._Loginprefs.setString(useremail, email);
    await this._Loginprefs.setString(passwordd, pass);
    print("SHARED UID $uid");
  // await MySharedPreferences.setStringValue(Uid, uid);
    await this._Loginprefs.setString(Uid, uid);
    sp.setString("Uid2", uid);
     _loadCredentials();
  }

initSp() async{
  sp = await SharedPreferences.getInstance();
}

  @override
  void initState() {
  //  SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  initSp();
    passwordvisible = true;
    loginvalidation=false;
    shakecontroller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    username.clear();
    password.clear();
    allowAccess();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._Loginprefs = prefs);
        _loadCredentials();
      });
    offsetAnimation = Tween(begin: 0.0, end: 28.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(shakecontroller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          shakecontroller.reverse().whenComplete(() {
            setState(() {
              loginvalidation=false;
            });
          });
        }
      });

    if (IsolateNameServer.lookupPortByName(LocationServiceRepository.isolateName) != null) {
      IsolateNameServer.removePortNameMapping(LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
          (dynamic data) async {
        await updateUI(data);
      },
    );
   // initPlatformState();

    super.initState();
  }
  Future<void> requestPermission(locPer.LocationPermissionLevel permissionLevel) async {
    final locPer.PermissionStatus permissionRequestResult = await locPer.LocationPermissions()
        .requestPermissions(permissionLevel: permissionLevel);

    setState(() {
      print("permissionRequestResult ${permissionRequestResult}");

    });
  }
  bool locAlways=false;
   locationDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => CupertinoAlertDialog(
          content: Text("Allow CyberTech to Access Device's Location All Time",style: TextStyle(fontSize: 18),),
          actions: [
            CupertinoDialogAction(
              child: Text("Open App Info"),
              onPressed: (){
                Navigator.pop(context);
                locPer.LocationPermissions().openAppSettings().then((bool hasOpened) =>
                    debugPrint('App Settings opened: ' + hasOpened.toString()));
              },
            ),
          ],
        )
    );
  }
  allowAccess() async{
    var status = await Permission.storage.status;
    var status2 = await Permission.locationAlways.status;
   // var status3 = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    print("status2 $status2");
    print("status2.isGranted ${status2.isGranted}");
    print("status2.isDenied ${status2.isDenied}");
    print("status2.isRestricted ${status2.isRestricted}");

    if(status2.isDenied || status2.isRestricted){
     // LocationPermissionLevel.locationAlways()
      locationDialog(context);
    //  final locPer.PermissionStatus permissionRequestResult = await locPer.LocationPermissions()
     //     .requestPermissions(permissionLevel: locPer.LocationPermissionLevel.locationAlways);

     // setState(() {
     //   print("permissionRequestResult ${permissionRequestResult}");
     // });
    }


  }


  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  @override
  Widget build(BuildContext context) {
   // SystemChrome.setEnabledSystemUIOverlays([]);
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final node=FocusScope.of(context);
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/loginBg.jpg"),
                fit: BoxFit.cover
            ),
          color: bgColor
        ),

        child: Stack(

          children: [
            Container(
              height: _height,
              width: _width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  /*  IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        LocationPermissions().openAppSettings().then((bool hasOpened) =>
                            debugPrint('App Settings opened: ' + hasOpened.toString()));
                      },
                    ),*/
                    SizedBox(height: _height * 0.19,),

                  //  SvgPicture.asset("assets/svg/logo.svg",height: 100,),
                    SizedBox(height: 20,),
                    Form(
                        key: _loginFormKey,
                        child: AnimatedBuilder(
                            animation: offsetAnimation,
                            builder: (context, child) {
                              return Container(

                                padding: EdgeInsets.only(left: offsetAnimation.value + 30.0,
                                    right: 30.0 - offsetAnimation.value),
                                child: Stack(
                                  children: [

                                    GestureDetector(
                                      onTap:() async {

                                         node.unfocus();
                                     /*    final locPer.PermissionStatus permissionRequestResult = await locPer.LocationPermissions()
                                             .requestPermissions(permissionLevel: locPer.LocationPermissionLevel.locationAlways);*/
                                         //requestPermission(locPer.LocationPermissionLevel.locationAlways);
                                         if(_loginFormKey.currentState!.validate() && !isEmailInvalid && !ispasswordInvalid){
                                           var status2 = await Permission.locationAlways.status;
                                           if(status2.isDenied || status2.isRestricted){
                                             locationDialog(context);
                                           }
                                           else{
                                             setState(() {
                                               isLoading=true;
                                             });
                                             AuthenticationHelper()
                                                 .signIn(email1: username.text, password1: password.text)
                                                 .then((result) {
                                               if (result == null) {
                                                 print("UIS ${AuthenticationHelper().user}");
                                                 _setCredentials(username.text, password.text,AuthenticationHelper().user.uid);
                                                 usersRef.child(AuthenticationHelper().user.uid).once().then((value){
                                                   print(value.value);
                                                   setState(() {
                                                     USERDETAIL=value.value;
                                                   });
                                                   if(USERDETAIL['UserGroupId']==1){
                                                     setState(() {
                                                       isLoading=false;
                                                     });
                                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
                                                   }
                                                   if(USERDETAIL['UserGroupId']==2){
                                                     initPlatformState();
                                                     FirebaseDatabase.instance.reference().child("TrackUsers").child(USERDETAIL['Uid']).set({
                                                       'lat':"null",
                                                       'long':"null",
                                                       'Name':USERDETAIL['Name']
                                                     });
                                                     setState(() {
                                                       isLoading=false;
                                                     });
                                                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GeneralHomePage()));
                                                   }
                                                 });


                                               }
                                               else {
                                                 setState(() {
                                                   isLoading=false;
                                                 });
                                                 CustomAlert().showMessage(result,context);
                                               }
                                             });
                                           }


                                         }
                                          },
                                      child: Container(
                                        height: 80,

                                        width: SizeConfig.screenWidth,
                                        alignment: Alignment.bottomCenter,
                                        margin: EdgeInsets.only(left: SizeConfig.width25!,right: SizeConfig.width25!,top: 280),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: yellowColor
                                        ),
                                        child: Padding(
                                          padding:  EdgeInsets.only(bottom: 15),
                                          child: Text("Login",style: TextStyle(fontSize: 20,fontFamily: 'RR',color: Colors.white),),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height: 310,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: gridBodyBgColor
                                      ),

                                      // margin: EdgeInsets.only(top: _height * 0.28),
                                      child: Column(

                                        children: [
                                          loginvalidation?Text("Invalid Email Or Password",style: TextStyle(color: Colors.red,fontSize: 16,fontFamily: 'RR'),):Container(height: 20,width: 0,),
                                          SizedBox(height: 10,),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: SizeConfig.width30!,),
                                                child: Text("User Email",style: TextStyle(fontSize: 16,fontFamily: 'RR',color: grey),),
                                              )),
                                          Container(
                                            height: 50,
                                            width: SizeConfig.screenWidth,
                                            margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 10,bottom: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                color: Colors.white,
                                                border: Border.all(color: emailGlow?grey.withOpacity(0.7):Colors.transparent),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:grey.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 0), // changes position of shadow
                                                  )
                                                ]
                                            ),
                                            child: Container(
                                              width: SizeConfig.screenWidth!*0.45,
                                              padding: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                onTap: (){
                                                  setState(() {
                                                    passwordGlow=false;
                                                    emailGlow=true;
                                                  });
                                                },
                                                controller: username,
                                                scrollPadding: EdgeInsets.only(bottom: 200),
                                                style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:grey,letterSpacing: 0.2),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    focusedErrorBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,

                                                ),

                                                keyboardType: TextInputType.emailAddress,

                                                validator:(value){


                                                  Pattern pattern =
                                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                  RegExp regex = new RegExp(pattern as String);
                                                  if (!regex.hasMatch(value!)) {
                                                    setState(() {
                                                      isEmailInvalid=true;
                                                    });
                                                    // return 'Email format is invalid';
                                                  } else {
                                                    setState(() {
                                                      isEmailInvalid=false;
                                                    });
                                                    // return null;
                                                  }
                                                },
                                                onEditingComplete: (){
                                                  node.nextFocus();
                                                  setState(() {
                                                    passwordGlow=true;
                                                    emailGlow=false;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),

                                          isEmailInvalid?Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!,),
                                              alignment: Alignment.centerLeft,
                                              child: Text("* Email format is Invalid",style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'RR'),textAlign: TextAlign.left,)
                                          ):Container(height: 0,width: 0,),

                                          SizedBox(height: 10,),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: SizeConfig.width30!,),
                                                child: Text("Password",style: TextStyle(fontSize: 16,fontFamily: 'RR',color: grey),),
                                              )),
                                          Container(
                                            height: 50,
                                            width: SizeConfig.screenWidth,
                                            margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 10,bottom: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(color:passwordGlow? yellowColor:Colors.transparent),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:passwordGlow?yellowColor.withOpacity(0.2):  grey.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 15,
                                                    offset: Offset(0, 0), // changes position of shadow
                                                  )
                                                ]
                                            ),
                                            child: Container(
                                              width: SizeConfig.screenWidth!*0.45,
                                              padding: EdgeInsets.only(left: 20),
                                              child: TextFormField(
                                                onTap: (){
                                                  setState(() {
                                                    emailGlow=false;
                                                    passwordGlow=true;
                                                  });
                                                },
                                                controller: password,
                                                obscureText: passwordvisible,
                                                obscuringCharacter: '*',
                                                scrollPadding: EdgeInsets.only(bottom: 200),
                                                style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:grey,letterSpacing: 0.2),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                    contentPadding: new EdgeInsets.only(top: 18),
                                                    suffixIconConstraints: BoxConstraints(
                                                        minHeight: 55,
                                                        maxWidth: 55
                                                    ),
                                                    suffixIcon: IconButton(icon: Icon(passwordvisible?Icons.visibility_off:Icons.visibility,size: 30,color: Colors.grey,),
                                                        onPressed: (){
                                                          setState(() {
                                                            passwordvisible=!passwordvisible;
                                                          });
                                                        })

                                                ),

                                                keyboardType: TextInputType.emailAddress,

                                                  validator:(value){
                                                    if(value!.isEmpty){
                                                      setState(() {
                                                        ispasswordInvalid=true;
                                                      });
                                                    }
                                                    else{
                                                      setState(() {
                                                        ispasswordInvalid=false;
                                                      });
                                                    }
                                                  },
                                                  onEditingComplete: () async {
                                                    node.unfocus();
                                                    setState(() {
                                                      passwordGlow=false;
                                                    });

                                                  }
                                              ),
                                            ),
                                          ),

                                          ispasswordInvalid?Container(
                                              margin: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!,),
                                              alignment: Alignment.centerLeft,
                                              child: Text("* Password is required",style: TextStyle(color: Colors.red,fontSize: 18,fontFamily: 'RR'),textAlign: TextAlign.left,)
                                          ):Container(height: 0,width: 0,),
                                          SizedBox(height: 20,),

                                          /*InkWell(
                                            onTap: (){
                                            },
                                            child: Text("Register",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: grey,decoration: TextDecoration.underline),),
                                          ),*/
                                         /* InkWell(
                                            onTap: (){

                                            },
                                            child: Text("Forgot Password",style: TextStyle(fontFamily: 'RR',fontSize: 16,color: grey,decoration: TextDecoration.underline),),
                                          ),*/
                                          SizedBox(height: 30,),


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                    ),
                    SizedBox(height: _height * 0.245,),
                    Text(
                      "@${DateFormat('yyyy').format(DateTime.now())}. All Rights Reserved. Designed by Cybertronics Pvt.Ltd",
                      style: TextStyle(fontFamily: 'RR',  color: Colors.white,fontSize: 12 ),

                    ),
                   // Spacer(),
                  ],
                ),
              ),
            ),
            Loader(
              isLoad: isLoading,
            )

          ],
        ),
      ),
    );
  }
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    return (!regex.hasMatch(value)) ? false : true;
  }


  late LocationDto lastLocation;
  ReceivePort port = ReceivePort();
  late bool isRunning;

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    //  logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    _onStart();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
  }
  Future<void> updateUI(LocationDto data) async {
    //  final log = await FileManager.readLogFile();

    await _updateNotificationText(data);

    //  setState(() {
    if (data != null) {
      lastLocation = data;
    }
    //   logStr = log;
    //  });
  }
  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: "new location received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }
  void _onStart() async {
    if (await _checkLocationPermission()) {
      await _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();

      //   setState(() {
      isRunning = _isRunning;

      // });
    } else {
      // show error
    }
  }
  void onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
  }
  Future<bool> _checkLocationPermission() async {
    final access = await locPerm.LocationPermissions().checkPermissionStatus();
    switch (access) {
      case locPerm.PermissionStatus.unknown:
      case locPerm.PermissionStatus.denied:
      case locPerm.PermissionStatus.restricted:
        final permission = await locPerm.LocationPermissions().requestPermissions(
          permissionLevel: locPerm.LocationPermissionLevel.locationAlways,
        );
        if (permission == locPerm.PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case locPerm.PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }
  Future<void> _startLocator() async{
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: locSettings.LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: locSettings.LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                'Turn on Location to track location.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                LocationCallbackHandler.notificationCallback)));
  }
}



//v-1.0.4



