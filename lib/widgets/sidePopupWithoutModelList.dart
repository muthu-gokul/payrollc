import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:flutter/material.dart';


class PopUpStatic2 extends StatefulWidget {

  String? title;

  bool? isOpen;
  bool isAlwaysShown;


  List<dynamic>? dataList;
  String? propertyKeyName;
  String? propertyKeyId;
  dynamic selectedId;

  Function(int)? itemOnTap;
  VoidCallback? closeOnTap;


  PopUpStatic2({this.isOpen,this.itemOnTap,this.dataList,this.isAlwaysShown=false,
    this.propertyKeyName,this.propertyKeyId,this.selectedId,this.closeOnTap,this.title});

  @override
  _PopUpStatic2State createState() => _PopUpStatic2State();
}

class _PopUpStatic2State extends State<PopUpStatic2> {

  ScrollController listController=new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.only(top: 20,bottom: 20,),
        margin: EdgeInsets.only(left: SizeConfig.width25!,right: SizeConfig.width25!),
        transform: Matrix4.translationValues(widget.isOpen!?0:SizeConfig.screenWidth!, 0, 0),
        child: Stack(
          children: [

            Container(

              /// height: SizeConfig.screenHeight*0.63,
              height: (widget.dataList!.length*60.0)+70,
              constraints: BoxConstraints(
                  minHeight: 60,
                  maxHeight: SizeConfig.screenHeight!*0.63
              ),
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(left: SizeConfig.width16!,right: SizeConfig.width16!,top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 5,left: 5),
                    margin: EdgeInsets.only(top: 50),
                    height: widget.dataList!.length*60.0,
                    constraints: BoxConstraints(
                        minHeight: 60,
                        maxHeight: SizeConfig.screenHeight!*0.63-70
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    width: SizeConfig.screenWidth!-SizeConfig.width60!,

                    child: RawScrollbar(
                      isAlwaysShown: widget.isAlwaysShown,
                      thumbColor: srollBarColor,
                      radius: Radius.circular(scrollBarRadius),
                      thickness: scrollBarThickness,
                      controller: listController,
                      child: ListView.builder(
                          itemCount: widget.dataList!.length,
                          physics: BouncingScrollPhysics(),
                          controller: listController,
                          itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                widget.itemOnTap!(index);



                              },
                              child: Container(
                                margin: EdgeInsets.only(left: SizeConfig.width40!,right:  SizeConfig.width40!,top: 20),
                                padding: EdgeInsets.only(left:5,right:5),

                                height: 40,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: addNewTextFieldBorder),
                                    color: widget.selectedId==null ?Color(0xFFf8f8f8):widget.selectedId==widget.dataList![index][widget.propertyKeyId]?bgColor:Colors.white
                                ),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text("${widget.dataList![index][widget.propertyKeyName]}",style: TextStyle(fontFamily: 'RR',fontSize: 14,
                                        color: widget.selectedId==null ?bgColor:widget.selectedId==widget.dataList![index][widget.propertyKeyId]?Colors.white:bgColor

                                    ),),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),

                  Container(
                    height: 50,
                    width: SizeConfig.screenWidth,
                    //  margin: EdgeInsets.only(left: SizeConfig.width20,right: SizeConfig.width20),
                    decoration: BoxDecoration(
                        color: yellowColor,
                        boxShadow: [
                          BoxShadow(
                            color: gridBodyBgColor,
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: Offset(0, 20), // changes position of shadow
                          )
                        ]
                    ),
                    child: Center(
                      child: Text(widget.title!,style: TextStyle(fontFamily: 'RM',fontSize: 16,color: Colors.white),),
                    ),
                  ),


                  /*SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      widget.addNewOnTap();


                    },
                    child: Container(
                      width:SizeConfig.screenWidth*0.4,
                      height:50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: AppTheme.yellowColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.yellowColor.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(1, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                          child: Text("Add New",style: AppTheme.bgColorTS,
                          )
                      ),
                    ),
                  ),*/
                ],
              ),

            ),
            Positioned(
              right: 8,
              child: GestureDetector(
                onTap: (){
                  widget.closeOnTap!();

                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:bgColor
                  ),
                  child: Center(
                    child: Icon(Icons.clear,color: Colors.white,size: 18,),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
