import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Auction.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuctionRepository {
  Dio _dio = new Dio();
  Future<Either<String, List<Auctions>>> getAllAuctions() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _token = _prefs.getString('token');

      _dio..options.headers['authorization'] = 'Bearer $_token';

      var response = await _dio.get(auctionGetUrl);
      print(response);
      var status = response.data['status'];
      var allcurrency = Data.fromJson(response.data['data']);
      print(allcurrency);

      if (status == "success") {
        return Right(allcurrency.auctions);
      } else {
        return Left("error");
      }
    } catch (e) {
      return Left("error");
    }
  }
}
