import 'dart:async';

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
import 'package:flutter/material.dart';

class SiteMasterGrid extends StatefulWidget {
  VoidCallback drawerCallback;
  SiteMasterGrid({required this.drawerCallback});

  @override
  _SiteMasterGridState createState() => _SiteMasterGridState();
}

class _SiteMasterGridState extends State<SiteMasterGrid> {
  final dbRef = FirebaseDatabase.instance.reference().child("SiteDetail");
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
                  Text("  Site Master",
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

            Container(
              height: SizeConfig.screenHeight!-110,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(top: 110),
              child: lists.isEmpty? Text("No Data"):ListView.builder(
                itemCount: lists.length,
                itemBuilder: (ctx,i){
                  return  Container(
                    height: 50,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.only(left: 5,right: 5),
                    decoration: BoxDecoration(
                       // color: Colors.white,
                       // borderRadius: BorderRadius.circular(5),
                     //   border: Border.all(color: addNewTextFieldBorder)
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 70,
                          alignment: Alignment.center,
                          child: Text("${i+1}",style: gridTextColor14,),
                        ),
                        Container(
                          height: 50,
                          width: SizeConfig.screenWidth!-82,
                          alignment: Alignment.centerLeft,
                          child: Text("${lists[i]['SiteName']}",style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 15),),
                        )
                      ],
                    ),
                  );
                },
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
                    setState(() {
                      addSiteOpen=true;
                    });
                  },
                  image: "assets/svg/plusIcon.svg",
                )
            ),


            Container(

              height: addSiteOpen ? SizeConfig.screenHeight:0,
              width: addSiteOpen ? SizeConfig.screenWidth:0,
              color: Colors.black.withOpacity(0.5),

            ),

            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.only(left: SizeConfig.width30!,right: SizeConfig.width30!),
                  transform: Matrix4.translationValues(addSiteOpen?0:SizeConfig.screenWidth!, 0, 0),

                  child:Container(
                    height:300,
                    width: SizeConfig.screenWidth,
                    color: Colors.white,
                    //  padding: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20,bottom: SizeConfig.height10),
                    child:Column (
                        children: [
                          SizedBox(height: 20,),
                          Image.asset("assets/images/nav/building.png",height: 70,),
                          SizedBox(height: 20,),
                          Container(
                            height: 50,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child:Container(
                                    height: 50,
                                    width: SizeConfig.screenWidth,
                                    margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        /*      border: Border.all(color: AppTheme.addNewTextFieldBorder),*/
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 15,
                                            offset: Offset(0, 0), // changes position of shadow
                                          )
                                        ]
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 20),
                                          width: SizeConfig.screenWidth!*0.62,
                                          child: TextField(
                                            controller: siteName,
                                            style:  TextStyle(fontFamily: 'RR',fontSize: 15,color:grey,letterSpacing: 0.2),
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                hintText: "Site Name",
                                                hintStyle: hintText
                                            ),

                                            // keyboardType: otherChargesTextFieldOpen?TextInputType.number:TextInputType.text,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          GestureDetector(
                            onTap: (){
                              node.unfocus();
                              dbRef.push().set({
                                'SiteName':siteName.text
                              });
                              setState(() {
                                addSiteOpen=false;
                                siteName.clear();
                              });


                            },
                            child: Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: yellowColor
                              ),
                              child: Center(
                                child: Text("Done",style:TextStyle(fontFamily: 'RR',color: Colors.white,fontSize: 20),),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              node.unfocus();
                              Timer(Duration(milliseconds: 100), (){
                                setState(() {
                                  addSiteOpen=false;
                                  siteName.clear();
                                });
                              });


                            },
                            child: Container(
                              height: 50,
                              width: 150,
                              child: Center(
                                child: Text("Cancel",style: TextStyle(fontFamily: 'RL',fontSize: 20,color: Color(0xFFA1A1A1))),
                              ),
                            ),
                          ),




                        ]


                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
