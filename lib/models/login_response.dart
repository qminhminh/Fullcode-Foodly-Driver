// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    final String id;
    final String username;
    final String email;
    final String userType;
    final String profile;
    final String phone;
    final String userToken;

    LoginResponse({
        required this.id,
        required this.username,
        required this.email,
        required this.userType,
        required this.profile,
        required this.phone,
        required this.userToken,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        userType: json["userType"],
        profile: json["profile"],
        phone: json["phone"],
        userToken: json["userToken"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "userType": userType,
        "profile": profile,
        "phone": phone,
        "userToken": userToken,
    };
}
