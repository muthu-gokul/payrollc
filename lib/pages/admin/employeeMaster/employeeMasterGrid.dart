import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/employeeMaster/employeeMasterAddNEw.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/editDelete.dart';
import 'package:cybertech/widgets/grid/reportDataTableWithoutModel.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:cybertech/widgets/noData.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmployeeMasterGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  EmployeeMasterGrid({required this.drawerCallback});

  @override
  _EmployeeMasterGridState createState() => _EmployeeMasterGridState();
}

class _EmployeeMasterGridState extends State<EmployeeMasterGrid> {
  final dbRef = databaseReference.child("Users");
  List<dynamic> lists=[];
  int selectedIndex=-1;
  String selectedUid="";
  dynamic selectedValue={};
  Map employees={};
  bool showEdit=false;
  bool isLoad=false;
  List<ReportGridStyleModel2> reportsGridColumnNameList=[
    ReportGridStyleModel2(columnName: "Name"),
    ReportGridStyleModel2(columnName: "Email"),
    ReportGridStyleModel2(columnName: "UserGroupName"),
  ];



  @override
  void initState() {
    dbRef.onValue.listen((event) {
   //   lists.clear();
      setState(() {
        isLoad=true;
      });
      employees.clear();
      DataSnapshot dataValues = event.snapshot;
      if(dataValues.value!=null){
        Map<dynamic, dynamic> values = dataValues.value;
        print("LIST CLESR $values");
        setState(() {
          employees=values;
          isLoad=false;
        });
      }
      else{
        setState(() {
          isLoad=false;
        });
      }

     /* values.forEach((key, values) {
        setState(() {
          lists.add(values);
        });
      });*/

    });
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
                  Text("  Employee Master",
                  style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              height: SizeConfig.screenHeight!-70,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  runAlignment: WrapAlignment.center,
                  children: employees.map((key, value) => MapEntry(key, GestureDetector(
                    child:    Container(
                      width: SizeConfig.screenWidth!*0.47,
                      height: 120,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            clipBehavior: Clip.antiAlias,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                            ),
                            child:value['imgUrl']==null? Image.asset("assets/images/profile.png" ,width: 200,fit: BoxFit.cover,):

                            CachedNetworkImage(
                              imageUrl: value['imgUrl'],
                              placeholder: (context,url) => CupertinoActivityIndicator(
                                radius: 20,
                                animating: true,
                              ),
                              errorWidget: (context,url,error) => new Icon(Icons.error),
                            ),
                          ) ,

                          SizedBox(height: 5,),
                          Container(
                            child: Text('${value['Name']}',style: TextStyle(fontSize: 14,fontFamily: 'RB',color: Colors.black),),
                          ),
                          SizedBox(height: 2,),
                          Container(
                            child: Text('${value['UserGroupName']}',style: TextStyle(fontSize: 12,fontFamily: 'RR',color: Colors.black),),
                          ),
                        ],
                      ),
                    ),
                  ))).values.toList()

                ),
              ),
            ),


            //bottomNav
            Positioned(
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
                                    databaseReference.child("Users").child(selectedUid).remove().then((value) async {
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
                    ),
                    Container(
                      width:  SizeConfig.screenWidth,
                      height: 80,
                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          GestureDetector(
                              onTap:() async {
                              //  log("$employees");

                                if(employees.isEmpty){
                                  CustomAlert().cupertinoAlertDialog(context, "No Data");
                                }
                                else{
                                  var excel = Excel.createExcel();
                                  Sheet sheetObject = excel['Employee Detail'];
                                  excel.delete('Sheet1');
                                  CellStyle cellStyle = CellStyle( fontFamily : getFontFamily(FontFamily.Calibri),bold: true);
                                  List<String?> header=['EmployeeId','Name','Email','Region Name','Phone Number','UserGroup Name'];
                                  int ascii=65;
                                  header.forEach((element) {
                                    var cell = sheetObject.cell(CellIndex.indexByString("${String.fromCharCode(ascii)}1"));
                                    cell.cellStyle = cellStyle;
                                    ascii++;
                                  });
                                  sheetObject.insertRowIterables(header, 0,);

                                  List<String> body=[];
                                  int i=0;
                                  employees.forEach((key, value) {
                                    body.clear();
                                    body.add(value['EmployeeId']??"");
                                    body.add(value['Name']??"");
                                    body.add(value['Email']??"");
                                    body.add(value['RegionName']??"");
                                    body.add(value['PhoneNumber']??"");
                                    body.add(value['UserGroupName']??"");
                                    sheetObject.insertRowIterables(body, i+1,);
                                    i++;
                                  });


                                  final String dirr ='/storage/emulated/0/Download';
                                  String filename="EmployeeDetail${DateTime.now().toString()}";
                                  //   await Directory('/storage/emulated/0/Download').create(recursive: true);
                                  final String path = '$dirr/$filename.xlsx';


                                  final File file = File(path);
                                  await file.writeAsBytes(await excel.encode()!).then((value) async {
                                    CustomAlert().billSuccessAlert(context, "", "Successfully Downloaded @ \n\n Internal Storage/Download/$filename.xlsx", "", "");
                                  });
                                }



                              },
                              child: SvgPicture.asset("assets/svg/excel.svg",height: 30,)
                          )
                        ],
                      ),
                    ),
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
            ),

            isLoad?ShimmerWidget(topMargin: 70,):Container(),
          ],
        ),
      ),
    );
  }
}
