import 'dart:convert';
import 'package:cybertech/pages/admin/adminHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as locPer;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/authentication.dart';
import 'constants/size.dart';
import 'pages/generalUser/generalUserHomePage.dart';
import 'widgets/alertDialog.dart';






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
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
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

  Future<Null> _setCredentials(String email,String pass) async {
    await this._Loginprefs.setString(useremail, email);
    await this._Loginprefs.setString(passwordd, pass);
     _loadCredentials();
  }



  @override
  void initState() {
  //  SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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

    super.initState();
  }
  Future<void> requestPermission(locPer.LocationPermissionLevel permissionLevel) async {
    final locPer.PermissionStatus permissionRequestResult = await locPer.LocationPermissions()
        .requestPermissions(permissionLevel: permissionLevel);

    setState(() {
      print("permissionRequestResult ${permissionRequestResult}");

    });
  }
  allowAccess() async{
    var status = await Permission.storage.status;
    var status2 = await Permission.locationAlways.status;
    var status3 = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    print("status2 $status2");
    print("status2.isGranted ${status2.isGranted}");
    print("status2.isDenied ${status2.isDenied}");
    print("status2.isRestricted ${status2.isRestricted}");

    if(status2.isDenied){
     // LocationPermissionLevel.locationAlways()
      final locPer.PermissionStatus permissionRequestResult = await locPer.LocationPermissions()
          .requestPermissions(permissionLevel: locPer.LocationPermissionLevel.locationAlways);

     // setState(() {
        print("permissionRequestResult ${permissionRequestResult}");
     // });
    }
/*     if(!status2.isGranted){
       await Permission.locationAlways.request();
    }
     else if(status2.isDenied){
       print("isDenied");
       await Permission.locationAlways.request();
     }
     else if(status2.isRestricted){
       print("RESTRICTED");
       await Permission.locationAlways.request();
     }*/
     /*if(status2.isGranted){
       Location().requestService();
     }*/
    // final PermissionHandler _permissionHandler = PermissionHandler();
    // var result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);
    // if(result[PermissionGroup.storage] == PermissionStatus.granted) {
    //   String dir = (await getApplicationDocumentsDirectory()).path;
    //   await Directory('$dir/images').create(recursive: true);
    // }

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
                image: AssetImage("assets/svg/drawer/sidemenuBg.jpg"),
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
                    SizedBox(height: _height * 0.15,),
                //    SvgPicture.asset("assets/images/qms.svg",height: 100,),
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
                                           AuthenticationHelper()
                                               .signIn(email1: username.text, password1: password.text)
                                               .then((result) {
                                             if (result == null) {
                                               print("UIS ${AuthenticationHelper().user}");
                                               _setCredentials(username.text, password.text);
                                               dbRef.child(AuthenticationHelper().user.uid).once().then((value){
                                                 print(value.value);
                                                 setState(() {
                                                   USERDETAIL=value.value;
                                                 });
                                                 if(USERDETAIL['UserGroupId']==1){
                                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
                                                 }
                                                 if(USERDETAIL['UserGroupId']==2){
                                                   FirebaseDatabase.instance.reference().child("TrackUsers").child(USERDETAIL['Uid']).set({
                                                     'lat':"null",
                                                     'long':"null",
                                                     'Name':USERDETAIL['Name']
                                                   });
                                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GeneralHomePage()));
                                                 }
                                               });


                                             } else {
                                               CustomAlert().showMessage(result,context);
                                             }
                                           });
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
                                                scrollPadding: EdgeInsets.only(bottom: 400),
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
                                                scrollPadding: EdgeInsets.only(bottom: 500),
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
                  ],
                ),
              ),
            ),

            isLoading?Container(
              height: _height,
              width: _width,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(yellowColor),),
                ),
              ),
            ):Container(width: 0,height: 0,)
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



}



//v-1.0.2



