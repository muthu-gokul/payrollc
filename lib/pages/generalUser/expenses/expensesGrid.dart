import 'dart:async';
import 'dart:developer';

import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/employeeMaster/employeeMasterAddNEw.dart';
import 'package:cybertech/pages/generalUser/expenses/expensesAddNew.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/editDelete.dart';
import 'package:cybertech/widgets/grid/reportDataTableWithoutModel.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GeneralUserExpenseGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  GeneralUserExpenseGrid({required this.drawerCallback});

  @override
  _GeneralUserExpenseGridState createState() => _GeneralUserExpenseGridState();
}

class _GeneralUserExpenseGridState extends State<GeneralUserExpenseGrid> {
  final dbRef = databaseReference.child("SiteDetail");
  List<dynamic> lists=[];
  int selectedIndex=-1;
  String selectedUid="";
  dynamic selectedValue={};
  bool showEdit=false;
  bool addSiteOpen=false;
  TextEditingController siteName=new TextEditingController();




  @override
  void initState() {
    dbRef.onValue.listen((event) {
      lists.clear();

      DataSnapshot dataValues = event.snapshot;
      if(dataValues.value!=null){
        Map<dynamic, dynamic> values = dataValues.value;
        //  print("LIST CLESR $values");
        values.forEach((key, values) {
          setState(() {
            values['Key']=key;
            lists.add(values);
          });
        });

      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node=FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  Text("  Expenses",
                    style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(left: 5,right: 5,top: 55),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: addNewTextFieldBorder)
              ),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 70,
                    alignment: Alignment.center,
                    child: Text("S.No",style: gridHeaderTS,),
                  ),
                  Container(
                    height: 50,
                    width: SizeConfig.screenWidth!-82,
                    alignment: Alignment.centerLeft,
                    child: Text("Site Name",style: gridHeaderTS,),
                  )
                ],
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


                            },
                            deleteTap: (){
                            /*  CustomAlert(
                                  callback: (){
                                    AuthenticationHelper().signIn(email1: selectedValue['Name'], password1: selectedValue['Password']).then((value){
                                      FirebaseDatabase.instance.reference().child("Users").child(selectedUid).remove().then((value) async {
                                        await AuthenticationHelper().auth2.currentUser!.delete();
                                        AuthenticationHelper().signIn(email1: prefEmail,
                                            password1: prefPassword);
                                        Navigator.pop(context);
                                      });
                                    });


                                  },
                                  Cancelcallback: (){
                                    Navigator.pop(context);
                                  }
                              ).yesOrNoDialog(context, "", "Are you sure want to delete this user ?");*/
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
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>GeneralUserExpensesAddNew(
                      siteList: lists,
                    )));
                  },
                  image: "assets/svg/plusIcon.svg",
                )
            ),


            Container(

              height: addSiteOpen ? SizeConfig.screenHeight:0,
              width: addSiteOpen ? SizeConfig.screenWidth:0,
              color: Colors.black.withOpacity(0.5),

            ),


          ],
        ),
      ),
    );
  }
}
