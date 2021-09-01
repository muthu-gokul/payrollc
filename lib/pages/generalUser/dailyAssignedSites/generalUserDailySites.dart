import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/employeeMaster/employeeMasterAddNEw.dart';
import 'package:cybertech/pages/admin/siteAssign/siteAssignPage.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/editDelete.dart';
import 'package:cybertech/widgets/grid/reportDataTableWithoutModel.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:cybertech/widgets/singleDatePicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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
  List<dynamic> siteList=[];
  int selectedIndex=-1;
  String selectedUid="";
  dynamic selectedValue={};
  bool showEdit=false;
  List<ReportGridStyleModel2> reportsGridColumnNameList=[
    ReportGridStyleModel2(columnName: "Name"),
    ReportGridStyleModel2(columnName: "Email"),
    ReportGridStyleModel2(columnName: "UserGroupName"),
  ];

  DateTime? date;


  @override
  void initState() {
    date=DateTime.now();
    dbRef3.child(DateFormat("dd-MM-yyyy").format(date!)).orderByKey().equalTo(USERDETAIL['Uid']).onValue.listen((event) {
      siteList.clear();
      DataSnapshot dataValues = event.snapshot;

      if(dataValues.value!=null){
        Map<dynamic, dynamic> values = dataValues.value;
        setState(() {
          siteList=dataValues.value[USERDETAIL['Uid']];
        });
        print(siteList);
      }
    });
    date=DateTime.now();
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
              margin: EdgeInsets.only(top: 50),
              child: ListView.builder(
                itemCount: siteList.length,
                itemBuilder: (ctx,i){
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
