import 'dart:convert';
import 'dart:developer';

import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/expenseReport/expenseReportPdf.dart';
import 'package:cybertech/pages/admin/expenseReport/expensesReportInnerList.dart';
import 'package:cybertech/pages/admin/serviceReport/serviceReportAssignedSites.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/grid/gridWithWidgetParam.dart';
import 'package:cybertech/widgets/grid/reportDataTableWithoutModel.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:cybertech/widgets/noData.dart';
import 'package:cybertech/widgets/singleDatePicker.dart';
import 'package:http/http.dart' as http;import 'package:flutter/material.dart';
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
  bool showShimmer=false;
  bool load=false;
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
    setState(() {
      date=DateTime.now();

    });

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
    setState(() {
      showShimmer=true;
    });
    dbRef.child(DateFormat(dbDateFormat).format(date!)).once().then((value){
    //  log("EXPENSES ${value.value}");
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
        setState(() {
          showShimmer=false;
        });
      }
      else{
        setState(() {
          showShimmer=false;
        });
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
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ExpenseReportDetailView(
                            expensesList: value['ExpensesList'],
                            date: DateFormat(dbDateFormat).format(date!),
                            uid: value['UserDetail']['Uid'],
                            voidCallback: (){
                              getData(date);
                            },
                        )));
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
                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          GestureDetector(
                              onTap:() async {
                               //   log("$lists");
                                print("main start");

                               int i=0,j=0;
                               setState(() {
                               //  load=true;
                               });

                               await Future.forEach(lists, (element) async{
                                  Map temp= element as Map;
                                  print(temp);
                                  i=0;
                                  temp['ExpensesList'].forEach((key,v) async {
                                    print("GG");
                                    v['Img']=[];
                                    i=i+int.parse((v['Images'].length).toString());
                                    j=0;
                                    await  Future.forEach(v['Images'], (ele) async {
                                      print("I $i");
                                   //   var res= await http.get(Uri.parse(ele.toString()));
                                      print("HH");
                                      j++;
                                      print("J $j");
                                    //  v['Img'].add(res.bodyBytes);
                                      if(i==j){
                                        setState(() {
                                     //     load=false;
                                        });
                              //          log("DATA $lists");
                                       // checkpdf(context, DateFormat("dd/MM/yyyy").format(date!),lists);
                                      }
                                    });
                                  });

                                });

                                checkpdf(context, DateFormat("dd/MM/yyyy").format(date!),lists);

                                  // lists.forEach((element) {
                                  //   print("hh");
                                  //         element['ExpensesList'].forEach((key,v) async {
                                  //           print("GG");
                                  //           v['Img']=[];
                                  //           await asyncOne(v['Images']);
                                  //
                                  //          /* v['Images'].forEach((e)  async{
                                  //             var res= await http.get(Uri.parse(e));
                                  //             print("HH");
                                  //             v['Img'].add(res.bodyBytes);
                                  //           });*/
                                  //
                                  //         });
                                  // });

                                  // img().then((value){
                                  //   print("VALUE $value");
                                  // });

                                /*  print("asyncOne start");
                                  await Future.forEach([1, 2, 3], (num) async {
                                    print("asyncTwo start $num");
                                    await Future.forEach([1, 2, 3], (num) async {
                                       print("asyncThree #${num}");
                                    });
                                    print("asyncTwo end $num");
                                  });
                                  print("asyncOne end");*/


                           //       await asyncOne();
                                  print("main end");
                              //    log("LIST $lists");
                                  //checkpdf(context, DateFormat("dd/MM/yyyy").format(date!),lists);
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

            lists.isEmpty?NoData():Container(),
            showShimmer?ShimmerWidget():Container(),
            Loader(
              isLoad: load,
            )
          ],
        ),
      ),
    );
  }

 //  asyncOne(List images) async {
 //    print("asyncOne start");
 //    await Future.forEach(images, (num) async {
 //      await asyncTwo(num);
 //    });
 //    print("assyncOne end");
 //  }
 //
 // Future<dynamic> asyncTwo(num) async
 //  {
 //    var res= await http.get(Uri.parse(num));
 //    print("asyncTwo #${num}");
 //    return res.bodyBytes;
 //    //print("asyncTwo #${num}");
 //  }
  asyncOne() async {
    print("asyncOne start");
    await Future.forEach([1, 2, 3], (num) async {
      await asyncTwo(num);
    });
    print("asyncOne end");
  }

  asyncTwo(num) async {
    print("asyncTwo start $num");
    await Future.forEach([1, 2, 3], (num) async {
      await asyncThree(num);
    });
    print("asyncTwo end $num");
  }

  asyncThree(num) async
  {
    print("asyncThree #${num}");
  }

 Future<dynamic> img() async{
    lists.forEach((element) {
      print("hh");
      element['ExpensesList'].forEach((key,v) async {
        print("GG");
        v['Img']=[];
        await Future.forEach(v['Images'], (e) async {
          print("EE $e");
          var res= await http.get(Uri.parse(e.toString()));
          print("HH");
          setState(() {
            v['Img'].add(res.bodyBytes);
          });
        });
   /*     await v['Images'].forEach((e)  async{
          var res= await http.get(Uri.parse(e));
          print("HH");
          setState(() {
            v['Img'].add(res.bodyBytes);
          });

        });*/
      });
    });
    return true;
  }

}
