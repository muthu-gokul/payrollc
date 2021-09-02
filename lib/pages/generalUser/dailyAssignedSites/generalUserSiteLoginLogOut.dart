import 'dart:io';

import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:cybertech/notifier/timeNotifier.dart';
import 'package:cybertech/widgets/alertDialog.dart';
import 'package:cybertech/widgets/arrowBack.dart';
import 'package:cybertech/widgets/bottomPainter.dart';
import 'package:cybertech/widgets/customTextField.dart';
import 'package:cybertech/widgets/loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class GeneralUserSiteLoginLogOut extends StatefulWidget {
  String currentLocation;
  int index;
  double? latitude;
  double? longitude;
  GeneralUserSiteLoginLogOut({required this.currentLocation,required this.index,required this.longitude,required this.latitude});
  @override
  _GeneralUserSiteLoginLogOutState createState() => _GeneralUserSiteLoginLogOutState();
}

class _GeneralUserSiteLoginLogOutState extends State<GeneralUserSiteLoginLogOut> {
  PageController? pageController;
  int pageIndex=0;
  bool isEmployeeLogin=true;
  Map siteDetails={};
  final dbRef=FirebaseDatabase.instance.reference().child("SiteAssign").child(DateFormat(dbDateFormat).format(DateTime.now())).child(USERDETAIL['Uid']);
  final dbRef2=FirebaseDatabase.instance.reference().child("TrackUsers").child(USERDETAIL['Uid']);

  bool isLoad=false;
  final picker = ImagePicker();
  List<XFile>? images=[];

  Future<List<String>> uploadImages(List<XFile>? images) async {
  //  if (images.length < 1) return "null";

    List<String> _downloadUrls = [];
    int i=0;
    await Future.forEach(images!, (image) async {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('SiteAssign')
          .child(DateFormat(dbDateFormat).format(DateTime.now()))
          .child(USERDETAIL['Uid'])
          .child("${widget.index}")
          .child("$i");

      final UploadTask uploadTask = ref.putFile(File(images[i].path));
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final url = await taskSnapshot.ref.getDownloadURL();
      _downloadUrls.add(url);
      i++;
    });

    return _downloadUrls;
  }

