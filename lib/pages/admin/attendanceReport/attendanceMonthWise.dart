
import 'dart:developer';

import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/attendanceReport/attendanceCardViewEmployeeDetails.dart';
import 'package:cybertech/widgets/navigationBarIcon.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'attendanceMonthWiseGrid.dart';


class AttendanceOverView extends StatefulWidget {
  VoidCallback drawerCallback;
  AttendanceOverView({required this.drawerCallback});
  @override
  _AttendanceOverViewState createState() => _AttendanceOverViewState();
}

class _AttendanceOverViewState extends State<AttendanceOverView> {
  GlobalKey <ScaffoldState> scaffoldkey=new GlobalKey<ScaffoldState>();

  late  double width,height,width2;
  List<DateTime> picked=[];
  DateTime? selectedDate;
  final dbRef = FirebaseDatabase.instance.reference().child("Attendance");
  final dbRef2 = FirebaseDatabase.instance.reference().child("Users");

  List<AttendanceMonthGridStyleModel> gridHeaderList=[
    AttendanceMonthGridStyleModel(columnName: "Name"),
/*    AttendanceMonthGridStyleModel(columnName: "1",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "2",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "3",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "4",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "5",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "6",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "7",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "8",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "9",width: attWidth),
    AttendanceMonthGridStyleModel(columnName: "10",width: attWidth),*/
  ];
  List<dynamic> data=[
    {"Employee Name":"Bala","1":"PN","2":"PN","3":"AB","4":"PN","5":"PN","6":"PN","7":"PN","8":"PN","9":"PN","10":"PN",},
    {"Employee Name":"Muthu","1":"PN","2":"PN","3":"AB","4":"PN","5":"AB","6":"PN","7":"PN","8":"PN","9":"PN","10":"PN",},
    {"Employee Name":"Vivek","1":"PN","2":"PN","3":"AB","4":"PN","5":"PN","6":"PN","7":"PN","8":"PN","9":"PN","10":"PN",},
    {"Employee Name":"Ramesh","1":"PN","2":"PN","3":"AB","4":"PN","5":"PN","6":"PN","7":"PN","8":"PN","9":"PN","10":"PN",},
    {"Employee Name":"Rajasekar","1":"PN","2":"PN","3":"AB","4":"PN","5":"PN","6":"PN","7":"PN","8":"PN","9":"PN","10":"PN",},
    {"Employee Name":"Lavanya","1":"PN","2":"PN","3":"AB","4":"PN","5":"PN","6":"PN","7":"PN","8":"PN","9":"PN","10":"PN",},
    {"Employee Name":"Aishwarya","1":"PN","2":"PN","3":"AB","4":"PN","5":"PN","6":"PN","7":"PN","8":"PN","9":"PN","10":"PN",},
    {"Employee Name":"Kalaivanan","1":"PN","2":"PN","3":"AB","4":"PN","5":"PN","6":"PN","7":"PN","8":"PN","9":"PN","10":"PN",},
  ];

  List<dynamic> users=[];
  @override
  void initState() {
    dbRef2.orderByChild('UserGroupId').equalTo(2).once().then((value){
      users.clear();
      if(value.value!=null){
        log("USESRS ${value.value}");
        value.value.forEach((k,v){
          setState(() {
            users.add(v);
          });
        });
      }
    });
    setState(() {
      selectedDate=DateTime.now();
    });
    getAttendance(DateTime(selectedDate!.year, selectedDate!.month, 1));
    super.initState();
  }

  getUsers(DateTime date){
    dbRef2.orderByChild('UserGroupId').equalTo(2).once().then((value){
      users.clear();
      if(value.value!=null){
        log("USESRS ${value.value}");
        value.value.forEach((k,v){
          setState(() {
            users.add(v);
          });
        });
        getAttendance(date);
      }
    });
  }

