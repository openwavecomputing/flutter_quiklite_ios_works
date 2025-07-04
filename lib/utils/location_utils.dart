import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_service.dart'
    as serviceStatus;

import '../constants/comparison_constants.dart';
import '../constants/word_constants.dart';
import '../database/location/location_operations.dart';
import '../database/location/location_row.dart';
import '../notification/local_notification.dart';
import 'date_utils.dart';

class LocationUtils {
  // Singleton approach
  static final LocationUtils _instance = LocationUtils._internal();

  factory LocationUtils() => _instance;

  LocationUtils._internal();

  late ServiceInstance serviceInstance;


  StreamSubscription? _getPositionSubscriptionForStartEndDuty;

  Future<LocationPermission> checkLocationPermission(
      BuildContext context) async {
    return await Geolocator.checkPermission();
  }

  Future<bool> checkLocationEnabled(BuildContext context) async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<Position> getCurrentPosition(BuildContext context) async {
    return await Geolocator.getCurrentPosition();
  }


  Future<void> startLocationTrackingForStartDuty() async {
    // startNetworkStream(userToken: userToken);
    bool servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {}
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    // Convert to proper location fetch condition handling and then call below
    LocalNotifications.showSimpleNotification(
        notificationId: ComparisonConstants.notificationIdStartDuty,
        title: WordConstants.wAppName,
        body: WordConstants.wNotificationBackgroundLocation,
        payload: "");

    const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50);

    _getPositionSubscriptionForStartEndDuty =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      debugPrint(
          "Position listener latitude ${position.latitude} longitude ${position.longitude}");
      LocationOperations().addLocation(LocationRow(
          locationLatLong:
          '${position.latitude.toString()},${position.longitude.toString()}',
          timeStamp: DateTimeUtils.formatFromCurrentDateTimeForAPI()));
    });
  }

  stopLocationTrackingForEndDuty() {
    if (_getPositionSubscriptionForStartEndDuty != null) {
      _getPositionSubscriptionForStartEndDuty!.cancel();
    }
    // stopNetworkStream();
  }


}
