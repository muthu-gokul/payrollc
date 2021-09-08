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

class ExpenseReportDetailView extends StatefulWidget {

  Map expensesList;

  ExpenseReportDetailView({required this.expensesList});

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
                        print(widget.expensesList[key]);
                      },
                      child: Container(
                        height: 200,
                        width: 100,
                        margin: EdgeInsets.all(20),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              color: Colors.grey,
                              child: Text("${widget.expensesList[key]['SiteName']}",style: TSWhite166,),
                            ),
                            Text("${widget.expensesList[key]['ExpenseName']}",style: greyTextColor16,),
                            Text("${widget.expensesList[key]['ExpenseValue']}",style: greyTextColor16,),
                            SizedBox(width: 20,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 35,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:widget.expensesList[key]['Status']=='Pending'?Colors.red.withOpacity(0.5): Colors.red
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Reject',style: TSWhite166),
                                ),
                                Container(
                                  height: 35,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:widget.expensesList[key]['Status']=='Pending'?Colors.green.withOpacity(0.5):  Colors.green
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Accept',style: TSWhite166),
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
