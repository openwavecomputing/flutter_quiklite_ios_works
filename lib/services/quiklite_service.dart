import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import '../constants/comparison_constants.dart';
import '../notification/local_notification.dart';
import '../utils/location_utils.dart';

///Below Commanded by surya and implemented with IOS config
/*Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          initialNotificationTitle: WordConstants.wAppName,
          initialNotificationContent:
              WordConstants.notificationBackgroundService));
  debugPrint("Service-startService");

  await service.startService();
}*/


bool _isJobSyncInProgress = false;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          initialNotificationTitle: "iOS Background",
          initialNotificationContent:"Background service initiated"));
  debugPrint("Service-startService");

  await service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  debugPrint("Service-onStart");
  if (service is AndroidServiceInstance) {
    service.on(ComparisonConstants.serviceForeground).listen((event) {
      debugPrint("Service-${ComparisonConstants.serviceForeground}");
      service.setAsForegroundService();
    });
    service.on(ComparisonConstants.serviceBackground).listen((event) {
      debugPrint("Service-${ComparisonConstants.serviceBackground}");
      service.setAsBackgroundService();
    });
  }
  service.on(ComparisonConstants.serviceStartDuty).listen((event) async {
    print("ServiceInstance serviceStartDuty");
    await LocationUtils()
        .startLocationTrackingForStartDuty();
  });

  service.on(ComparisonConstants.serviceStopDuty).listen((event) async {
    print("ServiceInstance serviceStopDuty");
    LocationUtils().stopLocationTrackingForEndDuty();

  });

  service.on(ComparisonConstants.serviceStopService).listen((event) {
    debugPrint("Service-${ComparisonConstants.serviceStopService}");
    LocalNotifications.cancel(ComparisonConstants.notificationIdStartDuty);
    service.stopSelf();
  });
}
