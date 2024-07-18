import 'dart:convert';

String driverRegistrationRequestToJson(DriverRegistrationRequest data) => json.encode(data.toJson());

class DriverRegistrationRequest {
    final String vehicleType;
    final String phone;
    final String vehicleNumber;
    final double latitude;
    final double longitude;

    DriverRegistrationRequest({
        required this.vehicleType,
        required this.phone,
        required this.vehicleNumber,
        required this.latitude,
        required this.longitude,
    });


    Map<String, dynamic> toJson() => {
        "vehicleType": vehicleType,
        "phone": phone,
        "vehicleNumber": vehicleNumber,
        "latitude": latitude,
        "longitude": longitude,
    };
}
