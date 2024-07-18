// To parse this JSON data, do
//
//     final driver = driverFromJson(jsonString);

import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
    final CurrentLocation currentLocation;
    final String verification;
    final String verificationMessage;
    final String id;
    final String driver;
    final String vehicleType;
    final String phone;
    final String vehicleNumber;
    final bool isAvailable;
    final int rating;
    final int totalDeliveries;
    final String profileImage;
    final bool isActive;

    Driver({
        required this.currentLocation,
        required this.verification,
        required this.verificationMessage,
        required this.id,
        required this.driver,
        required this.vehicleType,
        required this.phone,
        required this.vehicleNumber,
        required this.isAvailable,
        required this.rating,
        required this.totalDeliveries,
        required this.profileImage,
        required this.isActive,
    });

    factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        currentLocation: CurrentLocation.fromJson(json["currentLocation"]),
        verification: json["verification"],
        verificationMessage: json["verificationMessage"],
        id: json["_id"],
        driver: json["driver"],
        vehicleType: json["vehicleType"],
        phone: json["phone"],
        vehicleNumber: json["vehicleNumber"],
        isAvailable: json["isAvailable"],
        rating: json["rating"],
        totalDeliveries: json["totalDeliveries"],
        profileImage: json["profileImage"],
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "currentLocation": currentLocation.toJson(),
        "verification": verification,
        "verificationMessage": verificationMessage,
        "_id": id,
        "driver": driver,
        "vehicleType": vehicleType,
        "phone": phone,
        "vehicleNumber": vehicleNumber,
        "isAvailable": isAvailable,
        "rating": rating,
        "totalDeliveries": totalDeliveries,
        "profileImage": profileImage,
        "isActive": isActive,
    };
}

class CurrentLocation {
    final double latitude;
    final double longitude;

    CurrentLocation({
        required this.latitude,
        required this.longitude,
    });

    factory CurrentLocation.fromJson(Map<String, dynamic> json) => CurrentLocation(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}
