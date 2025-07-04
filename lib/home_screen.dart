import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'alert/alert_action.dart';
import 'alert/app_alert.dart';
import 'constants/word_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLocationEnabled = false;
  String latitude = "";
  String longitude = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _buildHomeView(), //LeaveRequestListScreen
    ));
  }

  Future<bool> checkForNotificationStatus() async {
    return await Permission.notification
        .request()
        .then((permissionStatus) async {
      debugPrint(
          'checkForNotificationStatus permissionStatus $permissionStatus');
      // isNotificationAllowed =
      //     permissionStatus == PermissionStatus.granted ? true : false;
      return permissionStatus == PermissionStatus.granted ? true : false;
    });
  }

  Future getCurrentLocationNew(bool isClicked) async {
    LocationPermission permissionValue = await Geolocator.checkPermission();
    debugPrint(
        'getCurrentLocationDetails requestPermission $permissionValue');
    if (permissionValue == LocationPermission.denied ||
        permissionValue == LocationPermission.deniedForever) {
      final alertAction = await AppAlert.showCustomDialogOK(
        context,
        WordConstants.wLocationPermissionDenied,
      );

      if (alertAction != AlertAction.ok) return;

      permissionValue = await Geolocator.requestPermission();
      debugPrint(
          'getCurrentLocationDetails requestPermission $permissionValue');
    } else {
      debugPrint(
          'getCurrentLocationDetails existingPermission $permissionValue');
    }

    // After permission check or request
    if (permissionValue == LocationPermission.always ||
        permissionValue == LocationPermission.whileInUse) {
      final isLocationEnabledValue =
          await Geolocator.isLocationServiceEnabled();
      debugPrint(
          'getCurrentLocationDetails isLocationEnabledValue $isLocationEnabledValue');

      isLocationEnabled = isLocationEnabledValue;
      debugPrint(
          'getCurrentLocationDetails isLocationEnabled $isLocationEnabled');

      if (isLocationEnabledValue) {
        debugPrint('getCurrentLocationDetails latitude status $latitude');
        debugPrint('getCurrentLocationDetails longitude status $longitude');
        //debugPrint('getCurrentLocationDetails isClicked status $isClicked');

        if (latitude.isEmpty && longitude.isEmpty) {
          var position = await Geolocator.getCurrentPosition();
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
          debugPrint('getCurrentLocationDetails latitude $latitude');
          debugPrint('getCurrentLocationDetails longitude $longitude');
          setState(() {

          });
        }
      } else {
        AppAlert.showSnackBar(
          context,
          WordConstants.wLocationEmpty,
        );
      }
    } else if (permissionValue == LocationPermission.denied) {
      final value = await AppAlert.showCustomDialogOK(
          context, WordConstants.wLocationPermissionDenied);
      if (value == AlertAction.yes) {
        await getCurrentLocationNew(false);
      }
    } else if (permissionValue == LocationPermission.deniedForever) {
      final value = await AppAlert.showCustomDialogOK(
        context,
        WordConstants.wLocationPermissionDeniedPermanently,
      );
      if (value == AlertAction.yes) {
        await openAppSettings();
      }
    }
  }

  Widget _buildHomeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            print('Notification Check');
            checkForNotificationStatus().then((isWorking){

              print("Notification Working");
            });
          },
          child: Text(
            'Notification Check',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
          onPressed: () async {
            print('Location Check');
            await getCurrentLocationNew(true);
          },
          child: Text(
            'Location Check ',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Text( "lat:$latitude lng:$longitude",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
          onPressed: () {
            print('Start Duty');
          },
          child: Text(
            'Start Duty',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
          onPressed: () {
            print('Stop Duty');
          },
          child: Text(
            'Stop Duty',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
