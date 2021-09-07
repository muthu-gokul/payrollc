import 'package:cached_network_image/cached_network_image.dart';
import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/widgets/arrowBack.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceReportSiteDetail extends StatefulWidget {

  Map siteDetail;

  ServiceReportSiteDetail({required this.siteDetail});

  @override
  _ServiceReportSiteDetailState createState() => _ServiceReportSiteDetailState();
}

class _ServiceReportSiteDetailState extends State<ServiceReportSiteDetail> {

  List<DateTime?> picked=[];
  int selIndex=-1;

  bool isLoad=false;
  bool userGroupOpen=false;

  int? userGroupId=null;
  String? userGroupName=null;






  @override
  void initState() {

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
                  ArrowBack(

                    ontap: (){
                      Navigator.pop(context);
                    },
                    iconColor: Colors.white,
                  ),
                  Text("Site Detail",
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
                // padding: EdgeInsets.only(top: 50,bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                  color: gridBodyBgColor,
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 15,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(" Site Name:",
                            style: TextStyle(fontFamily: 'RM',color: grey,fontSize: 15)
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.only(left: 20,right: 20),
                        alignment: Alignment.centerLeft,
                        child: Text("${widget.siteDetail['SiteName']}",
                          style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 14),
                        ),
                      ),

                      SizedBox(height: 15,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(" Site Login Details:",
                            style: TextStyle(fontFamily: 'RM',color: grey,fontSize: 15)
                        ),
                      ),
                      SizedBox(height: 8,),
                      CustomListTile2WithBg(
                          leading: Icon(Icons.timer,size: 17,),
                          text: DateFormat.jms().format(DateTime.parse(widget.siteDetail['SiteLoginTime']))
                      ),
                      SizedBox(height: 8,),
                      CustomListTile2(
                          leading: Icon(Icons.location_on_outlined,size: 20,color: Colors.red,),
                          text: widget.siteDetail['SiteLoginAddress']??""
                      ),


                      widget.siteDetail['SiteLogoutTime']==null?Container(): Column(
                        children: [
                          SizedBox(height: 15,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(" Site Logout Details:",
                                style: TextStyle(fontFamily: 'RM',color: grey,fontSize: 15)
                            ),
                          ),
                          SizedBox(height: 8,),
                          CustomListTile2WithBg(
                              leading: Icon(Icons.timer,size: 17,),
                              text: DateFormat.jms().format(DateTime.parse(widget.siteDetail['SiteLogoutTime']))
                          ),
                          SizedBox(height: 8,),
                          CustomListTile2(
                              leading: Icon(Icons.location_on_outlined,size: 20,color: Colors.red,),
                              text: widget.siteDetail['SiteLogoutAddress']
                          ),
                          SizedBox(height: 20,),
                          widget.siteDetail['WorkComplete']==null?Container(): Container(
                            height: 30,
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.only(left: 5,right: SizeConfig.width20!),
                            child: Row(
                              children: [

                                Checkbox(
                                    fillColor: MaterialStateColor.resolveWith((states) => yellowColor),
                                    value:  widget.siteDetail['WorkComplete'],
                                    onChanged: (v){

                                    }
                                ),
                                Text("Work Complete",
                                  style:  TextStyle(fontFamily: 'RR',fontSize: 16,color:grey,letterSpacing: 0.2),),
                                Spacer(),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          CustomListTile2(
                              leading: Icon(Icons.assignment,size: 20,color: Colors.red,),
                              text: widget.siteDetail['Remarks'].isEmpty?"No Remarks":widget.siteDetail['Remarks']
                          ),
                         // SizedBox(height: 10,),
                          widget.siteDetail['Images']==null?Container():Container(
                            height: 220,
                            margin: EdgeInsets.all(10),
                           child: ListView.builder(
                             scrollDirection: Axis.horizontal,
                             physics: BouncingScrollPhysics(),
                             itemCount: widget.siteDetail['Images'].length,
                             itemBuilder: (ctx,i){
                               return Container(
                                 margin: EdgeInsets.all(10),

                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(17),
                                   child: CachedNetworkImage(
                                     imageUrl: widget.siteDetail['Images'][i],
                                     placeholder: (context,url) => CupertinoActivityIndicator(
                                       radius: 20,
                                       animating: true,
                                     ),
                                     errorWidget: (context,url,error) => new Icon(Icons.error),
                                   ),
                                 ),
                               );
                             },
                           ),

                          ),
                          SizedBox(height: 70,),
                        ],
                      )

                    ],
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

class CustomListTile2 extends StatelessWidget {
  Widget leading;
  String text;
  CustomListTile2({required this.leading,required this.text});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.only(left: 20,right: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          SizedBox(width: 10,),
          Container(
            width: SizeConfig.screenWidth!-80,
            child: Text("$text",
              style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
class CustomListTile2WithBg extends StatelessWidget {
  Widget leading;
  String text;
  CustomListTile2WithBg({required this.leading,required this.text});

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 150,
        padding: EdgeInsets.only(left: 10,right: 20,top: 3,bottom: 3),
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey[300],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            SizedBox(width: 10,),
            Container(
          //    width: SizeConfig.screenWidth!-80,
              child: Text("$text",
                style: TextStyle(fontFamily: 'RR',color: grey,fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
