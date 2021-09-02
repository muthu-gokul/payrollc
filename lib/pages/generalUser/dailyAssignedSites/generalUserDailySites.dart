import 'dart:async';

import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/employeeMaster/employeeMasterAddNEw.dart';
import 'package:cybertech/pages/admin/siteAssign/siteAssignPage.dart';
import 'package:cybertech/pages/generalUser/dailyAssignedSites/generalUserSiteLoginLogOut.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/editDelete.dart';
import 'package:cybertech/widgets/grid/reportDataTableWithoutModel.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:cybertech/widgets/singleDatePicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class GeneralUserDailySites extends StatefulWidget {
  VoidCallback drawerCallback;
  GeneralUserDailySites({required this.drawerCallback});

  @override
  _GeneralUserDailySitesState createState() => _GeneralUserDailySitesState();
}

class _GeneralUserDailySitesState extends State<GeneralUserDailySites> {
  final dbRef = FirebaseDatabase.instance.reference().child("Users").orderByChild("UserGroupId").equalTo(2);
  final dbRef2 = FirebaseDatabase.instance.reference().child("SiteDetail");
  final dbRef3 = FirebaseDatabase.instance.reference().child("SiteAssign");
  List<dynamic> lists=[];
  late List<dynamic> siteList;
  int selectedIndex=-1;
  String selectedUid="";
  dynamic selectedValue={};
  bool showEdit=false;
  DateTime? date;

  final Location location = Location();
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  var first;