  getAttendance(DateTime date){
    setState(() {
      picked.clear();
      gridHeaderList.clear();
      gridHeaderList.add( AttendanceMonthGridStyleModel(columnName: "Name"));
      selectedDate = date;
      print(selectedDate!.month==DateTime.now().month);

      var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
      var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
      final List<DateTime> days = [];
      if(selectedDate!.month==DateTime.now().month){
        for (int i = 0; i <= DateTime.now().difference(firstDayThisMonth).inDays; i++) {
          gridHeaderList.add( AttendanceMonthGridStyleModel(
              columnName: DateFormat(dbDateFormat).format(firstDayThisMonth.add(Duration(days: i))),
              isDate: true,width: 50));
          //   days.add(firstDayThisMonth.add(Duration(days: i)));
        }
      }
      else{
        for (int i = 0; i < firstDayNextMonth.difference(firstDayThisMonth).inDays; i++) {
          gridHeaderList.add( AttendanceMonthGridStyleModel(
              columnName: DateFormat(dbDateFormat).format(firstDayThisMonth.add(Duration(days: i))),
              isDate: true,width: 50));
          // days.add(firstDayThisMonth.add(Duration(days: i)));
        }
      }

      log("DATES $days");

      picked.add(selectedDate!);
      picked.add( DateTime(date.year, date.month, firstDayNextMonth.difference(firstDayThisMonth).inDays));

      print(DateFormat(dbDateFormat).format(picked[0]));
      print(DateFormat(dbDateFormat).format(picked[1]));
      dbRef.orderByKey()
          .startAt("${DateFormat(dbDateFormat).format(picked[0])}")
          .endAt("${DateFormat(dbDateFormat).format(picked[1])}")
          .once().then((value){

        if(value.value!=null){
          log("${value.value}");
          log("${value.value.length}");
          value.value.forEach((k,v){
            //  gridHeaderList.add( AttendanceMonthGridStyleModel(columnName: k,isDate: true,width: 50));
            print("KEY $k     VALUE $v");
            users.forEach((element) {
              if(element['Details']==null){
                element['Details']=[];
              }
              if(gridHeaderList.any((element) => element.columnName==k)){
                if(v.containsKey(element['Uid'])){
                  setState(() {
                    element[k]='P';
                    element['Details'].add(
                        {
                          //'$k':'P',
                          'Date':'$k',
                          'Attendance':'P',
                          'LoginTime':v[element['Uid']]['LoginTime'],
                          'LogoutTime':v[element['Uid']]['LogoutTime'],
                          'LoginAddress':v[element['Uid']]['LoginAddress'],
                          'LogoutAddress':v[element['Uid']]['LogoutAddress']
                        }
                    );
                  /*  element['${k}_List']=[
                      {'$k':'P'},
                      {'LoginTime':v[element['Uid']]['LoginTime']},
                      {'LogoutTime':v[element['Uid']]['LogoutTime']},
                      {'LoginAddress':v[element['Uid']]['LoginAddress']},
                      {'LogoutAddress':v[element['Uid']]['LogoutAddress']},
                    ];*/
                  });
                }
                else{
                  setState(() {
                    element[k]='A';
                    element['Details'].add(
                        {
                         // '$k':'A',
                          'Date':'$k',
                          'Attendance':'A',
                        }
                    );
                    /*element['${k}_List']=[
                      {k:'A'},
                     // {'LoginTime':v[element['Uid']]['LoginTime']},
                     // {'LogoutTime':v[element['Uid']]['LogoutTime']},
                     // {'LoginAddress':v[element['Uid']]['LoginAddress']},
                     // {'LogoutAddress':v[element['Uid']]['LogoutAddress']},
                    ];*/
                  });
                }
              }
              else{
                setState(() {
                  element[k]='A';
                  element['Details'].add(
                      {
                        'Date':'$k',
                        'Attendance':'A',
                      }
                  );
                  /*element['Details'].add([
                    {'$k':'A'},
                    // {'LoginTime':v[element['Uid']]['LoginTime']},
                    // {'LogoutTime':v[element['Uid']]['LogoutTime']},
                    // {'LoginAddress':v[element['Uid']]['LoginAddress']},
                    // {'LogoutAddress':v[element['Uid']]['LogoutAddress']},
                  ]);*/
                 /* element['${k}_List']=[
                    {k:'A'},
                    // {'LoginTime':v[element['Uid']]['LoginTime']},
                    // {'LogoutTime':v[element['Uid']]['LogoutTime']},
                    // {'LoginAddress':v[element['Uid']]['LoginAddress']},
                    // {'LogoutAddress':v[element['Uid']]['LogoutAddress']},
                  ];*/
                });
              }

            });
          });
        }

        setState(() {
          data=users;
        });
        log("OUTPUT USERS $users");
      });

    });
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
                    NavBarIcon(
                      ontap: (){
                        widget.drawerCallback();
                      },
                    ),
                    Container(
                      child: Text('   Attendance Report',style: TextStyle(color: Color(0xffffffff),fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'RR'),),
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () async{

                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 10, 1),
                            lastDate: DateTime(DateTime.now().year, DateTime.now().month),
                            initialDate: selectedDate ?? DateTime.now(),
                            locale: Locale("en"),
                          ).then((date) {
                            if (date != null) {
                              print(date);
                              getUsers(date);
                            }
                          });
                        },
                        child: SvgPicture.asset("assets/svg/calender.svg",color: Colors.white,height: 30,)
                    ),
                    SizedBox(width: 10,)
                  ],
                ),
              ),
              Container(
                height: 70,
                color:  Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                    ),
                    Container(
                      width: SizeConfig.screenWidth!*0.65,
                      child: Text('${DateFormat.yMMMM().format(selectedDate!)}',style: TextStyle(fontFamily: 'RB',fontSize: 16,color: Colors.black,),textAlign:TextAlign.center,),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),

              AttendanceMonthGrid (
                voidCallback:(){

                  scaffoldkey.currentState!.openDrawer();
                },
                topMargin: 5,
                gridBodyReduceHeight: 160 ,
                gridData: data,
                gridDataRowList: gridHeaderList,
                func: (i){
                  print("TAP ${data[i]}");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendanceCardViewEmpDetails(
                    details: data[i],
                  )),);
                },
              )
            ],
          ),
        ) ,
      ),
    );
  }
}
