import 'dart:math';
import 'package:foodly_driver/models/distance_time.dart';

class Distance {
  DistanceTime calculateDistanceTimePrice(double lat1, double lon1, double lat2,
      double lon2, double speedKmPerHr, double pricePerKm) {
    // Chuyển đổi vĩ độ và kinh độ từ độ sang radian
    var rLat1 = _toRadians(lat1);
    var rLon1 = _toRadians(lon1);
    var rLat2 = _toRadians(lat2);
    var rLon2 = _toRadians(lon2);

    // Haversine formula
    var dLat = rLat2 - rLat1;
    var dLon = rLon2 - rLon1;
    var a =
        pow(sin(dLat / 2), 2) + cos(rLat1) * cos(rLat2) * pow(sin(dLon / 2), 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Bán kính của trái đất tính bằng km
    const double earthRadiusKm = 6371.0;
    var distance = (earthRadiusKm * 2) * c;

    //Tính thời gian (khoảng cách / tốc độ)
    var time = distance / speedKmPerHr;

    // Tính giá (khoảng cách * Tỷ lệ mỗi km)
    var price = distance * pricePerKm;

    return DistanceTime(distance: distance, time: time, price: price);
  }

//Chức năng của người trợ giúp để chuyển đổi độ thành radian
  double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
