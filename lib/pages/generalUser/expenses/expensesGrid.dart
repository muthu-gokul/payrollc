import 'dart:async';
import 'dart:developer';

import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/notifier/generalUserExpenseNotifier.dart';
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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GeneralUserExpenseGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  GeneralUserExpenseGrid({required this.drawerCallback});

  @override
  _GeneralUserExpenseGridState createState() => _GeneralUserExpenseGridState();
}

class _GeneralUserExpenseGridState extends State<GeneralUserExpenseGrid> {

  final dbRef2 = databaseReference.child("SiteDetail");

  List<dynamic> siteLists=[];
  int selectedIndex=-1;
  String selectedUid="";
  dynamic selectedValue={};
  bool showEdit=false;
  bool addSiteOpen=false;
  TextEditingController siteName=new TextEditingController();


  TextStyle gridHeaderTS=TextStyle(fontFamily: 'RR',color: bgColor,fontSize: 16);
  TextStyle gridValueTS=TextStyle(fontFamily: 'RR',color: grey,fontSize: 14);

  double gridBodyReduceHeight =140;
  double topMargin =50;
  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;
  DateTime? date;

  @override
  void initState() {
    date=DateTime.now();
    Provider.of<GeneralUserExpenseNotifier>(context,listen: false).getData(date);
/*    dbRef.child(DateFormat(dbDateFormat).format(date!)).onValue.listen((event) {
      lists.clear();

      DataSnapshot dataValues = event.snapshot;
      if(dataValues.value!=null){
        Map<dynamic, dynamic> values = dataValues.value;
          print("LIST  $values");
        values.forEach((key, values) {
          setState(() {
            values['Key']=key;
            lists.add(values);
          });
        });
      }
    });*/
    dbRef2.onValue.listen((event) {
      siteLists.clear();

      DataSnapshot dataValues = event.snapshot;
      if(dataValues.value!=null){
        Map<dynamic, dynamic> values = dataValues.value;
        //  print("LIST CLESR $values");
        values.forEach((key, values) {
          setState(() {
            values['Key']=key;
            siteLists.add(values);
          });
        });

      }
    });




    header.addListener(() {
      if(body.offset!=header.offset){
        body.jumpTo(header.offset);
      }
      if(header.offset==0){
        setState(() {
          showShadow=false;
        });
      }
      else{
        if(!showShadow){
          setState(() {
            showShadow=true;
          });
        }
      }
    });

    body.addListener(() {
      if(header.offset!=body.offset){
        header.jumpTo(body.offset);
      }
    });

    verticalLeft.addListener(() {
      if(verticalRight.offset!=verticalLeft.offset){
        verticalRight.jumpTo(verticalLeft.offset);
      }
    });

    verticalRight.addListener(() {
      if(verticalLeft.offset!=verticalRight.offset){
        verticalLeft.jumpTo(verticalRight.offset);
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

            Consumer<GeneralUserExpenseNotifier>(
              builder:(ctx,not,child)=> Container(
                  height: SizeConfig.screenHeight!-topMargin,
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.only(top: topMargin),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color:gridBodyBgColor,
                    //borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                  child: Stack(
                    children: [

                      //Scrollable
                      Positioned(
                        left:149,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: SizeConfig.screenWidth!-152,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              margin: EdgeInsets.only(right: 1),
                              decoration:BoxDecoration(
                                color: addNewTextFieldBorder,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10)
                                ),
                              ),
                              child: Container(
                                height: 50,
                                width: SizeConfig.screenWidth!-152,
                                margin: EdgeInsets.only(right: 1,bottom: 1,top: 1),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                ),
                                //color: showShadow? bgColor.withOpacity(0.8):bgColor,
                                child: SingleChildScrollView(
                                  controller: header,
                                  scrollDirection: Axis.horizontal,
                                  physics: ClampingScrollPhysics(),
                                  child: Row(
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 10),
                                            width: 150,
                                            child: Text("Expense Amount",
                                              style: gridHeaderTS,)
                                        ),
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 10),
                                            width: 100,
                                            child: Text("Status",
                                              style: gridHeaderTS,)
                                        ),
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 10),
                                            width: 150,
                                            child: Text("Claimed Amount",
                                              style: gridHeaderTS,)
                                        ),
                                      ]
                                  ),
                                ),

                              ),
                            ),
                            Container(
                              height: SizeConfig.screenHeight!-gridBodyReduceHeight,
                              width: SizeConfig.screenWidth!-149,
                              alignment: Alignment.topLeft,
                              color: gridBodyBgColor,
                              child: SingleChildScrollView(
                                controller: body,
                                scrollDirection: Axis.horizontal,
                                physics: ClampingScrollPhysics(),
                                child: Container(
                                  height: SizeConfig.screenHeight!-gridBodyReduceHeight,
                                  alignment: Alignment.topCenter,
                                  color:gridBodyBgColor,
                                  child: SingleChildScrollView(
                                    controller: verticalRight,
                                    scrollDirection: Axis.vertical,
                                    physics: ClampingScrollPhysics(),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:not.lists!.asMap().
                                        map((i, value) => MapEntry(
                                            i,InkWell(
                                          onTap: (){
                                            //setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: gridBottomborder,
                                           //   color: widget.selectedUid==value['Uid']?yellowColor:gridBodyBgColor,
                                            ),
                                            height: 50,
                                            margin: EdgeInsets.only(bottom:i==not.lists!.length-1?70: 0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment:Alignment.centerLeft,
                                                    padding:  EdgeInsets.only(left: 10),
                                                    decoration: BoxDecoration(
                                                      border: gridBottomborder,
                                                      // color: widget.selectedUid==value['Uid']?yellowColor:gridBodyBgColor,
                                                    ),
                                                    height: 50,
                                                    width: 150,
                                                    child: Text("${formatCurrency.format(value['ExpenseValue'])}",
                                                      style:gridValueTS,
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:Alignment.centerLeft,
                                                    padding:  EdgeInsets.only(left: 10),
                                                    decoration: BoxDecoration(
                                                      border: gridBottomborder,
                                                      // color: widget.selectedUid==value['Uid']?yellowColor:gridBodyBgColor,
                                                    ),
                                                    height: 50,
                                                    width: 100,
                                                    child: Text("${value['Status']}",
                                                      style:gridValueTS,
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:Alignment.centerLeft,
                                                    padding:  EdgeInsets.only(left: 10),
                                                    decoration: BoxDecoration(
                                                      border: gridBottomborder,
                                                      // color: widget.selectedUid==value['Uid']?yellowColor:gridBodyBgColor,
                                                    ),
                                                    height: 50,
                                                    width: 150,
                                                    child: Text("${value['ClaimedAmount']==null?0.0:value['ClaimedAmount']}",
                                                      style:gridValueTS,
                                                    ),
                                                  ),
                                                ]
                                            ),
                                          ),
                                        )
                                        )
                                        ).values.toList()
                                    ),
                                  ),


                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      //not Scrollable
                      Positioned(
                        left: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration:BoxDecoration(
                                color: addNewTextFieldBorder,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)
                                ),
                              ),
                              child: Container(
                                height: 50,
                                width: 145,
                                margin: EdgeInsets.only(left: 1,bottom: 1,top: 1),
                                padding: EdgeInsets.only(left: 10),
                                alignment:Alignment.centerLeft,
                                //   clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                                ),
                                child: FittedBox(child: Text("Expense Name",
                                  style: TextStyle(fontFamily: 'RR',color: bgColor,fontSize: 16),)),

                              ),
                            ),
                            Container(
                              height: SizeConfig.screenHeight!-gridBodyReduceHeight,
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                  color:showShadow? gridBodyBgColor:Colors.transparent,
                                  boxShadow: [
                                    showShadow?  BoxShadow(
                                      color: grey.withOpacity(0.1),
                                      spreadRadius: 0,
                                      blurRadius: 15,
                                      offset: Offset(0, -8), // changes position of shadow
                                    ):BoxShadow(color: Colors.transparent)
                                  ]
                              ),
                              child: Container(
                                height: SizeConfig.screenHeight!-gridBodyReduceHeight,
                                alignment: Alignment.topCenter,

                                child: SingleChildScrollView(
                                  controller: verticalLeft,
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                      children: not.lists!.asMap().
                                      map((i, value) => MapEntry(
                                          i,InkWell(
                                        onTap: (){

                                          //setState(() {});
                                        },
                                        child:  Container(
                                          alignment:Alignment.centerLeft,
                                          padding:  EdgeInsets.only(left: 10,top: 7),
                                         // margin: EdgeInsets.only(bottom:i==widget.gridData!.length-1?70: 0),
                                          decoration: BoxDecoration(
                                            border: gridBottomborder,
                                           // color: widget.selectedUid==value['Uid']?yellowColor:gridBodyBgColor,

                                          ),
                                          height: 50,
                                          width: 150,
                                          child: SingleChildScrollView(
                                            child: Text("${value['ExpenseName']}",
                                              style:gridValueTS,
                                            ),
                                          ),
                                        ),
                                      )
                                      )
                                      ).values.toList()



                                  ),
                                ),


                              ),
                            ),
                          ],
                        ),
                      ),






                    ],
                  )

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
                      siteList: siteLists,
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
