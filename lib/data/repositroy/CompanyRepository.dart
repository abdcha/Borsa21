import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Post/CompanyPost.dart';
import 'package:dartz/dartz.dart';
import 'package:central_borssa/data/model/Post/Cities.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyRepository {
  Dio _dio = Dio();

  Future<Either<String, dynamic>> getAllCompanypost(
      int number, int pagesize, String date, int page) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      _dio.options.headers['authorization'] = 'Bearer $token';
      print('value $page');
      String urledit =
          '$allCompanyPost$number?pageSize=$pagesize&date=desc&page=$page';
      var companyPostResponse = await _dio.get(urledit);
      print(companyPostResponse.data['data']);
      var data = new Data.fromJson(companyPostResponse.data['data']);
      if (data != "") {
        return Right(data);
      } else {
        return Left('error');
      }
      // print(data.posts);
    } catch (e) {
      return Left('error');
    }
  }

  Future<Either<String, dynamic>> getAllCompanyName() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      _dio.options.headers['authorization'] = 'Bearer $token';
      var companyNameResponse = await _dio.get(allCompany);
      print(companyNameResponse.data['data']);
      var response = data.fromJson(companyNameResponse.data['data']);
      if (companyNameResponse.data['status'] == 'success') {
        return Right(response.lists);
      } else {
        return Left('error');
      }
      // print(data.posts);
    } catch (e) {
      return Left('error');
    }
  }

  Future<Either<bool, bool>> follow(int companyId) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      _dio.options.headers['authorization'] = 'Bearer $token';
      String urledit = '$followUrl$companyId';
      var companyPostResponse = await _dio.get(urledit);
      print(companyPostResponse.data['data']);
      var data = companyPostResponse.data['status'];
      if (data == "success") {
        return Right(true);
      } else {
        return Left(false);
      }
    } catch (e) {
      return Left(false);
    }
  }

  Future<Either<bool, bool>> unFollow(int companyId) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      _dio.options.headers['authorization'] = 'Bearer $token';
      String urledit = '$unfollowUrl$companyId';
      var companyPostResponse = await _dio.get(urledit);
      print(companyPostResponse.data['data']);
      var data = companyPostResponse.data['status'];
      if (data == "success") {
        return Right(true);
      } else {
        return Left(false);
      }
    } catch (e) {
      return Left(false);
    }
  }
}
