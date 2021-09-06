import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:background_locator/location_dto.dart';
import 'package:cybertech/constants/constants.dart';
import 'package:cybertech/main.dart';
import 'package:cybertech/notifier/mySharedPref.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocationServiceRepository {
  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;
  var first;
  String uid="";
  late SharedPreferences _Loginprefs;


  Future<void> init(Map<dynamic, dynamic> params) async {
    //TODO change logs
    print("***********Init callback handler");
    if (params.containsKey('countInit')) {
      dynamic tmpCount = params['countInit'];
      if (tmpCount is double) {
        _count = tmpCount.toInt();
      } else if (tmpCount is String) {
        _count = int.parse(tmpCount);
      } else if (tmpCount is int) {
        _count = tmpCount;
      } else {
        _count = -2;
      }
    } else {
      _count = 0;
    }
    SharedPreferences.getInstance()
      ..then((prefs) {
        this._Loginprefs = prefs;
      });
    print("$_count");
    await setLogLabel("start");
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    print("$_count");
    await setLogLabel("end");
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    print('$_count location in dart: ${locationDto.toString()}');
    await setLogPosition(_count, locationDto);

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
    _count++;
    final coordinates = new Coordinates(locationDto.latitude, locationDto.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    uid= this._Loginprefs.getString('Uid') ?? "";
    print("UID $uid ${this._Loginprefs.getString('email')} ");
 /*   MySharedPreferences.instance
        .getStringValue("Uid")
        .then((value) {
      uid=value;
      print("UID $uid");*/
      if(first!=null){
        if(addresses.first.featureName!=first.featureName && addresses.first.addressLine!=first.addressLine){
          print("IFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ${USERDETAIL['Uid']} ${uid} ");
          trackUsersRef.child(uid).update({
            'lat':locationDto.latitude,
            'long':locationDto.longitude,
            'time':DateTime.now().toString()
          });
          first = addresses.first;
        }
        //  print(first.addressLine);
      }
      else{
        print("ELSEEEEEEEEEEEEEEEEEEEEEEEEEE");
        trackUsersRef.child(uid).update({
          'lat':locationDto.latitude,
          'long':locationDto.longitude,
          'time':DateTime.now().toString()
        });
        first = addresses.first;
        //  print(first.addressLine);
      }
   // });

  }

  static Future<void> setLogLabel(String label) async {
    final date = DateTime.now();
 //   await FileManager.writeToLogFile('------------\n$label: ${formatDateLog(date)}\n------------\n');
  }

  static Future<void> setLogPosition(int count, LocationDto data) async {
    final date = DateTime.now();
  //  await FileManager.writeToLogFile('$count : ${formatDateLog(date)} --> ${formatLog(data)} --- isMocked: ${data.isMocked}\n');
  }

  static double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString();
  }

  static String formatLog(LocationDto locationDto) {
    return dp(locationDto.latitude, 4).toString() +
        " " +
        dp(locationDto.longitude, 4).toString();
  }
}