  @override
  void initState() {
    dbRef.child("${widget.index}").onValue.listen((event) {
      print(event.snapshot.value);
      if(event.snapshot.value!=null){
       // setState(() {
          siteDetails=event.snapshot.value;
       // });
      }
    });

    pageController=new PageController(initialPage: 0);
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node=FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Stack(
            children: [

              PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (i){
                  setState(() {
                    pageIndex=i;
                    if(i==0){
                      isEmployeeLogin=true;
                    }
                    else{
                      isEmployeeLogin=false;
                    }
                  });
                },
                children: [
                  //Login
                  Stack(
                    children: [
                      Container(
                        height: 50,
                        width:SizeConfig.screenWidth,
                        color: yellowColor,
                        child: Row(
                          children: [
                            ArrowBack(

                              ontap: (){
                                Navigator.pop(context);
                              },
                              iconColor: Colors.white,
                            ),
                            Text("Login",
                              style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 45),
                        height: SizeConfig.screenHeight!-50,
                        width: SizeConfig.screenWidth,
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap:() async{
                                      /*  final DateTime picked = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(), // Refer step 1
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null)
                                              setState(() {
                                               ean.selectedDate=picked;
                                              });*/
                                    },
                                    child: Container(
                                      height: 50,
                                      width:( SizeConfig.screenWidthM40!*0.5)-10,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color: addNewTextFieldBorder)
                                      ),
                                      child: Row(
                                        children: [
                                          Text("${DateFormat("dd-MM-yyyy").format(DateTime.now())}"),
                                          Spacer(),
                                          SvgPicture.asset("assets/svg/calender.svg",height: 25,width: 25,color: Colors.black ,)

                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      /* final TimeOfDay picked = await showTimePicker(
                                              context: context,
                                              initialTime: ean.selectedTime==null?TimeOfDay.now():ean.selectedTime,

                                            );
                                            if (picked != null){
                                              print(picked);
                                            }
                                              setState(() {
                                                ean.selectedTime=picked;
                                                ean.time = formatDate(
                                                    DateTime(2019, 08, 1, ean.selectedTime.hour, ean.selectedTime.minute),
                                                    [hh, ':', nn, " ", am]).toString();
                                              });*/
                                    },
                                    child:Container(
                                      height: 50,
                                      width:( SizeConfig.screenWidthM40!*0.5)-10,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color: addNewTextFieldBorder)
                                      ),
                                      child: Row(
                                        children: [
                                          Consumer<TimeNotifier>(
                                            builder: (context,timeNotifier,child)=> Text('${timeNotifier.timeInfo??"${DateFormat.jm().format(DateTime.parse(DateTime.now().toString()))}"}',

                                            ),
                                          ),

                                          Spacer(),
                                          Icon(Icons.timer)

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            siteDetails['SiteLoginTime']==null?Container():
                                Text("Logged in at ${siteDetails['SiteLoginTime']}"),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_outlined,color: Colors.red,size: 25,),
                                Container(
                                  alignment: Alignment.centerLeft,
                                    width: SizeConfig.screenWidth!*0.9,
                                    child: Text(siteDetails['SiteLoginAddress']==null?"${widget.currentLocation}":"${siteDetails['SiteLoginAddress']}",
                                      style: gridTextColor14,)
                                ),
                              ],
                            )
                          ],
                        ),
                      )

                    ],
                  ),

                  //LogOut
                  Stack(
                    children: [
                      Container(
                        height: 50,
                        width:SizeConfig.screenWidth,
                        color: yellowColor,
                        child: Row(
                          children: [
                            ArrowBack(

                              ontap: (){
                                Navigator.pop(context);
                              },
                              iconColor: Colors.white,
                            ),
                            Text("LogOut",
                              style: TextStyle(fontFamily: 'RR',fontSize: 16,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 45),
                        height: SizeConfig.screenHeight!-100,
                        width: SizeConfig.screenWidth,
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.width20!,right: SizeConfig.width20!,top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap:() async{
                                    },
                                    child: Container(
                                      height: 50,
                                      width:( SizeConfig.screenWidthM40!*0.5)-10,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color: addNewTextFieldBorder)
                                      ),
                                      child: Row(
                                        children: [
                                          Text("${DateFormat("dd-MM-yyyy").format(DateTime.now())}"),
                                          Spacer(),
                                          SvgPicture.asset("assets/svg/calender.svg",height: 25,width: 25,color: Colors.black ,)

                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                    },
                                    child:Container(
                                      height: 50,
                                      width:( SizeConfig.screenWidthM40!*0.5)-10,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color: addNewTextFieldBorder)
                                      ),
                                      child: Row(
                                        children: [
                                          Consumer<TimeNotifier>(
                                            builder: (context,timeNotifier,child)=> Text('${timeNotifier.timeInfo??"${DateFormat.jm().format(DateTime.parse(DateTime.now().toString()))}"}',

                                            ),
                                          ),

                                          Spacer(),
                                          Icon(Icons.timer)

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            siteDetails['SiteLogoutTime']==null?Container():
                            Text("Logged Out at ${siteDetails['SiteLogoutTime']}"),
                            SizedBox(height: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_outlined,color: Colors.red,size: 25,),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    width: SizeConfig.screenWidth!*0.9,
                                    child: Text(siteDetails['SiteLogoutAddress']==null?"${widget.currentLocation}":"${siteDetails['SiteLogoutAddress']}",
                                      style: gridTextColor14,)
                                ),
                              ],
                            ),
                            SizedBox(height: 50,),
                            Container(
                                height: 100,
                                child: GridView.count(
                              crossAxisCount: 3,
                              children: List.generate(images!.length, (index) {
                                return Image.file(File(images![index].path));
                              }),
                            )),
                            GestureDetector(
                              onTap: () async{

                               images  = await picker.pickMultiImage();

                                setState(() {

                                });

                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: yellowColor
                                  ),
                                ),
                              ),
                            ),

                            AddNewLabelTextField(
                              maxlines: null,
                              onChange: (v){},
                              labelText: "Remarks",
                              onEditComplete: (){
                                node.unfocus();
                              },
                              scrollPadding: 1000,
                            ),
                            SizedBox(height: 300,)
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),

              //bottomNav
              Positioned(
                bottom: 0,
                child: Container(
                  width: SizeConfig.screenWidth,
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


                            AnimatedPositioned(
                              bottom:0,
                              duration: Duration(milliseconds: 300,),
                              curve: Curves.bounceInOut,
                              child: Container(

                                  width: SizeConfig.screenWidth,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: SizeConfig.width20,),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            isEmployeeLogin=true;
                                          });
                                          pageController!.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                                        },
                                        child: Container(
                                          width: 130,
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          child:FittedBox(
                                              child:Image.asset(pageIndex==0?"assets/images/Login-text-icon.png":
                                              "assets/images/Login-text-icon-gray.png")
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: (){
                                          if(siteDetails['SiteLoginTime']!=null){
                                            setState(() {
                                              isEmployeeLogin=false;
                                            });
                                            pageController!.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                          }
                                          else{
                                            CustomAlert().commonErrorAlert2(context, "Login", "");
                                          }

                                        },
                                        child: Container(
                                          width: 130,
                                          height: 50,
                                          alignment: Alignment.centerRight,
                                          child:FittedBox(
                                              child:Image.asset(pageIndex==1?"assets/images/Logout-text-icon.png":
                                              "assets/images/Logout-text-icon-gray.png")
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.width20,),
                                    ],
                                  )
                              ),
                            )

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //addButton
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: (){
                    if(isEmployeeLogin){
                      if(siteDetails['SiteLoginTime']==null){
                        dbRef.child("${widget.index}").update({
                          'SiteLoginTime':DateTime.now().toString(),
                          'SiteLoginAddress':widget.currentLocation,
                          'SiteLoginLatitude':widget.latitude,
                          'SiteLoginLongitude':widget.longitude,
                        });
                        dbRef2.update({
                          'lat':widget.latitude,
                          'long':widget.longitude,
                        });
                      }
                      else{
                        CustomAlert().commonErrorAlert2(context, "Already Logged In...", "");
                      }

                    }
                    else{
                      if(siteDetails['SiteLogoutTime']==null){
                        if(images!.isNotEmpty){
                          setState(() {
                            isLoad=true;
                          });
                          uploadImages(images).then((value){
                            print(value);
                            dbRef.child("${widget.index}").update({
                              'SiteLogoutTime':DateTime.now().toString(),
                              'SiteLogoutAddress':widget.currentLocation,
                              'SiteLogoutLatitude':widget.latitude,
                              'SiteLogoutLongitude':widget.longitude,
                              'Images':value
                            });
                            dbRef2.update({
                              'lat':widget.latitude,
                              'long':widget.longitude,
                            });
                            setState(() {
                              isLoad=false;
                            });
                          });
                        }
                      }
                      else{
                        CustomAlert().commonErrorAlert2(context, "Already Logged Out...", "");
                      }

                    }
                  },
                  child: Container(

                    height: 65,
                    width: 65,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration:BoxDecoration(
                      shape: BoxShape.circle,
                      color:isEmployeeLogin? Colors.green:red,
                      boxShadow: [
                        BoxShadow(
                          color: isEmployeeLogin?  Colors.green.withOpacity(0.4):red.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(1, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon( isEmployeeLogin? Icons.arrow_upward:Icons.power_settings_new_outlined,size: 40,color: Colors.white,),
                    ),
                  ),
                ),
              ),


              Loader(
                isLoad: isLoad,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
