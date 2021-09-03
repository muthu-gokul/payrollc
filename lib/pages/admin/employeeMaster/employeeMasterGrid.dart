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
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeMasterGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  EmployeeMasterGrid({required this.drawerCallback});

  @override
  _EmployeeMasterGridState createState() => _EmployeeMasterGridState();
}

class _EmployeeMasterGridState extends State<EmployeeMasterGrid> {
  final dbRef = FirebaseDatabase.instance.reference().child("Users");
  List<dynamic> lists=[];
  int selectedIndex=-1;
  String selectedUid="";
  dynamic selectedValue={};
  Map employees={};
  bool showEdit=false;
  List<ReportGridStyleModel2> reportsGridColumnNameList=[
    ReportGridStyleModel2(columnName: "Name"),
    ReportGridStyleModel2(columnName: "Email"),
    ReportGridStyleModel2(columnName: "UserGroupName"),
  ];



  @override
  void initState() {
    dbRef.onValue.listen((event) {
   //   lists.clear();
      employees.clear();
      DataSnapshot dataValues = event.snapshot;
      if(dataValues.value!=null){
        Map<dynamic, dynamic> values = dataValues.value;
        print("LIST CLESR $values");
        setState(() {
          employees=values;
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
              height: SizeConfig.screenHeight!-242,
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
            /*ReportDataTable2(
              topMargin: 55,
              gridBodyReduceHeight: 150,
              selectedIndex: selectedIndex,
              selectedUid: selectedUid,
              gridData: lists,
              gridDataRowList: reportsGridColumnNameList,
              func: (uid,value){

                if(selectedUid==uid){
                  setState(() {
                    selectedUid="";
                    selectedValue={};
                    showEdit=false;
                  });

                }
                else{
                  setState(() {
                    selectedUid=uid;
                    selectedValue=value;
                    showEdit=true;

                  });
                }
              },
            ),*/


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
            ),

          ],
        ),
      ),
    );
  }
}
