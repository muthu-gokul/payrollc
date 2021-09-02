import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/arrowBack.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/closeButton.dart';
import 'package:cybertech/widgets/customTextField.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:cybertech/widgets/sidePopUpParent.dart';
import 'package:cybertech/widgets/sidePopupWithoutModelList.dart';
import 'package:cybertech/widgets/validationErrorText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class SiteAssignPage extends StatefulWidget {

  dynamic siteList;
  dynamic employeeDetail;
  String date;
  SiteAssignPage({required this.siteList,required this.employeeDetail,required this.date});

  @override
  _SiteAssignPageState createState() => _SiteAssignPageState();
}

class _SiteAssignPageState extends State<SiteAssignPage> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;
  List<DateTime?> picked=[];
  int selIndex=-1;

  bool isLoad=false;
  bool userGroupOpen=false;

  int? userGroupId=null;
  String? userGroupName=null;

  final databaseReference = FirebaseDatabase.instance.reference();




  @override
  void initState() {

    WidgetsBinding.instance!.addPostFrameCallback((_){
      silverController=new ScrollController();

      setState(() {
        silverBodyTopMargin=0;
      });
      silverController!.addListener(() {
        if(silverController!.offset>150){
          setState(() {
            silverBodyTopMargin=50-(-(silverController!.offset-200));
            if(silverBodyTopMargin<0){
              silverBodyTopMargin=0;
            }
          });
        }
        else if(silverController!.offset<170){
          setState(() {
            silverBodyTopMargin=0;
          });
        }
      });
    });
/*    widget.siteList.forEach((ele){
      setState(() {
        ele['IsAdd']=false;
      });
    });*/
    super.initState();
  }
  AuthenticationHelper authenticationHelper=new AuthenticationHelper();
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            NestedScrollView(
             controller: silverController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    toolbarHeight: 50,
                    backgroundColor: bgColor,
                    leading: Container(),
                    actions: [
                      Container(
                        height: 50,
                        width:SizeConfig.screenWidth,
                        child: Row(
                          children: [
                            /* CancelButton(
                                ontap: (){
                                  Navigator.pop(context);
                                },
                              ),*/
                            ArrowBack(

                              ontap: (){
                                Navigator.pop(context);
                              },
                              iconColor: Colors.white,
                            ),
                            Text("Site Select for ${widget.employeeDetail['Name']} ${widget.date}",
                              style: TextStyle(fontFamily: 'RR',fontSize: 16),
                            ),


                            SizedBox(width: 20,)
                          ],
                        ),
                      ),
                    ],
                    expandedHeight: 0.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          color:bgColor,
                          width: SizeConfig.screenWidth,
                      //    margin:EdgeInsets.only(top: 55),

                        )
                    ),
                  ),
                ];
              },
              body: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight!-55,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: 0),
              //  margin: EdgeInsets.only(top: silverBodyTopMargin),
                // padding: EdgeInsets.only(top: 50,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  color: Color(0xFFF6F7F9),
                ),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      height: 50,
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.only(left: 5,right: 5,top: 5),
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
                        height: SizeConfig.screenHeight!-155,
                        child: ListView.builder(
                      itemCount: widget.siteList.length,

                      itemBuilder: (ctx,i){
                        return  GestureDetector(
                          onTap: (){
                            //SiteLoginTime
                            if(widget.siteList![i]['SiteLoginTime']==null){
                              setState(() {
                                widget.siteList![i]['IsAdd']=!widget.siteList![i]['IsAdd'];
                              });
                            }
                            else{
                              CustomAlert().commonErrorAlert2(context, "Logged In", "User has Logged in Site. You cant change");
                            }

                          },
                          child: Container(
                            height: 50,
                            width: SizeConfig.screenWidth,
                            margin: EdgeInsets.only(left: 5,right: 5,bottom: i==widget.siteList.length?60:0),
                            decoration: BoxDecoration(
                               color: Colors.transparent,
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
                                  width: SizeConfig.screenWidth!-110,
                                  alignment: Alignment.centerLeft,
                                  child: Text("${widget.siteList[i]['SiteName']}",style: gridTextColor14,),
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color:widget.siteList![i]['IsAdd']?Colors.transparent: addNewTextFieldBorder.withOpacity(0.5)),
                                      color:widget.siteList![i]['IsAdd']?yellowColor: disableColor
                                  ),
                                  child: Center(
                                    child: Icon(Icons.done,color:widget.siteList![i]['IsAdd']?Colors.white: addNewTextFieldBorder.withOpacity(0.8),size: 15,),
                                  ),

                                )
                              ],
                            ),
                          ),
                        );
                      },
                      )
                    )
                  ],
                ),


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
                    List<dynamic> temp=widget.siteList.where((ele)=>ele['IsAdd']==true).toList();

                    if(widget.siteList.isNotEmpty){
                      print(temp);
                      databaseReference.child("SiteAssign").child(widget.date).child(widget.employeeDetail['Uid']).set(temp);
                      Navigator.pop(context);
                    }
                    else{
                      Navigator.pop(context);
                    }
                  },
                )
            ),
            Loader(
              isLoad: isLoad,
            ),


            Container(

              height: userGroupOpen ? SizeConfig.screenHeight:0,
              width: userGroupOpen ? SizeConfig.screenWidth:0,
              color: Colors.black.withOpacity(0.5),

            ),

          ],
        ),
      ),
    );
  }
}


class UserGroupModel{
  int userGroupId;
  String userGroup;
  UserGroupModel({required this.userGroup,required this.userGroupId});
}