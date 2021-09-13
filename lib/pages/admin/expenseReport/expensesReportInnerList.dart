import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cybertech/api/authentication.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/arrowBack.dart';
import 'package:cybertech/widgets/bottomBarAddButton.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/customTextField.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseReportDetailView extends StatefulWidget {

  Map expensesList;
  String date;
  String uid;
  VoidCallback voidCallback;

  ExpenseReportDetailView({required this.expensesList, required this.date,required this.uid,required this.voidCallback});

  @override
  _ExpenseReportDetailViewState createState() => _ExpenseReportDetailViewState();
}

class _ExpenseReportDetailViewState extends State<ExpenseReportDetailView> {



  bool isLoad=false;
  bool userGroupOpen=false;




  
  @override
  void initState() {

    super.initState();
  }
  AuthenticationHelper authenticationHelper=new AuthenticationHelper();
  var node;
  
  
  
  
  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);
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
                      widget.voidCallback();
                      Navigator.pop(context);
                    },
                    iconColor: Colors.white,
                  ),
                  Text("Expense Report Detail",
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
                child: ListView.builder(
                  itemCount: widget.expensesList.length,
                  itemBuilder: (ctx,i){
                    var key=widget.expensesList.keys.elementAt(i);
                    return InkWell(
                      onTap: (){
                     //   print(widget.expensesList[key]);
                      },
                      child: Container(
                        height: 220,
                        width: 100,
                        margin: EdgeInsets.fromLTRB(20,20,20,i==widget.expensesList.length-1?70:20),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              color: Colors.grey,
                              child: Text("${widget.expensesList[key]['SiteName']}",style: TSWhite166,),
                            ),
                            RichText(
                              text: TextSpan(
                                text: ' Expense Name:  ',
                                style: gridTextColorM14,
                                children: <TextSpan>[
                                  TextSpan(text: '${widget.expensesList[key]['ExpenseName']}', style: gridTextColor14),
                                ],
                              ),
                            ),

                            SizedBox(height: 3,),
                            RichText(
                              text: TextSpan(
                                text: ' Expense Value:  ',
                                style: gridTextColorM14,
                                children: <TextSpan>[
                                  TextSpan(text: '${widget.expensesList[key]['ExpenseValue']}', style: gridTextColor14),
                                ],
                              ),
                            ),
                            SizedBox(height: 3,),
                            RichText(
                              text: TextSpan(
                                text: ' Accepted Expense Value:  ',
                                style: gridTextColorM14,
                                children: <TextSpan>[
                                  TextSpan(text: '${widget.expensesList[key]['AcceptedExpenseValue']??0}', style: gridTextColor14),
                                ],
                              ),
                            ),
                            SizedBox(height: 3,),
                            RichText(
                              text: TextSpan(
                                text: ' Rejected Expense Value:  ',
                                style: gridTextColorM14,
                                children: <TextSpan>[
                                  TextSpan(text: '${widget.expensesList[key]['RejectedExpenseValue']??0}', style: gridTextColor14),
                                ],
                              ),
                            ),
                        //    SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                print(widget.expensesList[key]);
                                showGeneralDialog(context: context,
                                  barrierDismissible: true,
                                  barrierColor: Colors.black54,
                                  barrierLabel: "Gfg",
                                  transitionDuration: Duration(milliseconds: 300),
                                  transitionBuilder: (BuildContext context, Animation<double> animation,
                                      Animation<double> secondaryAnimation, Widget child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.0, 1.0),
                                        end: Offset.zero,
                                      ).chain(CurveTween(curve: Curves.linear)).animate(animation),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  pageBuilder: (BuildContext buildContext, Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    final Widget pageChild = Builder(builder: (ctx){
                                      return Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), ),
                                        child:StatefulBuilder(
                                            builder:(context,setState){
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white
                                                ),
                                                height:SizeConfig.screenHeight!*0.9,
                                                width: SizeConfig.screenWidth!*0.95,
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  physics: BouncingScrollPhysics(),
                                                  itemCount: widget.expensesList[key]['Images'].length,
                                                  itemBuilder: (ctx,i){
                                                    return Container(
                                                      margin: EdgeInsets.all(10),
                                                 //     width: SizeConfig.screenWidth!*0.95,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(17),
                                                        child: CachedNetworkImage(
                                                          imageUrl: widget.expensesList[key]['Images'][i],
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
                                              );
                                            }
                                        ),
                                      );
                                    } );
                                    return SafeArea(
                                      top: false,
                                      child: Builder(builder: (BuildContext context) {
                                        return pageChild;
                                      }),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 50,
                                color: Colors.transparent,
                                alignment: Alignment.centerLeft,
                                child: Text("   View Images"),
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    CustomAlert(
                                        callback: (){
                                          expensesRef.child(widget.date).child(widget.uid).child("ExpensesList").child(key).update({
                                            'AcceptedExpenseValue':0,
                                            'RejectedExpenseValue':widget.expensesList[key]['ExpenseValue'],
                                            'Status':'Reject'

                                          }).then((value){
                                            setState((){
                                              widget.expensesList[key]['Status']='Reject';
                                              widget.expensesList[key]['AcceptedExpenseValue']=0;
                                              widget.expensesList[key]['RejectedExpenseValue']=widget.expensesList[key]['ExpenseValue'];
                                            });
                                            Navigator.pop(ctx);
                                          }).onError((error, stackTrace){
                                            CustomAlert().cupertinoAlertDialog(context, error.toString());
                                          });
                                        }
                                    ).cupertinoDialogYesNo(context,"Are you sure want to Reject ?");
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:widget.expensesList[key]['Status']=='Pending'?Colors.red.withOpacity(0.5):
                                      widget.expensesList[key]['Status']=='Reject'?Colors.red:Colors.red.withOpacity(0.5)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text('Reject',style: TSWhite166),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    print(key);
                                    print(widget.expensesList[key]);
                                    filterDialog(widget.expensesList[key]['ExpenseValue'],key);
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:widget.expensesList[key]['Status']=='Pending'?Colors.green.withOpacity(0.5):
                                        widget.expensesList[key]['Status']=='Accept'?Colors.green:Colors.green.withOpacity(0.5)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text('Accept',style: TSWhite166),
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),

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
                    widget.voidCallback();
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

        /*    Container(
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
            ),*/

          ],
        ),
      ),
    );
  }

  filterDialog(dynamic expenseValue,String key){

    TextEditingController expense=new TextEditingController(text: expenseValue.toString());
    return showGeneralDialog(context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.linear)).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = Builder(builder: (ctx){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), ),
            child:StatefulBuilder(
                  builder:(context,setState){
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                      ),
                      height:300,
                      width: SizeConfig.screenWidth!*0.7,
                      child: Column(
                        children: [

                          SizedBox(height: 20,),

                          AddNewLabelTextField(
                            labelText: 'Accept Expense Amount',
                            regExp:decimalReg,
                            textInputType: TextInputType.number,
                            textEditingController: expense,
                            onEditComplete: (){
                              FocusScope.of(context).unfocus();
                            },
                            onChange: (v){},
                            ontap: (){
                            },
                          ),

                          SizedBox(height: SizeConfig.height50,),
                          GestureDetector(
                            onTap: (){

                              if(expense.text.isNotEmpty){
                                if(double.parse(expense.text)>expenseValue){
                                  CustomAlert().cupertinoAlertDialog(context, "Accept Amount Should be less than or equal to Expense Value");
                                }
                                else{
                                  expensesRef.child(widget.date).child(widget.uid).child("ExpensesList").child(key).update({
                                    'AcceptedExpenseValue':double.parse(expense.text),
                                    'RejectedExpenseValue':double.parse(expenseValue.toString())-double.parse(expense.text),
                                    'Status':'Accept'

                                  }).then((value){
                                    setState((){
                                      widget.expensesList[key]['Status']='Accept';
                                      widget.expensesList[key]['AcceptedExpenseValue']=double.parse(expense.text);
                                      widget.expensesList[key]['RejectedExpenseValue']=double.parse(expenseValue.toString())-double.parse(expense.text);
                                    });
                                    Navigator.pop(ctx);
                                  }).onError((error, stackTrace){
                                    CustomAlert().cupertinoAlertDialog(context, error.toString());
                                  });
                                }
                              }

                            },
                            child: Container(
                              height: 50,
                              width: 350,
                              margin: EdgeInsets.only(left: 30,right: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:addNewTextFieldFocusBorder
                              ),
                              child: Center(
                                child: Text("Accept",style: TSWhite166,),
                              ),
                            ),
                          ),
                           GestureDetector(
                          onTap: (){

                            Navigator.pop(context);

                          },
                          child: Container(
                            height: 70,
                            width: 350,
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     color: AppTheme.addNewTextFieldFocusBorder
                            // ),
                            child: Center(
                              child: Text("Cancel",style: TextStyle(fontFamily: 'RL',fontSize: 20,color: Color(0xFFA1A1A1))),
                            ),
                          ),
                        ),

                        ],
                      ),
                    );
                  }
              ),
          );
        } );
        return SafeArea(
          top: false,
          child: Builder(builder: (BuildContext context) {
            return pageChild;
          }),
        );
      },
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
