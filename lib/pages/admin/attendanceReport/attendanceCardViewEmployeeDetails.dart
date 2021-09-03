import 'package:cybertech/widgets/arrowBack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:developer';

import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'attendanceMonthWiseGrid.dart';


class AttendanceCardViewEmpDetails extends StatefulWidget {
  Map details;
  AttendanceCardViewEmpDetails({required this.details});
  @override
  _AttendanceCardViewEmpDetailsState createState() => _AttendanceCardViewEmpDetailsState();
}

class _AttendanceCardViewEmpDetailsState extends State<AttendanceCardViewEmpDetails> {
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();

  late  double width,height,width2;

  final dbRef = FirebaseDatabase.instance.reference().child("Attendance");
  final dbRef2 = FirebaseDatabase.instance.reference().child("Users");

  int selIndex=-1;
  @override
  void initState() {

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    width2=width-16;
    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body:Container(
          child:Column(
            children: [
              Container(
                width: width,
                height: 50,
                color: Color(0xff4852FF),
                child: Row(
                  children: [
                    ArrowBack(
                      ontap: (){
                        Navigator.pop(context);
                      },
                      iconColor: Colors.white,
                    ),
                    Container(
                      child: Text('   ${widget.details['Name']} ',style: TextStyle(color: Color(0xffffffff),fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'RR'),),
                    ),

                  ],
                ),
              ),
              Container(
                height: height-74,
                width: width,
                color: gridBodyBgColor,
                child: ListView.builder(
                  itemCount: widget.details['Details'].length,
                  itemBuilder: (ctx,i){
                    return GestureDetector(
                      onTap: (){
                        if(selIndex==i){
                          setState(() {
                            selIndex=-1;
                          });
                        }
                        else{
                          setState(() {
                            selIndex=i;
                          });
                        }
                        print( widget.details['Details'][i]);
                      //  print( widget.details['Details'][i][0]);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        clipBehavior: Clip.antiAlias,
                        height: selIndex==i?220:50,
                        margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${DateFormat.MMMd().format(DateTime.parse(widget.details['Details'][i]['Date']))}   ${widget.details['Details'][i]['Attendance']}"),
                            SizedBox(height: 3,),
                            Text("Login Details"),
                            SizedBox(height: 2,),
                            CustomListTile(
                              height: 30,
                              leading: Icon(Icons.timer,size: 15,),
                              title: Text("${widget.details['Details'][i]['LoginTime']}"),
                            ),
                            CustomListTile(
                              height: 30,
                              leading: Icon(Icons.location_on_outlined,size: 20,color: Colors.red,),
                              title: Container(
                                  width: width-100,
                                  child: Text("${widget.details['Details'][i]['LoginAddress']}")),
                            ),

                            SizedBox(height: 20,),
                            Text("LogOut Details"),
                            SizedBox(height: 2,),
                            CustomListTile(
                              height: 30,
                              leading: Icon(Icons.timer,size: 15,),
                              title: Text("${widget.details['Details'][i]['LogoutTime']}"),
                            ),
                            CustomListTile(
                              height: 30,
                              leading: Icon(Icons.location_on_outlined,size: 20,color: Colors.red,),
                              title: Container(
                                  width: width-100,
                                  child: Text("${widget.details['Details'][i]['LogoutAddress']}")),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ) ,
      ),
    );
  }
}


class CustomListTile extends StatelessWidget {

  double height;
  Widget leading;
  Widget title;
  CustomListTile({required this.height,required this.leading,required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          SizedBox(width: 7,),
          title
        ],
      ),
    );
  }
}
