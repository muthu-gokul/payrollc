import 'dart:async';

import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/login.dart';
import 'package:cybertech/notifier/timeNotifier.dart';
import 'package:cybertech/pages/admin/employeeMaster/employeeMasterGrid.dart';
import 'package:cybertech/pages/admin/siteAssign/siteEmployeeGrid.dart';
import 'package:cybertech/pages/admin/siteMaster/siteMasterGrid.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'attendance/generalUserAttendance.dart';
import 'dailyAssignedSites/generalUserDailySites.dart';

class GeneralHomePage extends StatefulWidget {
  @override
  _GeneralHomePageState createState() => _GeneralHomePageState();
}

class _GeneralHomePageState extends State<GeneralHomePage> with WidgetsBindingObserver{

  GlobalKey <ScaffoldState> scaffoldKey=new GlobalKey<ScaffoldState>();
  int menuSel=1;

  late Timer timer;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      print("PAUSED");
      if (!mounted) return;


    }
    if(state == AppLifecycleState.resumed){
      print("resumed");
      if(timer.isActive){
        timer.cancel();
      }

    }
    if(state==AppLifecycleState.inactive){

      print("inactive");
      timer= Timer.periodic(Duration(seconds: 30), (timer) {
        if(context!=null){
          print("MM");
          Provider.of<LocationNotifier>(context,listen: false).listenLocation();
        }
      });
      // if(selectedNotificationPayload==null){

      if (!mounted) return;


    }
    if(state==AppLifecycleState.detached){
      print("detached");
      if (!mounted) return;

    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    Provider.of<LocationNotifier>(context,listen: false).listenLocation();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth!*0.75,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(7),bottomRight: Radius.circular(7)),
              color: Colors.white
          ),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Image.asset("assets/images/logo.png",height: 70,))
              ),

              DrawerContent(
                  title: "Attendance",
                  ontap: (){
                    setState(() {
                      menuSel=1;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
              DrawerContent(
                  title: "Assigned Sites",
                  ontap: (){
                    setState(() {
                      menuSel=2;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
        /*      DrawerContent(
                  title: "Site Master",
                  ontap: (){
                    setState(() {
                      menuSel=2;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
              DrawerContent(
                  title: "Site Assign",
                  ontap: (){
                    setState(() {
                      menuSel=3;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
              DrawerContent(
                  title: "Track",
                  ontap: (){
                    setState(() {
                      menuSel=4;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),*/
              DrawerContent(
                  title: "Logout",
                  ontap: (){
                    //  setState(() {
                    //   menuSel=2;
                    //   });
                    scaffoldKey.currentState!.openEndDrawer();
                    AuthenticationHelper().signOut();
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                          (route) => false,//if you want to disable back feature set to false
                    );
                  }
              ),
            ],
          ),
        ),
        body: menuSel==1?GeneralUserAttendance(drawerCallback: (){
          scaffoldKey.currentState!.openDrawer();
        }):
        menuSel==2?GeneralUserDailySites(drawerCallback: (){
          scaffoldKey.currentState!.openDrawer();
        }):
        menuSel==3?SiteEmployeeGrid(drawerCallback: (){
          scaffoldKey.currentState!.openDrawer();
        }): Container(),
      ),
    );
  }
}



class DrawerContent extends StatelessWidget {
  VoidCallback ontap;
  String title;
  DrawerContent({required this.title,required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:ontap,
      child: Container(
        height: 50,
        width: SizeConfig.screenWidth!*0.8,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!))
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        child: Text("$title",style: TextStyle(fontFamily: 'RR',color: Color(0xFF444444),fontSize: 16),),
      ),
    );
  }
}