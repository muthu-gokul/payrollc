import 'dart:developer';

import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/expenseReport/expensesReportInnerList.dart';
import 'package:cybertech/pages/admin/serviceReport/serviceReportAssignedSites.dart';
import 'package:cybertech/widgets/grid/gridWithWidgetParam.dart';
import 'package:cybertech/widgets/grid/reportDataTableWithoutModel.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:cybertech/widgets/singleDatePicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ExpenseReportEmployeeList extends StatefulWidget {
  VoidCallback drawerCallback;
  ExpenseReportEmployeeList({required this.drawerCallback});

  @override
  _ExpenseReportEmployeeListState createState() => _ExpenseReportEmployeeListState();
}

class _ExpenseReportEmployeeListState extends State<ExpenseReportEmployeeList> {
  final dbRef = databaseReference.child("Expenses");


  List<dynamic> lists=[];

  //List<dynamic> siteList2=[];
  Map siteList2={};
  Map data={};
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
   getData(date);
/*    dbRef.onValue.listen((event) {
      lists.clear();
      DataSnapshot dataValues = event.snapshot;
      Map<dynamic, dynamic> values = dataValues.value;
      print("LIST CLESR $values");
      values.forEach((key, values) {
        setState(() {
          lists.add(values);
        });
      });
    });*/


    super.initState();
  }

  getData(DateTime? date){
    dbRef.child(DateFormat(dbDateFormat).format(date!)).once().then((value){
      log("EXPENSES ${value.value}");
      lists.clear();
      data.clear();
      if(value.value!=null){
        setState(() {
          data=value.value;
        });
        value.value.forEach((key,v){
          setState(() {
            lists.add(v);
          });
        });

      }
      else{

      }
    });
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
                  Text("  Expense Report - ${DateFormat("dd/MM/yyyy").format(date!)}",
                    style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () async{
                        final DateTime? picked = await showDatePicker2(
                            context: context,
                            initialDate:  date==null?DateTime.now():date!, // Refer step 1
                            //firstDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context,Widget? child){
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: yellowColor, // header background color
                                    onPrimary: Colors.white, // header text color
                                    onSurface: grey, // body text color
                                  ),
                                ),
                                child: child!,
                              );
                            });
                        if (picked != null)
                          setState(() {
                            date = picked;
                          });
                        getData(date);
                      },
                      child: SvgPicture.asset("assets/svg/calender.svg",color: Colors.white,height: 30,)
                  ),
                  SizedBox(width: 10,)
                ],
              ),
            ),

            GridWithWidgetParam(
                topMargin: 50,
                gridBodyReduceHeight: 150,
                leftHeader: "Name",
                leftBody:  Column(
                    children: lists.asMap().
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
                                child: Text("${value['UserDetail']['Name']}",
                                  style:gridTextColor14,
                                ),
                              ),
                            ),
                         )
                       )
                    ).values.toList()
                ),
                rightHeader: Row(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10),
                        width: 150,
                        child: Text("No.of Expenses",
                          style: gridHeaderTS,)
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10),
                        width: 150,
                        child: Text("Email",
                          style: gridHeaderTS,)
                    ),

                  ],
                ),
                rightBody: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:lists.asMap().
                    map((i, value) => MapEntry(
                        i,InkWell(
                      onTap: (){
                        print(value);
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ExpenseReportDetailView(expensesList: value['ExpensesList'])));
                        //setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: gridBottomborder,
                          //   color: widget.selectedUid==value['Uid']?yellowColor:gridBodyBgColor,
                        ),
                        height: 50,
                        margin: EdgeInsets.only(bottom:i==lists.length-1?70: 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment:Alignment.center,
                                decoration: BoxDecoration(
                                  border: gridBottomborder,
                                ),
                                height: 50,
                                width: 150,
                                child: Text("${value['ExpensesList'].length}",
                                  style:gridTextColor14,
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
                                child: Text("${value['UserDetail']['Email']}",
                                  style:gridTextColor14,
                                ),
                              ),


                            ]
                        ),
                      ),
                    )
                    )
                    ).values.toList()
                )
            ),

            Positioned(
              bottom: 0,
              child: RaisedButton(onPressed: (){
             //   log("${lists}");
                print(lists.length);
                log("${lists[0]}");
                print(data.length);
              }),
            )
          ],
        ),
      ),
    );
  }
}
