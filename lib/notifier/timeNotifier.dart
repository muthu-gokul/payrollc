import 'dart:async';

import 'package:cybertech/constants/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permi;
import 'package:permission_handler/permission_handler.dart';

class TimeNotifier extends ChangeNotifier{


  var timeInfo;
  bool locAlways=true;
  batteryInfo()  async {
    timeInfo =DateFormat.jm().format(DateTime.parse(DateTime.now().toString()));
   // var status2 = await Permission.locationAlways.status;
   /* if(status2.isDenied || status2.isRestricted){
      locAlways=false;
    }
    else if(status2.isGranted){
      locAlways=true;
    }
*/
    notifyListeners();
  }

  @override
  void notifyListeners() {
    Timer(Duration(seconds: 1), (){
      batteryInfo();
    });

    super.notifyListeners();
  }

  @override
  void addListener(void Function() listener) {
    Timer(Duration(seconds: 1), (){
      batteryInfo();
    });
    super.addListener(listener);
  }

}

class LocationNotifier extends ChangeNotifier{

  final dbRef2=FirebaseDatabase.instance.reference().child("TrackUsers").child(USERDETAIL['Uid']);
  final Location location = Location();
  LocationData? locationData;
  var first;
 bool isLocationServiceEnable=true;

   listenLocation() async {

    //locationData=location.getLocation() as LocationData?;
    bool tempSErvice=await location.serviceEnabled();


  //s  print(isLocationServiceEnable);
    if(isLocationServiceEnable != tempSErvice){
      isLocationServiceEnable=tempSErvice;
      location.enableBackgroundMode(enable: true);
      location.changeSettings(accuracy: LocationAccuracy.high,interval: 2000,);
      locationData=await location.getLocation();
      final coordinates = new Coordinates(locationData!.latitude, locationData!.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      if(first!=null){
        if(addresses.first.featureName!=first.featureName && addresses.first.addressLine!=first.addressLine){
          dbRef2.update({
            'lat':locationData!.latitude,
            'long':locationData!.longitude,
            'time':DateTime.now().toString()
          });
          first = addresses.first;
        }
      //  print(first.addressLine);
      }
      else{
        dbRef2.update({
          'lat':locationData!.latitude,
          'long':locationData!.longitude,
          'time':DateTime.now().toString()
        });
        first = addresses.first;
      //  print(first.addressLine);
      }
    }
    if(isLocationServiceEnable){
      if(!await Location().isBackgroundModeEnabled()){
        location.enableBackgroundMode(enable: true);
      }
      if(locationData==null|| first ==null){
        locationData=await location.getLocation();
        final coordinates = new Coordinates(locationData!.latitude, locationData!.longitude);
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        first = addresses.first;
        notifyListeners();
      }

      location.onLocationChanged.listen((event) async {
        final coordinates = new Coordinates(event.latitude, event.longitude);
        var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        if(first!=null){
          if(addresses.first.featureName!=first.featureName && addresses.first.addressLine!=first.addressLine){
            dbRef2.update({
              'lat':event.latitude,
              'long':event.longitude,
              'time':DateTime.now().toString()
            });
            first = addresses.first;
            locationData=event;
          }
          // print(first.addressLine);
        }
        else{
          dbRef2.update({
            'lat':event.latitude,
            'long':event.longitude,
            'time':DateTime.now().toString()
          });
          first = addresses.first;
          locationData=event;
         // print(first.addressLine);
        }
      });

   //   print("ENABLED");
/*      locationData=await location.getLocation();
      final coordinates = new Coordinates(locationData!.latitude, locationData!.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
     // print("56 --- ${addresses.first.addressLine}");
      if(first!=null){
        if(addresses.first.featureName!=first.featureName && addresses.first.addressLine!=first.addressLine){
          dbRef2.update({
            'lat':locationData!.latitude,
            'long':locationData!.longitude,
          });
            first = addresses.first;
        }
        print(first.addressLine);
      }
      else{
        dbRef2.update({
          'lat':locationData!.latitude,
          'long':locationData!.longitude,
        });
          first = addresses.first;
        print(first.addressLine);
      }*/
    }
    if(!tempSErvice && !isLocationServiceEnable){
      Timer(Duration(seconds: 10), (){
        location.enableBackgroundMode(enable: true);
        location.changeSettings(accuracy: LocationAccuracy.high,interval: 2000,);

      });
    }
    notifyListeners();


  }
  @override
  void notifyListeners() {
    Timer(Duration(seconds: 3), (){
      listenLocation();
     // batteryInfo();
    });

    super.notifyListeners();
  }

  @override
  void addListener(void Function() listener) {
    Timer(Duration(seconds: 3), (){
      listenLocation();
     // batteryInfo();
    });
    super.addListener(listener);
  }
}