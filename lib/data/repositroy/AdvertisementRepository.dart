import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Advertisement.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvertisementRepository {
  Dio _dio = new Dio();
  Future<Either<String, List<Advertisements>>> getAdvertisement() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _token = _prefs.getString('token');
      _dio..options.headers['authorization'] = 'Bearer $_token';
      var response = await _dio.get(advertisementUrl);
      print(response);
      var status = response.data['status'];
      var allcurrency = Data.fromJson(response.data['data']);
      print(allcurrency);
      if (status == "success") {
        return Right(allcurrency.advertisements);
      } else {
        return Left("error");
      }
    } catch (e) {
      return Left("error");
    }
  }
}
