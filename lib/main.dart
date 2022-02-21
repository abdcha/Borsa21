import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_state.dart';
import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/repositroy/AdvertisementRepository.dart';
import 'package:central_borssa/data/repositroy/AuctionRepository.dart';
import 'package:central_borssa/data/repositroy/CityRepository.dart';
import 'package:central_borssa/data/repositroy/CompanyRepository.dart';
import 'package:central_borssa/data/repositroy/CurrencyRepository.dart';
import 'package:central_borssa/data/repositroy/PostRepository.dart';
import 'package:central_borssa/data/repositroy/loginRepository.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:central_borssa/presentation/Main/SkipePage.dart';
import 'package:central_borssa/presentation/Share/Welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'business_logic/Advertisement/bloc/advertisement_bloc.dart';
import 'business_logic/Auction/bloc/auction_bloc.dart';
import 'business_logic/Chat/bloc/chat_bloc.dart';
import 'business_logic/Global Auction/bloc/globalauction_bloc.dart';
import 'business_logic/Login/bloc/login_bloc.dart';
import 'data/repositroy/ChatRepository.dart';
import 'data/repositroy/GlobalAuctionRepository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset('assest/Images/test2.png'),
            nextScreen: MyHomePage(),
            splashIconSize: 300,

            // splashTransition: SplashTransition.slideTransition,
            backgroundColor: navbar));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future test;
  late String token = "";

  Future<String?> getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Firebase.initializeApp();

    print('firebase');

    setState(() {
      if (prefs.getString('token') != null) {
        token = prefs.getString('token').toString();
      } else if (prefs.getString('token') == null) {
        print('null from main');
        token = 'trader';
      } else {
        token = 'error';
      }
    });
    return token;
  }

  @override
  void initState() {
    super.initState();
    test = getValue();
  }

  @override
  void dispose() {
    // refreshController.dispose();
    super.dispose();
  }

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
          BlocProvider(
            create: (context) => ChatBloc(ChatInitial(), ChatRepository()),
          ),
          BlocProvider(
            create: (context) =>
                AuctionBloc(AuctionInitial(), AuctionRepository()),
          ),
          BlocProvider(
            create: (context) => GlobalauctionBloc(
                GlobalauctionInitial(), GlobalAuctionRepository()),
          ),
          BlocProvider(
            create: (context) => AdvertisementBloc(
                AdvertisementInitial(), AdvertisementRepository()),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: FutureBuilder(
              future: test,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    print('HomeOfApp');
                    return HomeOfApp();
                  case ConnectionState.waiting:
                    print('waiting');
                    return Welcome();
                  case ConnectionState.active:
                    print('active');
                    return SkipePage();
                  case ConnectionState.done:
                    // print('done');
                    if (token == 'error') {
                      print('hi $token');
                      return SkipePage();
                    } else {
                      print('main skipe');
                      return HomeOfApp();
                    }
                    // ignore: dead_code
                    break;
                  default:
                    print('default');
                    return Container(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                }
              },
            )));
  }
}
