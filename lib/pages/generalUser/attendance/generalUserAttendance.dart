import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/notifier/timeNotifier.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loca;
import 'package:location_permissions/location_permissions.dart' as locPerm;
import 'package:provider/provider.dart';

import 'location_callback_handler.dart';
import 'location_service_repository.dart';



class GeneralUserAttendance extends StatefulWidget {
  VoidCallback drawerCallback;
  GeneralUserAttendance({required this.drawerCallback});
  @override
  _GeneralUserAttendanceState createState() => _GeneralUserAttendanceState();
}

class _GeneralUserAttendanceState extends State<GeneralUserAttendance> with WidgetsBindingObserver{
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  late  double width,height,width2;

/*  final Location location = Location();
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;*/

  final dbRef = FirebaseDatabase.instance.reference().child("Attendance");
  var first;
  final dbRef2=FirebaseDatabase.instance.reference().child("TrackUsers").child(USERDETAIL['Uid']);

  Map currentDayInfo={};
  getCurrentDayInfo(){
    dbRef.child(DateFormat(dbDateFormat).format(DateTime.now())).child(USERDETAIL['Uid']).onValue.listen((value){
      print("CDAY ${value.snapshot.value}");
      if(value.snapshot.value==null){
        setState(() {
          currentDayInfo={};
        });
      }
      else{
        setState(() {
          currentDayInfo=value.snapshot.value;
        });
      }
    });
  }

  @override
  void initState() {

/*    if (IsolateNameServer.lookupPortByName(LocationServiceRepository.isolateName) != null) {
      IsolateNameServer.removePortNameMapping(LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
          (dynamic data) async {
        await updateUI(data);
      },
    );*/
//    initPlatformState();
 //   Provider.of<LocationNotifier>(context,listen: false).listenLocation();
  //  _listenLocation();
    getCurrentDayInfo();

    super.initState();
  }
/*  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      print("PAUSED");
      if (!mounted) return;


    }
    if(state == AppLifecycleState.resumed){
      print("resumed");


    }
    if(state==AppLifecycleState.inactive){

      print("inactive");

      // if(selectedNotificationPayload==null){

      if (!mounted) return;


    }
    if(state==AppLifecycleState.detached){
      print("detached");
      if (!mounted) return;

    }
  }

  @override
  void didChangeDependencies() {
   // _listenLocation();
    super.didChangeDependencies();
  }*/

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
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
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

