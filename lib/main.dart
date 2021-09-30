import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/data/repositroy/CityRepository.dart';
import 'package:central_borssa/data/repositroy/CompanyRepository.dart';
import 'package:central_borssa/data/repositroy/CurrencyRepository.dart';
import 'package:central_borssa/data/repositroy/PostRepository.dart';
import 'package:central_borssa/data/repositroy/loginRepository.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/Login/bloc/login_bloc.dart';

void main() {
  runApp(MyApp());
}

Future<String?> getValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var stringValue = prefs.getString('token');

  // prefs.clear();
  // print(stringValue);
  return stringValue;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LoginBloc(LoginInitialState(), LoginRepository()),
          ),
          BlocProvider(
            create: (context) => BorssaBloc(BorssaInitial(), CityRepository()),
          ),
          BlocProvider(
            create: (context) => PostBloc(PostInitial(), PostRepository()),
          ),
          BlocProvider(
            create: (context) =>
                CompanyBloc(CompanyInitial(), CompanyRepository()),
          ),
          BlocProvider(
            create: (context) =>
                CurrencyBloc(CurrencyInitial(), CurrencyRepository()),
          ),
        ],
        child: MaterialApp(
          home: FutureBuilder(
              future: getValue(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);

                  if (snapshot.data == null) {
                    print('hi 1');
                    return Loginpage();
                  } else {
                    print('hi 2');
                    return HomeOfApp();
                  }
                } else
                  return HomeOfApp();
              }),
        ));
  }
}
