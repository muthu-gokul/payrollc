import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/serviceReport/serviceReportAssignedSites.dart';
import 'package:cybertech/widgets/grid/reportDataTableWithoutModel.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:cybertech/widgets/singleDatePicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ServiceReportEmployeeList extends StatefulWidget {
  VoidCallback drawerCallback;
  ServiceReportEmployeeList({required this.drawerCallback});

  @override
  _ServiceReportEmployeeListState createState() => _ServiceReportEmployeeListState();
}

class _ServiceReportEmployeeListState extends State<ServiceReportEmployeeList> {
  final dbRef = databaseReference.child("Users").orderByChild("UserGroupId").equalTo(2);
  final dbRef2 =databaseReference.child("SiteDetail");
  final dbRef3 = databaseReference.child("SiteAssign");
  List<dynamic> lists=[];
  List<dynamic> siteList=[];
  //List<dynamic> siteList2=[];
  Map siteList2={};
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
    dbRef2.onValue.listen((event) {
      siteList.clear();
      DataSnapshot dataValues = event.snapshot;
      Map<dynamic, dynamic> values = dataValues.value;
      values.forEach((key, values) {
        setState(() {
          values['Key']=key;
          siteList.add(values);
        });
      });
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
                  Text("  Service Report - ${DateFormat("dd/MM/yyyy").format(date!)}",
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
                      },
                      child: SvgPicture.asset("assets/svg/calender.svg",color: Colors.white,height: 30,)
                  ),
                  SizedBox(width: 10,)
                ],
              ),
            ),
            ReportDataTable2(
              topMargin: 55,
              gridBodyReduceHeight: 150,
              selectedIndex: selectedIndex,
              selectedUid: selectedUid,
              gridData: lists,
              gridDataRowList: reportsGridColumnNameList,
              func: (uid,value) async {

                if(selectedUid==uid){
                  setState(() {
                    selectedUid="";
                    selectedValue={};
                    showEdit=false;
                  });

                }
                else{

                //s  print(value);
                  List<dynamic> empSites=[];
                  siteList2.clear();
                  siteList.forEach((element) {
                    setState(() {
                      element['IsAdd']=false;
                      element['Name']=value['Name'];
                      empSites.add(element);
                      siteList2[element['Key']]={
                        'WorkCompleteCount':0,
                        'WorkInCompleteCount':0,
                      };
                     // siteList2.add(element);
                    });
                  });

                 await dbRef3.child(DateFormat(dbDateFormat).format(date!)).once().then((value){
                  //  log("Site Detail ${value.value}");
                    if(value.value!=null){
                      value.value.forEach((key,value){
                        siteList2.forEach((id,element) {
                        //  print(id);
                          List<dynamic> tempSite=[];
                          tempSite=value.where((e)=>e['Key']==id).toList();
                          if(tempSite.isNotEmpty){
                            dynamic i;
                            i=tempSite[0]['WorkComplete'];
                            if(i!=null){
                              if(i){
                                setState(() {
                                  element['WorkCompleteCount']=element['WorkCompleteCount']+1;
                                });
                              }
                              else{
                                setState(() {
                                  element['WorkInCompleteCount']=element['WorkInCompleteCount']+1;
                                });
                              }
                            }
                          }

                        });
                      });
                    }
                  });

               //  log("siteList2 $siteList2");
                 print("siteList2 ${siteList2.length}");

                  dbRef3.child(DateFormat(dbDateFormat).format(date!)).orderByKey().equalTo(value['Uid']).once().then((v){
                  //  print("v.value ${v.value}");
                    if(v.value!=null){
                      //empSites=v.value[value['Uid']];
                      empSites.forEach((element) {
                        v.value[value['Uid']].forEach((ele) {
                          if(element['Key']==ele['Key']){
                            setState(() {
                              element['Images']=ele['Images'];
                              element['IsAdd']=ele['IsAdd'];
                              element['SiteLoginTime']=ele['SiteLoginTime'];
                              element['SiteLoginAddress']=ele['SiteLoginAddress'];
                              element['SiteLoginLatitude']=ele['SiteLoginLatitude'];
                              element['SiteLoginLongitude']=ele['SiteLoginLongitude'];
                              element['SiteLogoutTime']=ele['SiteLogoutTime'];
                              element['SiteLogoutAddress']=ele['SiteLogoutAddress'];
                              element['SiteLogoutLatitude']=ele['SiteLogoutLatitude'];
                              element['SiteLogoutLongitude']=ele['SiteLogoutLongitude'];
                              element['Remarks']=ele['Remarks'];
                              element['WorkComplete']=ele['WorkComplete'];
                            });
                          }
                        });
                      });
                    //  log("empSites $empSites");
                    }
                    else{
                      // empSites=siteList;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ServiceReportAssignedSites(
                      siteList: empSites,
                      employeeDetail: value,
                      siteListWorkStatus: siteList2,
                      date: date==null?DateFormat(dbDateFormat).format(DateTime.now()):
                      DateFormat(dbDateFormat).format(date!),
                    )
                    )
                    );
                  });




                  /* setState(() {
                    selectedUid=uid;
                    selectedValue=value;
                  //  showEdit=true;
                  });*/


                }
              },
            ),


          ],
        ),
      ),
    );
  }
}
