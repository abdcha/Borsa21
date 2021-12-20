import 'dart:convert';

import 'package:central_borssa/constants/url.dart';
import 'package:central_borssa/data/model/Post/CompanyPost.dart';
import 'package:central_borssa/data/model/Post/CompanyInfo.dart' as companyinf;

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
      String urledit =
          '$allCompanyPost$number?pageSize=$pagesize&sort=desc&page=$page';
      var companyPostResponse = await _dio.get(urledit);
      var data = new Data.fromJson(companyPostResponse.data['data']);
      if (data.toString() != "") {
        return Right(data);
      } else {
        return Left('error');
      }
      // print(data.posts);
    } catch (e) {
      return Left('error');
    }
  }

  Future<Either<String, dynamic>> getCompanyInfo(int number) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.get('token');
    _dio.options.headers['authorization'] = 'Bearer $token';
    String urledit = '$allCompanyinfo$number';
    print(urledit);
    print('object');
    var companyPostResponse = await _dio.get(urledit);
    var data = new companyinf.Data.fromJson(companyPostResponse.data['data']);
    print(companyPostResponse);
    if (data.toString() != "") {
      return Right(data);
    } else {
      return Left('error');
    }
  }

  Future<Either<String, dynamic>> getAllCompanyName() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      _dio.options.headers['authorization'] = 'Bearer $token';
      var companyNameResponse = await _dio.get(allCompany);
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

  Future<Either<String, String>> editPost(
      String body, String? image, int id) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var token = _pref.get('token');
    _dio.options.headers['authorization'] = 'Bearer $token';
    var postResponse;
    if (image == "" && body != "") {
      postResponse = await _dio.put('$editanddeletePost$id',
          data: jsonEncode(({"body": body, "image": null})));
    } else if (image != null && image != "") {
      if (image != "https://centralborsa.com/uploads/placeholder.jpg" &&
          image != "https://centralborsa.comno_image") {
        postResponse = await _dio.put('$editanddeletePost$id',
            data: jsonEncode(({"body": body, "image": image})));
      } else {
        postResponse = await _dio.put('$editanddeletePost$id',
            data: jsonEncode(({"body": body, "image": image})));
      }
    }

    // print(postResponse);
    if (postResponse.data['status'] == "success") {
      return Right('success');
    } else if (postResponse.data['status'] == "error") {
      return Left('error');
    } else {
      return Left('error');
    }
  }

  Future<Either<String, String>> deletePost(int id) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      var token = _pref.get('token');
      _dio.options.headers['authorization'] = 'Bearer $token';
      var postResponse;
      String url = 'https://centralborsa.com/api/posts/$id';
      postResponse = await _dio.delete(url);
      print(postResponse);

      print(postResponse);
      if (postResponse.data['status'] == "success") {
        print('from here');
        return Right('success');
      } else if (postResponse.data['status'] == "error") {
        return Left('error');
      } else {
        return Left('error');
      }
    } catch (e) {
      return Left('error is catched');
    }
  }
}
