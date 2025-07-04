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
  bool notificationStatus = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildHomeView(),
      ),
    );
  }

  Future<bool> checkForNotificationStatus() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      AppAlert.showSnackBar(context, "Notification permission already granted");
      debugPrint('Notification permission already granted');
      return true;
    }

    final result = await Permission.notification.request();

    if (result.isGranted) {
      AppAlert.showSnackBar(context, "Notification permission granted");
      debugPrint('Notification permission granted');
      return true;
    }

    if (result.isPermanentlyDenied || result.isDenied) {
      // await openAppSettings();
      final action = await AppAlert.showCustomDialogOK(
        context,
        WordConstants.wNotificationPermissionDeniedPermanently,
      );
      if (action == AlertAction.yes) {
        await openAppSettings();
      }
    } else {
      await AppAlert.showSnackBar(
        context,
        WordConstants.wNotificationPermissionDenied,
      );
    }

    return false;
  }

  Future<void> getCurrentLocationNew(bool isClicked) async {
    print(">>> getCurrentLocationNew invoked. isClicked: $isClicked");

    // Step 1: Check if location service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(">>> Location service enabled: $serviceEnabled");

    if (!serviceEnabled) {
      await AppAlert.showSnackBar(context, WordConstants.wLocationServiceOff);
      print(">>> Exiting: Location services are turned off.");
      return;
    }

    // Step 2: Check location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    print(">>> Initial permission status: $permission");

    if (permission == LocationPermission.denied) {
      print(">>> Location permission is denied. Showing permission alert.");

      final alertAction = await AppAlert.showCustomDialogOK(
        context,
        WordConstants.wLocationPermissionDenied,
      );

      if (alertAction != AlertAction.yes) {
        print(">>> User denied location permission request.");
        return;
      }

      permission = await Geolocator.requestPermission();
      print(">>> New permission status after request: $permission");
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          ">>> Location permission permanently denied. Prompting to open settings.");
      final value = await AppAlert.showCustomDialogOK(
        context,
        WordConstants.wLocationPermissionDeniedPermanently,
      );
      if (value == AlertAction.yes) {
        print(">>> Opening app settings...");
        await openAppSettings();
      } else {
        print(">>> User canceled opening app settings.");
      }
      return;
    }

    // Step 3: Permission granted → fetch location
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      print(">>> Location permission granted. Attempting to fetch location...");

      try {
        final position = await Geolocator.getCurrentPosition();
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        isLocationEnabled = true;

        print(">>> Location fetched successfully.");
        print(">>> Latitude: $latitude");
        print(">>> Longitude: $longitude");

        setState(() {});
      } catch (e) {
        print(">>> Error fetching location: $e");
        await AppAlert.showSnackBar(context, WordConstants.wLocationFetchError);
      }
    } else {
      print(">>> Location permission not granted for whileInUse or always.");
      await AppAlert.showSnackBar(
        context,
        WordConstants.wLocationPermissionError,
      );
    }
  }

  Widget _buildHomeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            print('Notification Check');
            final isGranted = await checkForNotificationStatus();
            notificationStatus = isGranted;
            if (isGranted) {
              print("Notification permission granted.");
            } else {
              print("Notification permission denied.");
            }
          },
          child: Text(
            'Notification Check',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Center(
          child: Text(
            "Notification permission ${notificationStatus ? "Enabled" : "Disabled"}",
          ),
        ),
        SizedBox(height: 50),
        ElevatedButton(
          onPressed: () async {
            print('Location Check');
            await getCurrentLocationNew(true);
          },
          child: Text(
            'Location Check',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Text(
          "lat: $latitude  lng: $longitude",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            print('Start Duty');
          },
          child: Text(
            'Start Duty',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 50),
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
