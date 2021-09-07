
import 'dart:developer';
import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/pages/admin/serviceReport/serviceReportSiteDetail.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/arrowBack.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/customTextField.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:cybertech/widgets/popOver/src/popover.dart';
import 'package:cybertech/widgets/popOver/src/popover_direction.dart';
import 'package:cybertech/widgets/validationErrorText.dart';
import 'package:flutter/material.dart';



class GeneralUserExpensesAddNew extends StatefulWidget {
  List<dynamic> siteList;
  GeneralUserExpensesAddNew({required this.siteList});
  @override
  _GeneralUserExpensesAddNewState createState() => _GeneralUserExpensesAddNewState();
}

class _GeneralUserExpensesAddNewState extends State<GeneralUserExpensesAddNew> {

  List<DateTime?> picked=[];
  int selIndex=-1;

  bool isLoad=false;
  bool _keyboardVisible = false;



  TextEditingController expenseName=new TextEditingController();
  TextEditingController value=new TextEditingController();
  Map selectedSite={};

  bool v_expenseName=false;
  bool v_value=false;
  bool v_site=false;



  @override
  void initState() {

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
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
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
                  Text("Expenses / Add New",
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
                child: ListView(
                    children: [
                      AddNewLabelTextField(
                        ontap: (){},
                        labelText: 'Expense Name',
                        textEditingController: expenseName,
                        maxlines: null,
                        onChange: (v){},
                        onEditComplete: (){
                          node.unfocus();
                        },
                      ),
                      !v_expenseName?Container():ValidationErrorText(),

                      AddNewLabelTextField(
                        ontap: (){},
                        labelText: 'Expense Amount',
                        textEditingController: value,
                        regExp: decimalReg,
                        maxlines: 1,
                        onChange: (v){},
                        onEditComplete: (){
                          node.unfocus();
                        },
                        textInputType: TextInputType.number,
                      ),
                      !v_expenseName?Container():ValidationErrorText(),

                      Builder(
                        builder: (ctx)=>GestureDetector(
                          onTap: (){
                            showPopover(
                                barrierColor: Colors.transparent,
                                context: ctx,
                                transitionDuration: const Duration(milliseconds: 150),
                                bodyBuilder: (context) => ListView.builder(
                                  itemCount: widget.siteList.length,
                                  itemBuilder: (ctx,index){
                                    return   InkWell(
                                      onTap: () {
                                        Navigator.pop(ctx);
                                        setState(() {
                                          selectedSite=widget.siteList[index];
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        color:selectedSite['SiteName']==widget.siteList[index]['SiteName']?Colors.grey: Colors.white,
                                        // color: Colors.white,
                                        child:  Center(
                                            child: Text("${ widget.siteList[index]['SiteName']}",
                                              style: TextStyle(fontFamily: 'RR',fontSize: 16,
                                                  color:selectedSite['SiteName']==widget.siteList[index]['SiteName']?Colors.white: Color(0xFF555555),letterSpacing: 0.1
                                              ),
                                            )
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                onPop: () => print('Popover was popped!'),
                                direction: PopoverDirection.bottom,
                                width: SizeConfig.screenWidthM40,
                                height: 200,
                                arrowHeight: 0,
                                arrowWidth: 0,
                                backgroundColor: Colors.white,
                                contentDyOffset: 5,
                                shadow:[ BoxShadow(
                                  color: Colors.grey[400]!,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                  // offset: Offset(-5,5),
                                  offset: Offset(0,0),
                                )],
                            );
                          },
                          child: PopOverParent(
                            text:selectedSite.isEmpty? "Select Site":selectedSite['SiteName'],
                            textColor:selectedSite.isEmpty? grey.withOpacity(0.5):grey,
                            iconColor:selectedSite.isEmpty? grey:yellowColor,
                            //bgColor:selectedSite.isEmpty? disableColor:mun.isEdit?Colors.white:disableColor,
                            bgColor:selectedSite.isEmpty? disableColor:Colors.white,

                          ),
                        ),
                      ),
                      !v_site?Container():ValidationErrorText(),
                    ],
                )


            ),

            //bottomNav
            Positioned(
              bottom: 0,
              child: _keyboardVisible?Container(width: 0,height: 0,): Container(
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
            _keyboardVisible?Container():Align(
                alignment: Alignment.bottomCenter,
                child: AddButton(
                  ontap: (){

                    if(expenseName.text.isEmpty){setState(() {v_expenseName=true;});}
                    else{setState(() {v_expenseName=false;});}

                    if(value.text.isEmpty){setState(() {v_value=true;});}
                    else{setState(() {v_value=false;});}

                    if(selectedSite.isEmpty){setState(() {v_site=true;});}
                    else{setState(() {v_site=false;});}

                    if(!v_value && !v_expenseName){
                      Navigator.pop(context);
                    }

                  },
                )
            ),
            Loader(
              isLoad: isLoad,
            ),


        /*    Container(

              height: userGroupOpen ? SizeConfig.screenHeight:0,
              width: userGroupOpen ? SizeConfig.screenWidth:0,
              color: Colors.black.withOpacity(0.5),

            ),*/

          ],
        ),
      ),
    );
  }
}

class PopOverParent extends StatelessWidget {
  String? text;
  Color? textColor;
  Color? iconColor;
  Color? bgColor;
  PopOverParent({this.text,this.textColor,this.iconColor,this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:SizeConfig.width20!,right:SizeConfig.width20!,top:15,),
      padding: EdgeInsets.only(left:SizeConfig.width10!,right:SizeConfig.width10!),
      // height: SizeConfig.height50,
      height: 50,
      width: double.maxFinite,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: addNewTextFieldBorder),
          color: bgColor

      ),
      child: Row(
        children: [
          Text(text!,style: TextStyle(fontFamily: 'RR',fontSize: 16,color: textColor,),overflow: TextOverflow.ellipsis,),
          Spacer(),
          Container(
              height: SizeConfig.height25,
              width: SizeConfig.height25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor
              ),

              child: Center(child: Icon(Icons.keyboard_arrow_down,color:Colors.white ,size: 24,)))
        ],
      ),
    );
  }
}