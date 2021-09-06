import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/login.dart';
import 'package:cybertech/pages/admin/employeeMaster/employeeMasterGrid.dart';
import 'package:cybertech/pages/admin/siteAssign/siteEmployeeGrid.dart';
import 'package:cybertech/pages/admin/siteMaster/siteMasterGrid.dart';
import 'package:cybertech/pages/generalUser/generalUserHomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'attendanceReport/attendanceMonthWise.dart';
import 'mapScreen.dart';
class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  GlobalKey <ScaffoldState> scaffoldKey=new GlobalKey<ScaffoldState>();
  int menuSel=1;

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
                  title: "Employee Master",
                  img: 'assets/images/nav/employeeMaster.png',
                  ontap: (){
                    setState(() {
                      menuSel=1;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
              DrawerContent(
                  title: "Site Master",
                  img: 'assets/images/nav/building.png',
                  ontap: (){
                    setState(() {
                      menuSel=2;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
              DrawerContent(
                  title: "Site Assign",
                  img: 'assets/images/nav/assignment.png',
                  ontap: (){
                    setState(() {
                      menuSel=3;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
              DrawerContent(
                  title: "Track",
                  img: 'assets/images/nav/placeholder.png',
                  ontap: (){
                    setState(() {
                      menuSel=4;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
              DrawerContent(
                  title: "Attendance Report",
                  img: 'assets/images/nav/attendance.png',
                  ontap: (){
                    setState(() {
                      menuSel=5;
                    });
                    scaffoldKey.currentState!.openEndDrawer();
                  }
              ),
              DrawerContent(
                  title: "Logout",
                  img: 'assets/images/nav/logout.png',
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
        body: menuSel==1?EmployeeMasterGrid(drawerCallback: (){
          scaffoldKey.currentState!.openDrawer();
        }):
        menuSel==2?SiteMasterGrid(drawerCallback: (){
          scaffoldKey.currentState!.openDrawer();
        }):
        menuSel==3?SiteEmployeeGrid(drawerCallback: (){
          scaffoldKey.currentState!.openDrawer();
        }):
        menuSel==4?MapSample(drawerCallback: (){
          scaffoldKey.currentState!.openDrawer();
        }):
        menuSel==5?AttendanceOverView(drawerCallback: (){
          scaffoldKey.currentState!.openDrawer();
        }):Container(),
      ),
    );
  }
}



/*
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
}*/
