import 'package:flutter/foundation.dart' show immutable;

const String locationTable = 'locations';

class LocationFields {
  static final List<String> values = [
    locationLatLong,
    timeStamp,
  ];

  // Column names for task tables
  static const locationLatLong = 'location_lat_long';
  static const timeStamp = 'time_stamp';
}

@immutable
class LocationRow {
  final String locationLatLong;
  final String timeStamp;

  const LocationRow({
    required this.locationLatLong,
    required this.timeStamp,
  });

  LocationRow copy({
    String? locationLatLong,
    String? timeStamp,
  }) =>
      LocationRow(
        locationLatLong: locationLatLong ?? this.locationLatLong,
        timeStamp: timeStamp ?? this.timeStamp,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      LocationFields.locationLatLong: locationLatLong,
      LocationFields.timeStamp: timeStamp
    };
  }

  factory LocationRow.fromMap(Map<String, dynamic> map) {
    return LocationRow(
        locationLatLong: map[LocationFields.locationLatLong] as String,
        timeStamp: map[LocationFields.timeStamp] as String);
  }
}
