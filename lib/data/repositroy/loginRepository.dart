import 'dart:convert';
import 'package:central_borssa/data/model/Permission.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:central_borssa/constants/url.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

class LoginRepository {
  Future<Either<String, dynamic>> login(String phone, String password) async {
    Dio _dio = Dio();
    // late List<Permissions> userpermissions = [];
    //Start Login evaluation
    print('from here teest');
    print(baseUrl);
    var loginResponse = await _dio.post(baseUrl,
        data: jsonEncode(({"phone": phone, "password": password})));
    print(loginResponse);
    if (loginResponse.data['status'] == "success") {
      //Start store token
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _responsetoken = loginResponse.data['data']['token'];
      _prefs.setString('token', _responsetoken);
      print('from permisiions');
      //User Informations
      _dio.options.headers['authorization'] = 'Bearer $_responsetoken';
      var permissionResponse = await _dio.get(permissionUrl);
      print(permissionResponse);
      var userInformations =
          new UserPermission.fromJson(permissionResponse.data['data']);
      await _prefs.setString('username', userInformations.user.name);
      await _prefs.setString('userphone', userInformations.user.phone);
      await _prefs.setInt('useractive', userInformations.user.active);
      await _prefs.setInt('userid', userInformations.user.id);
      await _prefs.setInt('companyid', userInformations.user.companyid);

      print(userInformations);
      //permissions
      // userInformations.premissions
      //     .map((ourpermision) => userpermissions.add(ourpermision));
      // print(userpermissions);
      // await _prefs.setStringList('permissions', userpermissions);
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
}