  Future<void> _listenLocation() async {
    location.enableBackgroundMode(enable: true);
    location.changeSettings(accuracy: LocationAccuracy.high,interval: 2000,);
    //_location=location.getLocation() as LocationData?;
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
          if (err is PlatformException) {
            /*setState(() {
              _error = err.code;
            });*/
          }
          _locationSubscription?.cancel();
          setState(() {
            _locationSubscription = null;
          });
        }).listen((LocationData currentLocation) async {
          final coordinates = new Coordinates(currentLocation.latitude, currentLocation.longitude);
          var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
          if(first!=null){
            if(addresses.first.featureName!=first.featureName && addresses.first.addressLine!=first.addressLine){
              setState(()  {
               // _error = null;
                _location = currentLocation;
                first = addresses.first;
                // print(_location);
                print("if ${first.featureName} : ${first.addressLine}");
              });
            }
          }
          else{
            setState(()  {
             // _error = null;
              _location = currentLocation;
              first = addresses.first;
              print("else ${first.featureName} : ${first.addressLine}");
            });
          }
        });
    //  setState(() {});
  }

  @override
  void initState() {
    date=DateTime.now();
    dbRef3.child(DateFormat(dbDateFormat).format(date!)).orderByKey().equalTo(USERDETAIL['Uid']).onValue.listen((event) {

      DataSnapshot dataValues = event.snapshot;
      print(dataValues.value);
      if(dataValues.value!=null){
        Map<dynamic, dynamic> values = dataValues.value;
        setState(() {
          siteList=dataValues.value[USERDETAIL['Uid']];
        });
      }
      else{
        siteList=[];
      }
    });
    date=DateTime.now();
   // _listenLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        color: gridBodyBgColor,
        child: Stack(
          children: [
            Container(
              height: 50,
              width: SizeConfig.screenWidth,
              color: bgColor,
              child: Row(
                children: [
                  NavBarIcon(
                    ontap: widget.drawerCallback,
                  ),
                  Text("  Today Sites",
                    style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                  ),

                ],
              ),
            ),
            Container(
              height: SizeConfig.screenHeight!-50,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(top: 70),
              child: ListView.builder(
                itemCount: siteList.length,
                itemBuilder: (ctx,i){
                  return GestureDetector(
                    onTap: () async {
                      print("${first.addressLine}");
                    /*  var loc=await location.getLocation();
                      final coordinates = new Coordinates(loc.latitude, loc.longitude);
                      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                      print("${addresses.first.addressLine}");
                      print("await Location().isBackgroundModeEnabled() ${await Location().isBackgroundModeEnabled()}");
                      print("await Location().requestService() ${await Location().requestService()}");
                      print("await Location().serviceEnabled() ${await Location().serviceEnabled()}");*/
                      if(_location!=null && await Location().isBackgroundModeEnabled()
                          && await Location().requestService() && await Location().serviceEnabled()){
                        print("HELLO IF");
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>GeneralUserSiteLoginLogOut(
                          currentLocation: "${first.featureName} : ${first.addressLine}",
                          index: i,
                          latitude: _location!.latitude,
                          longitude: _location!.longitude,
                        )));
                      }
                      else{
                        print("HELLO");
                        var loc=await location.getLocation();
                        setState((){
                          _location=loc;
                        });

                        _listenLocation();
                      }

                    },
                    child: Container(
                      height: 60,
                      width: SizeConfig.screenWidth!*0.95,
                      margin: EdgeInsets.only(bottom: 20,left: 20,right: 20),
                      padding: EdgeInsets.only(left: 20,right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(1, 8), // changes position of shadow
                            )
                          ]
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                              width: (SizeConfig.screenWidth!*0.95)-76,
                              child: Text("${siteList[i]['SiteName']}",style: gridTextColor14,)
                          ),
                          siteList[i]['SiteLoginTime']==null?Container():Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:siteList[i]['SiteLogoutTime']==null? Colors.red:Colors.green
                            ),
                          )
                        ],
                      ),
                      //child: Text("Thiruverkadu : No.134 Selva laxminagar 4 set, TTS Nagar, Thiruverkadu, Tamil Nadu 600077, India",style: gridTextColor14,),
                    ),
                  );
                  return Text(siteList[i]['SiteName']);
                },
              ),
            )


            //bottomNav
            /*   Positioned(
              bottom: 0,
              child: Container(
                width: SizeConfig.screenWidth,
                // height:_keyboardVisible?0:  70,
                height: 65,

                decoration: BoxDecoration(
                    color: gridBodyBgColor,
                    boxShadow: [
                      BoxShadow(
                        color: gridBodyBgColor,
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: Offset(0, -20), // changes position of shadow
                      )
                    ]
                ),
                child: Stack(

                  children: [
                    Container(
                      decoration: BoxDecoration(

                      ),
                      margin:EdgeInsets.only(top: 0),
                      child: CustomPaint(
                        size: Size( SizeConfig.screenWidth!, 65),
                        painter: RPSCustomPainter3(),
                      ),
                    ),

                    Container(
                      width:  SizeConfig.screenWidth,
                      height: 80,
                      child: Stack(

                        children: [
                          EditDelete(
                            showEdit: showEdit,
                            editTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx)=>EmployeeMasterAddNew(
                                isEdit: true,
                                value: selectedValue,
                              ))).then((value){
                                setState(() {
                                  showEdit=false;
                                  selectedUid="";
                                  selectedValue={};
                                });
                              });

                            },
                            deleteTap: (){
                              CustomAlert(
                                  callback: (){
                                    AuthenticationHelper().signIn(email1: selectedValue['Name'], password1: selectedValue['Password']).then((value){
                                      FirebaseDatabase.instance.reference().child("Users").child(selectedUid).remove().then((value) async {
                                        await AuthenticationHelper().user.delete();
                                        AuthenticationHelper().signIn(email1: prefEmail,
                                            password1: prefPassword);
                                        Navigator.pop(context);
                                      });
                                    });


                                  },
                                  Cancelcallback: (){
                                    Navigator.pop(context);
                                  }
                              ).yesOrNoDialog(context, "", "Are you sure want to delete this user ?");
                            },
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            //Add Button
            Align(
                alignment: Alignment.bottomCenter,
                child: AddButton(
                  ontap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>EmployeeMasterAddNew(
                      isEdit: false,
                      value: {},
                    )));
                  },
                  image: "assets/svg/plusIcon.svg",
                )
            ),*/

          ],
        ),
      ),
    );
  }
}
