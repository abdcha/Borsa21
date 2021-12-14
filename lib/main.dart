import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_state.dart';
import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/data/repositroy/AdvertisementRepository.dart';
import 'package:central_borssa/data/repositroy/AuctionRepository.dart';
import 'package:central_borssa/data/repositroy/CityRepository.dart';
import 'package:central_borssa/data/repositroy/CompanyRepository.dart';
import 'package:central_borssa/data/repositroy/CurrencyRepository.dart';
import 'package:central_borssa/data/repositroy/PostRepository.dart';
import 'package:central_borssa/data/repositroy/loginRepository.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
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

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//   //   print("message recieved");
//   //   // if (event.notification!.body != null) {
//   //   //   print("body " + event.notification!.body!);
//   //   //   print(event.notification!.bodyLocArgs);
//   //   //   print(event.notification!.titleLocArgs);
//   //   //   print(event.notification);
//   //   // }

//   //   // print(event.notification);
//   // });
//   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
//   //   print("message open");
//   //   // print(event.notification!.body);
//   //   if (event.notification!.body != null) {
//   //     print("body " + event.notification!.body!);
//   //     print(event.notification!.bodyLocArgs);
//   //     print(event.notification!.titleLocArgs);
//   //     print(event.data);
//   //     // print(event.notification.);
//   //   }
//   // });
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
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
    // prefs.clear();
    await Firebase.initializeApp();
    print('firebase');
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    setState(() {
      if (prefs.getString('token') != null) {
        token = prefs.getString('token').toString();
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

                return Loginpage();
              case ConnectionState.done:
                print('done');
                if (token == "" || token == 'error') {
                  print('hi $token');
                  return Loginpage();
                } else {
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
