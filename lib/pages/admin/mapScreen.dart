import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = <Marker>[];

   late  CameraPosition _kGooglePlex;

  static final CameraPosition _kLake = CameraPosition(
      bearing: 92.8334901395799,
      target: LatLng(13.0650125, 80.1803574),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final dbRef2=FirebaseDatabase.instance.reference().child("TrackUsers");
  @override
  void initState() {
    getCurrentlocation();

/*    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId('SomeId'),
              position:LatLng(13.0650125, 80.1803574),
              infoWindow: InfoWindow(
                  title: 'Gokul Cab'
              ),
              onTap: (){
             //   showBottomModel();
              }
          )
      );
    });*/

    super.initState();
  }


  getCurrentlocation() async {
    final geoposition = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(geoposition.latitude, geoposition.longitude),
        zoom: 10.4746,
      );
    });
    print("geoposition.latitude");
    print(geoposition.latitude);
    print(geoposition.longitude);
  }

  showBottomModel(){
    showModalBottomSheet(
        enableDrag: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        elevation: 10,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 70,
                width: double.maxFinite,
                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("White Eritiga",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Color(0xFF8E8E8E)),),
                        SizedBox(height: 3,),
                        Text("HRA5G",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Color(0xFF8E8E8E)),),
                        SizedBox(height: 3,),
                        Text("4999",style: TextStyle(fontFamily: 'RB',fontSize: 22,color: Color(0xFF444444)),),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Muthu Gokul",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Color(0xFF8E8E8E)),),
                        SizedBox(height: 3,),
                        Text("4.7",style: TextStyle(fontFamily: 'RB',fontSize: 22,color: Color(0xFF444444)),),
                        SizedBox(height: 3,),
                        Text("9788149293",style: TextStyle(fontFamily: 'RR',fontSize: 14,color: Color(0xFF8E8E8E)),),

                        // Text("4999",style: TextStyle(fontFamily: 'RB',fontSize: 22,color: Color(0xFF444444)),),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.of(_markers),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          dbRef2.onValue.listen((event) {
            if(event.snapshot.value!=null){
              event.snapshot.value.forEach((k,v){
                setState(() {
                  _markers.add(
                      Marker(
                          markerId: MarkerId('${k}'),
                          position:LatLng(v['lat'], v['long']),
                          infoWindow: InfoWindow(
                              title: 'Gokul Cab'
                          ),
                          onTap: (){
                            //   showBottomModel();
                          }
                      )
                  );
                });
              });

            }
            else{
              setState(() {
                _markers.clear();
              });
            }
          });
        },
        onTap: (s){
          //print(s.toJson());
        },
      ),
      /*   floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),*/
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}