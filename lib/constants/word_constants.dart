class WordConstants {
  // App
  static const String wAppName = 'iOS Background App';

  // Notification Messages
  static const String wNotificationBackgroundService =
      "Background service initiated";
  static const String wNotificationBackgroundLocation =
      "Location updates started";
  static const String wNotificationWorkOrderSync =
      "Work Orders syncing in progress";
  static const String wNotificationLocationSync =
      "Locations syncing in progress";
  static const String wLocationPermissionDenied =
      "Background App enables real-time tracking and accurate work order updates. Please select 'Always Allow' to grant full background location access";
  // static const String wNotificationEndDutyRemainderMessage =
  //     "Don’t forget to end your duty";
  static const String wLocationWait = "Please wait while we fetch the location";
  static const String wLocationEmpty = "Please enable the location";
  static const String wLocationPermissionDeniedPermanently =
      "Background App enables real-time tracking and accurate work order updates. Please select 'Always Allow' to grant full background location access. Do you want to update app settings?";
  static const String wLocationServiceOff =
      "Location services are turned off. Please enable them.";
  static const String wLocationFetchError = "Failed to fetch current location.";
  static const String wLocationPermissionError =
      "Location permission not sufficient.";

  static const String wNotificationPermissionDenied =
      "Notification permission denied.";
  static const String wNotificationPermissionDeniedPermanently =
      "Notification permission permanently denied. Please enable it in app settings.";
}
