import 'dart:convert';

List<Restaurants> restaurantsFromJson(String str) => List<Restaurants>.from(
    json.decode(str).map((x) => Restaurants.fromJson(x)));

String restaurantsToJson(List<Restaurants> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Restaurants {
  final String id;
  final String title;
  final String time;
  final String imageUrl;
  final String owner;
  final String code;
  final bool isAvailable;
  final bool pickup;
  final bool delivery;
  final List<dynamic>? foods;
  final String logoUrl;
  final double rating;
  final String ratingCount;
  final Coords coords;

  Restaurants({
    required this.id,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.owner,
    required this.code,
    required this.isAvailable,
    required this.pickup,
    required this.delivery,
    this.foods,
    required this.logoUrl,
    required this.rating,
    required this.ratingCount,
    required this.coords,
  });

  factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        imageUrl: json["imageUrl"],
        owner: json["owner"],
        code: json["code"],
        isAvailable: json["isAvailable"],
        pickup: json["pickup"],
        delivery: json["delivery"],
        foods: json["foods"] == null
            ? []
            : List<dynamic>.from(json["foods"]!.map((x) => x)),
        logoUrl: json["logoUrl"],
        rating: json["rating"].toDouble(),
        ratingCount: json["ratingCount"],
        coords: Coords.fromJson(json["coords"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "imageUrl": imageUrl,
        "owner": owner,
        "code": code,
        "isAvailable": isAvailable,
        "pickup": pickup,
        "delivery": delivery,
        "foods": foods == null ? [] : List<dynamic>.from(foods!.map((x) => x)),
        "logoUrl": logoUrl,
        "rating": rating,
        "ratingCount": ratingCount,
        "coords": coords.toJson(),
      };
}

class Coords {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final String title;
  final double latitudeDelta;
  final double longitudeDelta;

  Coords({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.title,
    required this.latitudeDelta,
    required this.longitudeDelta,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        address: json["address"],
        title: json["title"],
        latitudeDelta: json["latitudeDelta"]?.toDouble(),
        longitudeDelta: json["longitudeDelta"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "title": title,
        "latitudeDelta": latitudeDelta,
        "longitudeDelta": longitudeDelta,
      };
}
