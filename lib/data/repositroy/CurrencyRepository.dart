import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Chart.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CurrencyRepository {
  Dio _dio = Dio();
  Future<Either<String, String>> updatePrice(int id, double buy, double sell,
      String buystate, String sellstate, String type) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _token = _prefs.get('token');
      _dio.options.headers['authorization'] = 'Bearer $_token';
      print('transfer');
      if (type == "transfer") {
        String completeUrl = '$transfersUrl/$id';
        print(completeUrl);
        var updateResponse = await _dio.put(completeUrl,
            data: jsonEncode({
              "sell_status": sellstate,
              "buy": buy,
              "sell": sell,
              "buy_status": buystate
            }));
        var mystatus = updateResponse.data['status'];
        print(updateResponse);
        if (mystatus == "success") {
          return Right(mystatus);
        } else {
          return Left(mystatus);
        }
      } else if (type == "currency") {
        String completeUrl = '$currencyUpdateUrl$id';
        print(completeUrl);
        var updateResponse = await _dio.put(completeUrl,
            data: jsonEncode({
              "sell_status": sellstate,
              "buy": buy,
              "sell": sell,
              "buy_status": buystate
            }));
        var mystatus = updateResponse.data['status'];
        print(updateResponse);
        if (mystatus == "success") {
          return Right(mystatus);
        } else {
          return Left(mystatus);
        }
      }
      return Left('erroe');
    } catch (e) {
      return Left('error');
    }
  }

  //Drawer Chart
  Future<Either<String, List<DataChanges>>> drawChart(
      int cityid, String fromdate) async {
    print(fromdate);

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var _token = _prefs.get('token');
    _dio.options.headers['authorization'] = 'Bearer $_token';
    //check time get
    String endFromdate;
    var now = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    endFromdate = newFormat.format(now);
    if (fromdate == 'منذ ساعة') {
      print('one hours');
      endFromdate = new DateTime(now.year, now.month, now.day, now.hour - 1,
              now.second, now.minute)
          .toString();
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$now';
      var chartResponse = await _dio.get(
        completeUrl,
      );
      print(chartResponse.data);
      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }
    } else if (fromdate == 'منذ ثلاثة ساعات') {
      endFromdate = new DateTime(now.year, now.month, now.day, now.hour - 3,
              now.second, now.minute)
          .toString();
      print('three hours');
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$now';
      var chartResponse = await _dio.get(
        completeUrl,
      );
      print(chartResponse.data);
      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }

      // print(endFromdate);
      // print(todate);
      // String completeUrl =
      //     '$chartUrl$cityid&from_date=$endFromdate&to_date=$todate';
      // var chartResponse = await _dio.get(
      //   completeUrl,
      // );
      // print(chartResponse);
      // if (chartResponse.data['status'] == "success") {
      //   var response = Data.fromJson(chartResponse.data['data']);
      //   return Right(response.dataChanges);
      // } else {
      //   return Left('error');
      // }
    } else if (fromdate == 'منذ سبعة ساعات') {
      print('six hours');
      endFromdate = new DateTime(now.year, now.month, now.day, now.hour - 6,
              now.second, now.minute)
          .toString();
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$now';
      var chartResponse = await _dio.get(
        completeUrl,
      );
      print(chartResponse);

      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }
    } else if (fromdate == 'منذ يوم') {
      print('day');
      endFromdate = new DateTime(now.year, now.month, now.day - 1, now.hour,
              now.second, now.minute)
          .toString();
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$now';
      var chartResponse = await _dio.get(
        completeUrl,
      );
      print(chartResponse);
      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }
    } else if (fromdate == 'منذ ثلاثة أيام') {
      endFromdate = new DateTime(now.year, now.month, now.day - 3, now.hour,
              now.microsecond, now.minute)
          .toString();
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$now';
      var chartResponse = await _dio.get(
        completeUrl,
      );

      if (chartResponse.data['status'] == "success") {
        print('enter');
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        print('enter');
        return Left('error');
      }
    } else if (fromdate == 'منذ سبعة أيام') {
      endFromdate = new DateTime(now.year, now.month, now.day - 7, now.hour,
              now.microsecond, now.minute)
          .toString();
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$now';
      var chartResponse = await _dio.get(
        completeUrl,
      );

      if (chartResponse.data['status'] == "success") {
        print('enter');
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        print('enter');
        return Left('error');
      }
    } else if (fromdate == 'منذ شهر') {
      endFromdate = new DateTime(now.year, now.month - 1, now.day, now.hour,
              now.microsecond, now.minute)
          .toString();
      String completeUrl =
          '$chartUrl$cityid&from_date=$endFromdate&to_date=$now';
      var chartResponse = await _dio.get(
        completeUrl,
      );

      if (chartResponse.data['status'] == "success") {
        print('enter');
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        print('enter');
        return Left('error');
      }
    } else {
      String completeUrl = '$chartUrl$cityid&from_date=$fromdate&to_date=$now';
      var chartResponse = await _dio.get(
        completeUrl,
      );

      if (chartResponse.data['status'] == "success") {
        var response = Data.fromJson(chartResponse.data['data']);
        return Right(response.dataChanges);
      } else {
        return Left('error');
      }
    }
  }
}
