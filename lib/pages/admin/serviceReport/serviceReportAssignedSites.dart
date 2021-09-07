
import 'dart:developer';
import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/serviceReport/serviceReportSiteDetail.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/arrowBack.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:flutter/material.dart';



class ServiceReportAssignedSites extends StatefulWidget {

  List<dynamic> siteList;
  Map siteListWorkStatus;
  dynamic employeeDetail;
  String date;
  ServiceReportAssignedSites({required this.siteList,required this.employeeDetail,required this.date,
  required this.siteListWorkStatus});

  @override
  _ServiceReportAssignedSitesState createState() => _ServiceReportAssignedSitesState();
}

class _ServiceReportAssignedSitesState extends State<ServiceReportAssignedSites> {
  ScrollController? silverController;
  double silverBodyTopMargin=0;
  List<DateTime?> picked=[];
  int selIndex=-1;

  bool isLoad=false;
  bool userGroupOpen=false;

  int? userGroupId=null;
  String? userGroupName=null;






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
                  Text("Assigned Sites for ${widget.employeeDetail['Name']} ${widget.date}",
                    style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                  ),
                  SizedBox(width: 20,)
                ],
              ),
            ),
            Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight!-100,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: 50),
                //  margin: EdgeInsets.only(top: silverBodyTopMargin),
                 padding: EdgeInsets.only(bottom: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  color: gridBodyBgColor,
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    children: widget.siteList.asMap().map((key,value)=>MapEntry(key,
                        value['IsAdd']?Container(
                          height: 180,
                          width: SizeConfig.screenWidth!*0.5,
                          alignment: Alignment.center,
                      //    margin: EdgeInsets.fromLTRB(0,0,0,key==widget.siteList.length-1?70:0),
                          child: Container(
                    height: 160,
                    width: SizeConfig.screenWidth!*0.45,

                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Text("${value['SiteName']}",style: gridTextColor14,textAlign: TextAlign.center,),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: Text(widget.siteListWorkStatus[value['Key']]['WorkCompleteCount']>widget.siteListWorkStatus[value['Key']]['WorkInCompleteCount']?
                                "Complete":"InComplete",
                                style: TextStyle(fontFamily: 'RR',color: widget.siteListWorkStatus[value['Key']]['WorkCompleteCount']>widget.siteListWorkStatus[value['Key']]['WorkInCompleteCount']?Colors.green:Colors.red,fontSize: 16),textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                log("${value}");
                                if(value['SiteLoginTime']==null){
                                  CustomAlert().cupertinoAlertDialog(context,"Not Yet Logged In...");
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ServiceReportSiteDetail(siteDetail: value)));
                                }

                              },
                              child: Container(
                                height: 40,
                                width: SizeConfig.screenWidth!*0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: bgColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: bgColor.withOpacity(0.15),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(1, 8),
                                      )// changes position of shadow
                                    ]
                                ),
                                child: Center(
                                  child: Text("View",
                                    style:TextStyle(fontFamily: 'RR',color: Colors.white,fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                      ),
                    ),
                  ):Container(width: 0,height: 0,))).values.toList()
                  ),
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
                      Navigator.pop(context);
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