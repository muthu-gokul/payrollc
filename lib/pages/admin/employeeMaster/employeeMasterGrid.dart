import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/employeeMaster/employeeMasterAddNEw.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/editDelete.dart';
import 'package:cybertech/widgets/grid/reportDataTableWithoutModel.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:firebase_database/firebase_database.dart';
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
  bool showEdit=false;
  List<ReportGridStyleModel2> reportsGridColumnNameList=[
    ReportGridStyleModel2(columnName: "Name"),
    ReportGridStyleModel2(columnName: "Email"),
    ReportGridStyleModel2(columnName: "UserGroupName"),
  ];



  @override
  void initState() {
    dbRef.onValue.listen((event) {
      lists.clear();

      DataSnapshot dataValues = event.snapshot;
      Map<dynamic, dynamic> values = dataValues.value;
      print("LIST CLESR $values");
      values.forEach((key, values) {
        setState(() {
          lists.add(values);
        });

      });

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
            /*StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();

                    DataSnapshot dataValues = snapshot.data!.snapshot;
                    Map<dynamic, dynamic> values = dataValues.value;
                    print("LIST CLESR $values");
                    values.forEach((key, values) {
                      lists.add(values);
                    });

                   *//* Map<dynamic, dynamic> values = snapshot.data!.value;
                    values.forEach((key, values) {
                      lists.add(values);
                    });*//*
                    return ReportDataTable2(
                      topMargin: 50,
                      gridBodyReduceHeight: 140,
                      selectedIndex: selectedIndex,
                      gridData: lists,
                      gridDataRowList: reportsGridColumnNameList,
                      func: (index){
                         if(selectedIndex==index){
                            setState(() {
                              selectedIndex=-1;
                              showEdit=false;
                            });

                          }
                          else{
                            setState(() {
                              selectedIndex=index;
                              showEdit=true;
                            });
                          }
                      },
                    );
                   *//* return new ListView.builder(
                        shrinkWrap: true,
                        itemCount: lists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Name: " + lists[index]["Name"]),
                                Text("Age: "+ lists[index]["Email"]),
                                Text("Type: " +lists[index]["UserGroupName"]),
                              ],
                            ),
                          );
                        });*//*
                  }
                  return Container(
                    height: SizeConfig.screenHeight,
                      width: SizeConfig.screenWidth,
                      child: Center(child: CircularProgressIndicator())
                  );
                }),*/
            ReportDataTable2(
              topMargin: 50,
              gridBodyReduceHeight: 140,
              selectedIndex: selectedIndex,
              gridData: lists,
              gridDataRowList: reportsGridColumnNameList,
              func: (index){
                if(selectedIndex==index){
                  setState(() {
                    selectedIndex=-1;
                    showEdit=false;
                  });

                }
                else{
                  setState(() {
                    selectedIndex=index;
                    showEdit=true;
                  });
                }
              },
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
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>EmployeeMasterAddNew()));
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
