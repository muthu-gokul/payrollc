import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class NoData extends StatelessWidget {
  double? height;
  NoData({this.height=150.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height,),
          Text("No Data Found",style: TextStyle(fontSize: 18,fontFamily:'RMI',color: grey),),
          SvgPicture.asset("assets/nodata.svg",height: 350,),

        ],
      ),
    );
  }
}



class ShimmerWidget extends StatelessWidget {
  double? topMargin;
  ShimmerWidget({this.topMargin=0.0});
  late double width,height;
  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: 20),
      margin: EdgeInsets.only(top: topMargin!),
      child:ListView.builder(
        itemCount: 3,
        itemBuilder: (_,__){
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: Duration(seconds: 2),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 180,
                    width: width*0.55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width*0.55,
                          height: 120,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: width*0.45,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: width*0.45,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: 40.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    height: 180,
                    width: width*0.4,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width*0.55,
                          height: 120,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: width*0.45,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: width*0.45,
                          height: 8.0,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: 40.0,
                          height: 8.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

