import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/notifier/timeNotifier.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';



class GeneralUserAttendance extends StatefulWidget {
  VoidCallback drawerCallback;
  GeneralUserAttendance({required this.drawerCallback});
  @override
  _GeneralUserAttendanceState createState() => _GeneralUserAttendanceState();
}

class _GeneralUserAttendanceState extends State<GeneralUserAttendance> {
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();
  late  double width,height,width2;

  final Location location = Location();
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;

  final dbRef = FirebaseDatabase.instance.reference().child("Attendance");
  var first;
  final dbRef2=FirebaseDatabase.instance.reference().child("TrackUsers").child(USERDETAIL['Uid']);
  Future<void> _listenLocation() async {
    location.enableBackgroundMode(enable: true);
    location.changeSettings(accuracy: LocationAccuracy.high,interval: 2000,);
    //_location=location.getLocation() as LocationData?;
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
          if (err is PlatformException) {
            setState(() {
              _error = err.code;
            });
          }
          _locationSubscription?.cancel();
          setState(() {
            _locationSubscription = null;
          });
        }).listen((LocationData currentLocation) async {
          final coordinates = new Coordinates(currentLocation.latitude, currentLocation.longitude);
          var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        //  print("56 --- ${addresses.first.addressLine}");
          if(first!=null){
            if(addresses.first.featureName!=first.featureName && addresses.first.addressLine!=first.addressLine){
              dbRef2.update({
                'lat':currentLocation.latitude,
                'long':currentLocation.longitude,
              });
              print("addresses.first if ${addresses.first.addressLine}");
              setState(()  {
            //    _error = null;
              //  _location = currentLocation;
                first = addresses.first;
               // print(_location);
              });
            }
          }
          else{
            dbRef2.update({
              'lat':currentLocation.latitude,
              'long':currentLocation.longitude,
            });
            print("addresses.first else ${addresses.first.addressLine}");
            setState(()  {
          //    _error = null;
            //  _location = currentLocation;
              first = addresses.first;
           //   print(" ${first.featureName} : ${first.addressLine}");
            });
          }
        });
  //  setState(() {});
  }

/*  Future<void> _stopListen() async {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
  //  setState(() {
      _locationSubscription = null;
    //});
    super.dispose();
  }*/
  Map currentDayInfo={};
  getCurrentDayInfo(){
    dbRef.child(DateFormat("dd-MM-yyyy").format(DateTime.now())).child(USERDETAIL['Uid']).onValue.listen((value){
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
    _listenLocation();
    getCurrentDayInfo();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _listenLocation();
    super.didChangeDependencies();
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
                      child: Text('Attendance',style: TextStyle(color: Color(0xffffffff),fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'RR'),),
                    ),
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
                      //Login Successful-UI-Start

                      // Container(
                      //     child: Text('Login Successful!',style: TextStyle(color: Color(0XFF2D972A),fontSize: 20,fontWeight: FontWeight.bold,fontFamily: 'RR'),),
                      // ),
                      // SizedBox(height: 5.0,),
                      /*Container(
                         child: Text('${DateFormat.jms().format(DateTime.parse(currentDayInfo['LoginTime']))}',style: TextStyle(color: Color(0XFF000000),fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'RR'),),
                       ),*/
                      // SizedBox(height:5.0,),
                      // Container(
                      //   width: width*0.27,
                      //   height: 30,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5),
                      //     // boxShadow: [
                      //     //   BoxShadow(color: Colors.green, spreadRadius: 3),
                      //     // ],
                      //     color: Colors.indigoAccent,
                      //   ),
                      //   child:Center(child: Text('19:31AM',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color(0xffffffff),fontFamily:'RR',letterSpacing: 2.0), )) ,
                      // ),

                      //Login Successful-UI-End
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
                          placeholder: (context,url) => CircularProgressIndicator(),
                          errorWidget: (context,url,error) => new Icon(Icons.error),
                        ),


                       // Image.network(USERDETAIL['imgUrl'],fit: BoxFit.cover,loadingBuilder: (ctx,),),
                      ) ,
                      SizedBox(height: 25.0,),
                      Text(first==null?"":"${first.featureName} : ${first.addressLine}"),
                      currentDayInfo.isEmpty?GestureDetector(
                        onTap: () async {
                        //  getCurrentDayInfo();
                          _location=await location.getLocation();
                          final coordinates = new Coordinates(_location!.latitude, _location!.longitude);
                          var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                          var first = addresses.first;
                          print("${first.featureName} : ${first.addressLine}");
                            dbRef.child("${DateFormat("dd-MM-yyyy").format(DateTime.now())}").child(USERDETAIL['Uid']).set({
                              'Name':USERDETAIL['Name'],
                              'lat':_location!.latitude,
                              'longi':_location!.longitude,
                              'LoginTime':DateTime.now().toString(),
                              'LoginAddress':"${first.featureName} : ${first.addressLine}"

                            });

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
                      ):
                      currentDayInfo['LogoutTime']==null?GestureDetector(
                        onTap: () async {
                          _location=await location.getLocation();
                          final coordinates = new Coordinates(_location!.latitude, _location!.longitude);
                          var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                          var first = addresses.first;
                          print("${first.featureName} : ${first.addressLine}");
                          dbRef.child("${DateFormat("dd-MM-yyyy").format(DateTime.now())}").child(USERDETAIL['Uid']).update({
                            'lat':_location!.latitude,
                            'longi':_location!.longitude,
                            'LogoutTime':DateTime.now().toString(),
                            'LogoutAddress':"${first.featureName} : ${first.addressLine}"
                          });

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
