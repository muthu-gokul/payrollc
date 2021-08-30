import 'package:flutter/material.dart';


class NavBarIcon extends StatelessWidget {
  VoidCallback ontap;
  NavBarIcon({required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:ontap,
      child: Container(
        /*height: 25,
        width: 22,
        color: Colors.transparent,*/
        height: 40,
        width: 40,
        margin: EdgeInsets.only(left: 20),
        padding: EdgeInsets.only(left: 7,top: 7),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: Offset(1,3),
                blurRadius: 5,
                spreadRadius: 2
              )
            ]
        ),
   //   margin: EdgeInsets.only(left: 20,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        //  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 6,),
            Container(
              height: 2,
              width: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF3B3B3D)
              ),
            ),
            SizedBox(height: 2,),
            Container(
              height: 2,
              width: 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF787878)
              ),
            ),
            SizedBox(height: 2,),
            Container(
              height: 2,
              width: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF3B3B3D)
              ),
            ),
            SizedBox(height: 2,),
            Container(
              height: 2,
              width: 17,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF787878)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
