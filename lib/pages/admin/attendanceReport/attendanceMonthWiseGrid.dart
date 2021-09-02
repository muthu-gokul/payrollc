
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';




class AttendanceMonthGridStyleModel{
  String? columnName;
  double width;
  Alignment alignment;
  EdgeInsets edgeInsets;
  bool isActive;
  bool isDate;

  AttendanceMonthGridStyleModel({this.columnName,this.width=150,this.alignment=Alignment.centerLeft,
    this.edgeInsets=const EdgeInsets.only(left: 10),this.isActive=true,this.isDate=false});


  Map<String, dynamic> toJson() => {
    "ColumnName": columnName,

  };

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
}

class AttendanceMonthGrid extends StatefulWidget {

  List<AttendanceMonthGridStyleModel>? gridDataRowList=[];
  List<dynamic>? gridData=[];

  int? selectedIndex;
  VoidCallback? voidCallback;
  Function(int)? func;
  double topMargin;//70 || 50
  double gridBodyReduceHeight;// 260  // 140

  AttendanceMonthGrid({this.gridDataRowList,this.gridData,this.selectedIndex,this.voidCallback,this.func,required this.topMargin,required this.gridBodyReduceHeight});
  @override
  _AttendanceMonthGridState createState() => _AttendanceMonthGridState();
}

