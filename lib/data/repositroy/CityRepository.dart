import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityRepository {
  Dio _dio = new Dio();
  late List<CurrencyPrice> mycities = [];
  Future<Either<String, List<CurrencyPrice>>> allCity() async {
    mycities.clear();

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _token = _prefs.getString('token');

      _dio..options.headers['authorization'] = 'Bearer $_token';

      var response = await _dio.get(currencyUpdateUrl);
      print(response);
      var status = response.data['status'];
      var allcurrency = Data.fromJson(response.data['data']);
      print(allcurrency);

      allcurrency.currencyPrice.forEach((v) {
        mycities.add(v);
      });
      print(allcurrency);
      if (status == "success") {
        return Right(mycities);
      } else {
        return Left("error");
      }
    } catch (e) {
      return Left("error");
    }
  }
}
