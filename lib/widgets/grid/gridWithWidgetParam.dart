import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';



class GridWithWidgetParam extends StatefulWidget {
  

 // int? selectedIndex;
 // String selectedUid;
  double? topMargin;//70 || 50
  double? gridBodyReduceHeight;// 260  // 140

  String leftHeader;
  Widget leftBody;

  Widget rightHeader;
  Widget rightBody;

  GridWithWidgetParam({this.topMargin,this.gridBodyReduceHeight,required this.leftHeader,
  required this.leftBody,required this.rightHeader,required this.rightBody});
  @override
  _GridWithWidgetParamState createState() => _GridWithWidgetParamState();
}

class _GridWithWidgetParamState extends State<GridWithWidgetParam> {


  ScrollController header=new ScrollController();
  ScrollController body=new ScrollController();
  ScrollController verticalLeft=new ScrollController();
  ScrollController verticalRight=new ScrollController();

  bool showShadow=false;





  @override
  void initState() {
    header.addListener(() {
      if(body.offset!=header.offset){
        body.jumpTo(header.offset);
      }
      if(header.offset==0){
        setState(() {
          showShadow=false;
        });
      }
      else{
        if(!showShadow){
          setState(() {
            showShadow=true;
          });
        }
      }
    });

    body.addListener(() {
      if(header.offset!=body.offset){
        header.jumpTo(body.offset);
      }
    });

    verticalLeft.addListener(() {
      if(verticalRight.offset!=verticalLeft.offset){
        verticalRight.jumpTo(verticalLeft.offset);
      }
    });

    verticalRight.addListener(() {
      if(verticalLeft.offset!=verticalRight.offset){
        verticalLeft.jumpTo(verticalRight.offset);
      }
    });
    super.initState();
  }

  late double width;

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    // print("CustomTable");
    // print(widget.gridData);
    // print(gridDataRowList);
    // print(gridCol);
    // print(widget.selectedIndex);
    return Container(
        height: SizeConfig.screenHeight!-widget.topMargin!,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(top: widget.topMargin!),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color:gridBodyBgColor,
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        child: Stack(
          children: [

            //Scrollable
            Positioned(
              left:149,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width-152,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.only(right: 1),
                    decoration:BoxDecoration(
                      color: addNewTextFieldBorder,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                    ),
                    child: Container(
                      height: 50,
                      width: width-152,
                      margin: EdgeInsets.only(right: 1,bottom: 1,top: 1),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                      ),
                      //color: showShadow? bgColor.withOpacity(0.8):bgColor,
                      child: SingleChildScrollView(
                        controller: header,
                        scrollDirection: Axis.horizontal,
                        physics: ClampingScrollPhysics(),
                        child: widget.rightHeader
                      ),

                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight!,
                    width: width-149,
                    alignment: Alignment.topLeft,
                    color: gridBodyBgColor,
                    child: SingleChildScrollView(
                      controller: body,
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight!,
                        alignment: Alignment.topCenter,
                        color:gridBodyBgColor,
                        child: SingleChildScrollView(
                          controller: verticalRight,
                          scrollDirection: Axis.vertical,
                          physics: ClampingScrollPhysics(),
                          child: widget.rightBody,
                        ),


                      ),
                    ),
                  ),
                ],
              ),
            ),


            //not Scrollable
            Positioned(
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:BoxDecoration(
                      color: addNewTextFieldBorder,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)
                      ),
                    ),
                    child: Container(
                      height: 50,
                      width: 145,
                      margin: EdgeInsets.only(left: 1,bottom: 1,top: 1),
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      //   clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                      ),
                      child: FittedBox(child: Text("${widget.leftHeader}",
                        style: TextStyle(fontFamily: 'RR',color: bgColor,fontSize: 16),)),

                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight!,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color:showShadow? gridBodyBgColor:Colors.transparent,
                        boxShadow: [
                          showShadow?  BoxShadow(
                            color: grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(0, -8), // changes position of shadow
                          ):BoxShadow(color: Colors.transparent)
                        ]
                    ),
                    child: Container(
                      height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight!,
                      alignment: Alignment.topCenter,

                      child: SingleChildScrollView(
                        controller: verticalLeft,
                        scrollDirection: Axis.vertical,
                        child: widget.leftBody,
                      ),


                    ),
                  ),
                ],
              ),
            ),


     /*       widget.gridData!.isEmpty?Container(
              width: SizeConfig.screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70,),
                  Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: grey),),
                  SvgPicture.asset("assets/nodata.svg",height: 350,),

                ],
              ),
            ):Container()
*/


          ],
        )

    );
  }
}


