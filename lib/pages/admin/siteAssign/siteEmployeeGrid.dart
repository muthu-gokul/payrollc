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

class SiteEmployeeGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  SiteEmployeeGrid({required this.drawerCallback});

  @override
  _SiteEmployeeGridState createState() => _SiteEmployeeGridState();
}

class _SiteEmployeeGridState extends State<SiteEmployeeGrid> {
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
                  Text("  Assign Site - ${DateFormat("dd/MM/yyyy").format(date!)}",
                    style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () async{
                        final DateTime? picked = await showDatePicker2(
                            context: context,
                            initialDate:  date==null?DateTime.now():date!, // Refer step 1
                            firstDate: DateTime.now(),
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
              func: (uid,value){

                if(selectedUid==uid){
                  setState(() {
                    selectedUid="";
                    selectedValue={};
                    showEdit=false;
                  });

                }
                else{

                  print(value);
                  List<dynamic> empSites=[];
                  siteList.forEach((element) {
                    setState(() {
                      element['IsAdd']=false;
                      element['Name']=value['Name'];
                      empSites.add(element);
                    });

                  });


                  dbRef3.child(DateFormat("dd-MM-yyyy").format(date!)).orderByKey().equalTo(value['Uid']).once().then((v){
                    print(v.value);
                   if(v.value!=null){
                     //empSites=v.value[value['Uid']];
                     empSites.forEach((element) {
                       v.value[value['Uid']].forEach((ele) {
                         if(element['Key']==ele['Key']){
                           setState(() {
                             element['IsAdd']=ele['IsAdd'];
                           });

                         }
                       });
                     });
                     print(empSites);
                   }
                   else{
                    // empSites=siteList;
                   }
                   Navigator.push(context, MaterialPageRoute(builder: (ctx)=>SiteAssignPage(
                      siteList: empSites,employeeDetail: value,
                      date: date==null?DateFormat("dd-MM-yyyy").format(DateTime.now()):
                      DateFormat("dd-MM-yyyy").format(date!),
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
