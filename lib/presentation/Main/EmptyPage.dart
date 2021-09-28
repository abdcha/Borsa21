import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/repositroy/CityRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  EmptyPage_page createState() => EmptyPage_page();
}

// ignore: camel_case_types
class EmptyPage_page extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BorssaBloc(BorssaInitial(), CityRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text(
              "ليس لديك الصلاحية لمشاهدة هذا المحتوى",
            ),
          ),
        ),
      ),
    );
  }
}
