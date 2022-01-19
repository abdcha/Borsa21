import 'dart:convert';
import 'package:central_borssa/data/model/Permission.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:central_borssa/constants/url.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

class LoginRepository {
  Future<Either<String, dynamic>> login(String phone, String password) async {
    Dio _dio = Dio();

    var loginResponse = await _dio.post(baseUrl,
        data: jsonEncode(({"phone": phone, "password": password})));
    print(loginResponse);
    if (loginResponse.data['status'] == "success") {
      print('from login');
      //Start store token
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _responsetoken = loginResponse.data['data']['token'];
      _prefs.setString('token', _responsetoken);

      //User Informations
      _dio.options.headers['authorization'] = 'Bearer $_responsetoken';
      var permissionResponse = await _dio.get(permissionUrl);
      // print(permissionResponse);
      var userInformations =
          new UserPermission.fromJson(permissionResponse.data['data']);
      await _prefs.setString('username', userInformations.user.name);
      await _prefs.setString('userpassword', password);
      await _prefs.setString('userphone', userInformations.user.phone);
      await _prefs.setInt('useractive', userInformations.user.active);
      await _prefs.setInt('userid', userInformations.user.id);
      await _prefs.setInt('companyid', userInformations.user.companyid);

      //permissions

      late List<String> permissions = [];
      for (var i = 0; i < userInformations.permission.length; i++) {
        permissions.add(userInformations.permission[i].name);
      }
      await _prefs.setStringList('permissions', permissions);
      print(permissions);

      //Active subscribtions
      if (userInformations.user.endSubscription != null) {
        await _prefs.setString('end_subscription',
            userInformations.user.endSubscription!.endAt.toString());
      }

      //User Type
      await _prefs.setString('roles', userInformations.roles.first);

      return Right(loginResponse.data['status']);
    }
    if (loginResponse.data['status'] == "error") {
      return Left("Error");
    } else {
      return Left("Error");
    }
  }

  Future<Either<String, dynamic>> loginTrader(
      String phone, String password, String name, String email) async {
    Dio _dio = Dio();
    print(logintraderUrl);
    var loginResponse = await _dio.post(logintraderUrl,
        data: jsonEncode(({
          "phone": phone,
          "password": password,
          "name": name,
          "email": email
        })));
    print(loginResponse);
    if (loginResponse.data['status'] == "success") {
      //Start store token
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _responsetoken = loginResponse.data['data']['token'];
      _prefs.setString('token', _responsetoken);

      //User Informations
      _dio.options.headers['authorization'] = 'Bearer $_responsetoken';
      var permissionResponse = await _dio.get(permissionUrl);
      // print(permissionResponse);
      var userInformations =
          new UserPermission.fromJson(permissionResponse.data['data']);
      await _prefs.setString('username', userInformations.user.name);
      await _prefs.setString('userpassword', password);
      await _prefs.setString('userphone', userInformations.user.phone);
      await _prefs.setInt('useractive', userInformations.user.active);
      await _prefs.setInt('userid', userInformations.user.id);
      await _prefs.setInt('companyid', userInformations.user.companyid);

      //permissions

      late List<String> permissions = [];
      for (var i = 0; i < userInformations.permission.length; i++) {
        permissions.add(userInformations.permission[i].name);
      }
      await _prefs.setStringList('permissions', permissions);
      print(permissions);

      //Active subscribtions
      if (userInformations.user.endSubscription != null) {
        await _prefs.setString('end_subscription',
            userInformations.user.endSubscription!.endAt.toString());
      }

      //User Type
      await _prefs.setString('roles', userInformations.roles.first);

      return Right(loginResponse.data['status']);
    }
    if (loginResponse.data['status'] == "error") {
      return Left("Error");
    } else {
      return Left("Error");
    }
  }

  Future<Either<String, String>> meInformation() async {
    print('from meinformation start');
    Dio _dio = Dio();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.get('token');
    _dio.options.headers['authorization'] = 'Bearer $token';
    var permissionResponse = await _dio.get(permissionUrl);
    print(permissionResponse);
    if (token != null) {
      print('inside me in');
      print(permissionUrl);
      if (permissionResponse.data['status'] == 'error') {
        return left('error');
      } else {
        // print(permissionResponse);
        var userInformations =
            new UserPermission.fromJson(permissionResponse.data['data']);
        await _prefs.setString('username', userInformations.user.name);
        await _prefs.setString('userphone', userInformations.user.phone);
        await _prefs.setInt('useractive', userInformations.user.active);
        await _prefs.setInt('userid', userInformations.user.id);
        await _prefs.setInt('companyid', userInformations.user.companyid);

        //permissions

        late List<String> permissions = [];
        for (var i = 0; i < userInformations.permission.length; i++) {
          permissions.add(userInformations.permission[i].name);
        }
        await _prefs.setStringList('permissions', permissions);
        print(permissions);

        //Active subscribtions
        if (userInformations.user.endSubscription != null) {
          await _prefs.setString('end_subscription',
              userInformations.user.endSubscription!.endAt.toString());
        }

        //User Type
        await _prefs.setString('roles', userInformations.roles.first);

        return Right(permissionResponse.data['status']);
      }
    } else {
      return Left('error');
    }
  }

  Future<Either<String, String>> fcmToken(String? fcmToken) async {
    Dio _dio = Dio();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.get('token');
    _dio.options.headers['authorization'] = 'Bearer $token';

    if (token != null && fcmToken != null) {
      print('test');
      var test = fcmToken;
      var fcmTokenresponse = await _dio.post(sendFcmtoken,
          data: jsonEncode(({"fcm_token": test})));

      if (fcmTokenresponse.data['status'] == "success") {
        return Right('success');
      } else {
        return Left('error');
      }
    } else {
      return Left('error');
    }
  }

  Future<Either<String, String>> logout() async {
    Dio _dio = Dio();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.get('token');
    _dio.options.headers['authorization'] = 'Bearer $token';
    if (token != null) {
      var response = await _dio.get(logoutUrl);
      if (response.data['status'] == 'success') {
        return Right('success');
      } else
        return Left('error');
    } else {
      return Left('error');
    }
  }
}
