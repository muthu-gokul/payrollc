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
                        height: selIndex==i?320:40,
                        margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color:widget.details['Details'][i]['Attendance']=='P'?Colors.green:Colors.red )
                         /*   boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(1, 8), // changes position of shadow
                              )
                            ]*/
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${DateFormat.MMMd().format(DateTime.parse(widget.details['Details'][i]['Date']))}   ${widget.details['Details'][i]['Attendance']}",
                              style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 15),
                            ),
                            SizedBox(height: 8,),
                            Text("Login Details :",
                                style: TextStyle(fontFamily: 'RM',color: grey,fontSize: 15)
                            ),
                            SizedBox(height: widget.details['Details'][i]['LoginTime']==null?0:8,),
                            widget.details['Details'][i]['LoginTime']==null?Container():Container(
                              child: CustomListTile(
                                height: 30,
                                leading: Icon(Icons.timer,size: 17,),
                                title: Text("${DateFormat.jms().format(DateTime.parse(widget.details['Details'][i]['LoginTime']))}",
                                    style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 14)),
                              ),
                            ),
                            widget.details['Details'][i]['LoginTime']==null?Container():CustomListTile(
                              height: 70,
                              leading: Icon(Icons.location_on_outlined,size: 20,color: Colors.red,),
                              title: Container(
                                  width: width-120,
                                  child: SingleChildScrollView(
                                      child: Text("${widget.details['Details'][i]['LoginAddress']}",
                                          style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 13.5)
                                      )
                                  )
                              ),
                            ),

                            SizedBox(height: 20,),
                            Text("LogOut Details :",
                                style: TextStyle(fontFamily: 'RM',color: grey,fontSize: 15)
                            ),
                            SizedBox(height: 2,),
                            widget.details['Details'][i]['LogoutTime']==null?Container():Container(
                              child: CustomListTile(
                                height: 30,
                                leading: Icon(Icons.timer,size: 17,),
                                title: Text("${DateFormat.jms().format(DateTime.parse(widget.details['Details'][i]['LogoutTime']))}",
                                    style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 14)),
                              ),
                            ),
                            widget.details['Details'][i]['LogoutTime']==null?Container():CustomListTile(
                              height: 70,
                              leading: Icon(Icons.location_on_outlined,size: 20,color: Colors.red,),
                              title: Container(
                                  width: width-120,
                                  child: SingleChildScrollView(
                                      child: Text("${widget.details['Details'][i]['LogoutAddress']}",
                                          style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 13.5)
                                      )
                                  )
                              ),
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
      padding: EdgeInsets.only(left: 15),
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