class _AttendanceMonthGridState extends State<AttendanceMonthGrid> {


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
        height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight,
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(top: widget.topMargin),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color:attendanceMonthGridBodyBgColor,
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
                        child: Row(
                            children: widget.gridDataRowList!.asMap().
                            map((i, value) => MapEntry(i, i==0?Container():
                            value.isActive?Container(
                                alignment: value.alignment,
                                padding: value.edgeInsets,
                                width: value.width,

                                constraints: BoxConstraints(
                                    minWidth: 50,
                                    maxWidth: 200
                                ),

                                child: FittedBox(child: Text(value.isDate?
                                DateFormat("dd").format(DateTime.parse(value.columnName!)):
                                value.columnName!,
                                  style: TextStyle(fontFamily: 'RR',color: bgColor,fontSize: 16),)
                                )
                            ):Container()
                            ))
                                .values.toList()
                        ),
                      ),

                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight,
                    width: width-149,
                    alignment: Alignment.topLeft,
                    color: attendanceMonthGridBodyBgColor,
                    child: SingleChildScrollView(
                      controller: body,
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      child: Container(
                        height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight,
                        alignment: Alignment.topCenter,
                        color:attendanceMonthGridBodyBgColor,
                        child: SingleChildScrollView(
                          controller: verticalRight,
                          scrollDirection: Axis.vertical,
                          physics: ClampingScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:widget.gridData!.asMap().
                              map((i, value) => MapEntry(
                                  i,InkWell(
                                //   onTap: widget.voidCallback,
                                onTap: (){
                                  widget.func!(i);
                                  //setState(() {});
                                },
                                child: Container(

                                  decoration: BoxDecoration(
                                    border: gridBottomborder,
                                    color: i%2!=0?Color(0xFFE9EFFF):Colors.transparent,
                                    //    color: widget.selectedIndex==i?yellowColor:attendanceMonthGridBodyBgColor,
                                  ),
                                  height: 50,
                                  margin: EdgeInsets.only(bottom:i==widget.gridData!.length-1?70: 0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,

                                      children: widget.gridDataRowList!.asMap().map((j, v) {


                                        if(!v.isDate){
                                          if((10.0*value[v.columnName].toString().length)>v.width){
                                            setState(() {
                                              v.width=10.0*value[v.columnName].toString().length;
                                            });
                                          }
                                        }

                                        // print("${value.get(v.columnName)} ${v.width} ${10.0*value.get(v.columnName).toString().length}");

                                        return MapEntry(j,
                                          j==0?Container():v.isActive?!v.isDate?Container(
                                            width: v.width,
                                            height: 50,
                                            alignment: v.alignment,
                                            padding: v.edgeInsets,
                                            constraints: BoxConstraints(
                                                minWidth: 50,
                                                maxWidth: 200
                                            ),
                                            decoration: BoxDecoration(
                                          //    color: value[v.columnName]=='P'?Colors.green:Colors.red
                                            ),

                                            child: Text("${value[v.columnName].toString().isNotEmpty?value[v.columnName]??" ":" "}",
                                              style:widget.selectedIndex==i?TSWhite166:gridTextColor14,
                                            ),
                                          ):Container(
                                            width: v.width,
                                            height: 50,
                                            alignment: v.alignment,
                                            padding: v.edgeInsets,
                                            constraints: BoxConstraints(
                                                minWidth: 50,
                                                maxWidth: 200
                                            ),
                                            decoration: BoxDecoration(
                                              
                                            ),
                                            /*decoration: BoxDecoration(
                                                color: value[v.columnName]=='P'?Colors.green:
                                                value[v.columnName]=='A'?Colors.red:Colors.transparent
                                            ),*/
                                            child: value[v.columnName]=='P'?Icon(Icons.done,color: Colors.green,):
                                            value[v.columnName]=='A'?Icon(Icons.clear,color: Colors.red,):Container(
                                              color: Colors.transparent,
                                            )
                                            /*child: Text("${value[v.columnName]!=null?DateFormat('dd-MM-yyyy').format(DateTime.parse(value[v.columnName])):" "}",
                                              style:widget.selectedIndex==i?TSWhite166:gridTextColor14,
                                            ),*/
                                          )
                                              :Container(),
                                        );
                                      }
                                      ).values.toList()
                                  ),
                                ),
                              )
                              )
                              ).values.toList()
                          ),
                        ),


                      ),
                    ),
                  ),
                ],
              ),
            ),


            //not Scrollable
            Positioned(
              left: 5,
              child:widget.gridDataRowList!.isEmpty?Container(): Column(
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
                      padding: widget.gridDataRowList![0].edgeInsets,
                      alignment: widget.gridDataRowList![0].alignment,
                      //   clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                      ),
                      child: FittedBox(child: Text("${widget.gridDataRowList![0].columnName}",
                        style: TextStyle(fontFamily: 'RR',color: bgColor,fontSize: 16),)),

                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                        color:showShadow? attendanceMonthGridBodyBgColor:Colors.transparent,
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
                      height: SizeConfig.screenHeight!-widget.gridBodyReduceHeight,
                      alignment: Alignment.topCenter,

                      child: SingleChildScrollView(
                        controller: verticalLeft,
                        scrollDirection: Axis.vertical,
                        child: Column(
                            children: widget.gridData!.asMap().
                            map((i, value) => MapEntry(
                                i,InkWell(
                              onTap: (){
                                widget.func!(i);
                                //setState(() {});
                              },
                              child:  Container(
                                alignment:widget.gridDataRowList![0].alignment,
                                padding: widget.gridDataRowList![0].edgeInsets,
                                margin: EdgeInsets.only(bottom:i==widget.gridData!.length-1?70: 0),
                                decoration: BoxDecoration(
                                  border: gridBottomborder,
                                  //  color: widget.selectedIndex==i?yellowColor:attendanceMonthGridBodyBgColor,
                                  color: i%2!=0?Color(0xFFE9EFFF):Colors.transparent,
                                ),
                                height: 50,
                                width: 150,
                                constraints: BoxConstraints(
                                    maxWidth: 150
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    //color:value.invoiceType=='Receivable'? Colors.green:AppTheme.red,
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                   child: Text("${value[widget.gridDataRowList![0].columnName]}",
                                     style:widget.selectedIndex==i?TSWhite166:gridTextColor14,
                                   ),
                                   /* child: !widget.gridDataRowList![0].isDate? Text("${value[widget.gridDataRowList![0].columnName]}",
                                      style:widget.selectedIndex==i?TSWhite166:gridTextColor14,
                                    ):
                                    widget.gridDataRowList![0].columnName!=null?Text("${widget.gridDataRowList![0].columnName.toString().isNotEmpty?widget.gridDataRowList![0].columnName!=null?
                                    DateFormat('dd-MM-yyyy').format(DateTime.parse(value[widget.gridDataRowList![0].columnName])):" ":" "}",
                                      style:widget.selectedIndex==i?TSWhite166:gridTextColor14,
                                    ):Container(),*/
                                  ),
                                ),
                              ),
                            )
                            )
                            ).values.toList()



                        ),
                      ),


                    ),
                  ),
                ],
              ),
            ),


            widget.gridData!.isEmpty?Container(
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



          ],
        )

    );
  }
}