  @override

  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    width2=width-16;
    return SafeArea(
      child:Scaffold(
        backgroundColor: Color(0XFFEBEFF8),
        key: scaffoldkey,
        body: Container(
          child: Column(
            children: [
              Container(
                width: width,
                height: 70,
                color: Color(0xff4852FF),
                child: Row(
                  children: [
                    NavBarIcon(
                      ontap: (){
                        widget.drawerCallback();
                      },
                    ),
                    Container(
                      child: Text('   Attendance    ',style: TextStyle(color: Color(0xffffffff),fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'RR'),),
                    ),
                    Consumer<LocationNotifier>(
                        builder: (context,locNot,child)=> Container()
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                width: width,
                height: height-130,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                     /* Container(
                        child: Image.asset("assets/attendance/logo.jpg", width: 80,fit: BoxFit.cover,),
                      ) ,*/
                      SizedBox(height: 5.0,),

                      /*Container(
                         child: Text('${DateFormat.jms().format(DateTime.parse(currentDayInfo['LoginTime']))}',style: TextStyle(color: Color(0XFF000000),fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'RR'),),
                       ),*/

                      Container(
                        child: Text('Welcome ${USERDETAIL['Name']}',
                          style: TextStyle(color: Color(0XFF000000),fontSize: 20,fontFamily: 'RR'),
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        child: Text('${DateFormat.yMMMd().format(DateTime.now())}',
                          style: TextStyle(color: Color(0XFF000000),fontSize: 18,fontFamily: 'RR'),
                        ),
                      ),
                      SizedBox(height:5.0,),
                      Container(
                        width: width*0.27,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // boxShadow: [
                          //   BoxShadow(color: Colors.green, spreadRadius: 3),
                          // ],
                          color: Colors.indigoAccent,
                        ),
                        child:Center(
                            child: Consumer<TimeNotifier>(
                              builder: (context,timeNotifier,child)=> Text('${timeNotifier.timeInfo??"${DateFormat.jm().format(DateTime.parse(DateTime.now().toString()))}"}',
                                style: TextStyle(fontSize: 16,color: Color(0xffffffff),fontFamily:'RM',letterSpacing: 0.2),
                              ),
                            )
                        ) ,
                      ),
                      SizedBox(height: 25.0,),
                      Container(
                        height: 200,
                        width: 200,
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                        ),
                        child:USERDETAIL['imgUrl']==null? Image.asset("assets/images/profile.png" ,width: 200,fit: BoxFit.cover,):

                        CachedNetworkImage(
                          imageUrl: USERDETAIL['imgUrl'],
                          placeholder: (context,url) => CupertinoActivityIndicator(
                            radius: 20,
                            animating: true,

                          ),
                          errorWidget: (context,url,error) => new Icon(Icons.error),
                        ),


                       // Image.network(USERDETAIL['imgUrl'],fit: BoxFit.cover,loadingBuilder: (ctx,),),
                      ) ,
                      SizedBox(height: 25.0,),
                      Text(first==null?"":"${first.featureName} : ${first.addressLine}"),
                      currentDayInfo.isEmpty?Consumer<LocationNotifier>(
                        builder: (context,locNot,child)=>  GestureDetector(
                          onTap: () async {
                            _onStart();
                          //  getCurrentDayInfo();
                          //   _location=await location.getLocation();
                          //   final coordinates = new Coordinates(_location!.latitude, _location!.longitude);
                          //   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                          //   var first = addresses.first;
                          //   print("${first.featureName} : ${first.addressLine}");

                            if(locNot.isLocationServiceEnable && locNot.locationData!=null && locNot.first!=null){
                              dbRef.child("${DateFormat(dbDateFormat).format(DateTime.now())}").child(USERDETAIL['Uid']).set({
                                'Name':USERDETAIL['Name'],
                                'lat':locNot.locationData!.latitude,
                                'longi':locNot.locationData!.longitude,
                                'LoginTime':DateTime.now().toString(),
                                'LoginAddress':"${locNot.first.featureName} : ${locNot.first.addressLine}"

                              });
                            }



                          },
                          child: Container(
                            width: width*0.75,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: [
                              //   BoxShadow(color: Colors.green, spreadRadius: 3),
                              // ],
                              color: Colors.indigoAccent,
                            ),
                            child:Center(child: Text('Login',
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xffffffff),fontFamily:'RR'), )) ,
                          ),
                        ),
                      ):
                      currentDayInfo['LogoutTime']==null?Consumer<LocationNotifier>(
                        builder: (context,locNot,child)=> GestureDetector(
                          onTap: () async {

                            CustomAlert(
                              callback: (){
                                    if(locNot.isLocationServiceEnable && locNot.locationData!=null && locNot.first!=null){
                                      dbRef.child("${DateFormat(dbDateFormat).format(DateTime.now())}").child(USERDETAIL['Uid']).update({
                                        'lat':locNot.locationData!.latitude,
                                        'longi':locNot.locationData!.longitude,
                                        'LogoutTime':DateTime.now().toString(),
                                        'LogoutAddress':"${locNot.first.featureName} : ${locNot.first.addressLine}"
                                      });
                                      onStop();
                                      Navigator.pop(context);
                                    }
                                    else{
                                      locNot.listenLocation();
                                      Navigator.pop(context);
                                    }
                              }
                            ).cupertinoDialog1(context);





                          },
                          child: Container(
                            width: width*0.75,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: [
                              //   BoxShadow(color: Colors.green, spreadRadius: 3),
                              // ],
                              color: Colors.indigoAccent,
                            ),
                            child:Center(child: Text('LogOut',
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xffffffff),fontFamily:'RR'), )) ,
                          ),
                        ),
                      ):Container(),
                      SizedBox(height: 15.0,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
