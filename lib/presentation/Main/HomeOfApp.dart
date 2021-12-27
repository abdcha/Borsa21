import 'package:badges/badges.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/presentation/Admin/Profile.dart';
import 'package:central_borssa/presentation/Auction/Auction.dart';
import 'package:central_borssa/presentation/Auction/GlobalAuction.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:central_borssa/presentation/Share/Welcome.dart';
import 'package:central_borssa/presentation/Trader/Trader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Home/Central_Borssa.dart';
import '..//Home/MainChat.dart';
import '../Home/All_post.dart';
import '../Home/Company_Profile.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:connectivity/connectivity.dart';

class HomeOfApp extends StatefulWidget {
  home_page createState() => home_page();
}

// ignore: camel_case_types
class home_page extends State<HomeOfApp>
    with AutomaticKeepAliveClientMixin<HomeOfApp> {
  int selectedPage = 0;
  late LoginBloc _loginBloc;
  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  int companyuser = 0;
  late String userActive = "";
  int messageUnread = 0;
  int notificationcount = 0;
  late String temp2 = "ss";
  bool allow = true;
  sharedValue() async {
    print('2');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await FirebaseMessaging.instance.getToken();

    _loginBloc.add(FireBaseTokenEvent(fcmToken: token));

    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    print(prefs.get('token').toString());
    userLocation = "Empty";
    if (prefs.get('end_at') != null) {
      userActive = prefs.get('end_at').toString();
    }
    userPermissions = prefs.getStringList('permissions')!.toList();
    var y = userPermissions.contains('Update_Auction_Price_Permission');
    print('user permission$y');
    print(userLocation);
    companyuser = int.parse(prefs.get('companyid').toString());
    print(companyuser);
    userType = prefs.get('roles').toString();
    setState(() {});
  }

  internetCheck() async {
    final ping = Ping('google.com', count: 5);
    print('Running command: ${ping.command}');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('I am connected to a mobile network');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print(' I am connected to a wifi network');
    }
  }

  fireBase() async {
    FirebaseMessaging.onMessage.handleError((error) {
      print("Erorrrrrr : ${error.toString()}");
    }).listen((event) {
      if (userPermissions.contains('Trader_Permission')) {
        if (event.data['type'] == "trader_currency_price_change") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        } else if (event.data['type'] == "currency_price_change" &&
            userActive != "") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        } else if (event.data['type'] == "transfer_change" &&
            userActive != "") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        } else if (event.data['type'] == "renew_subscription") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
          setState(() {
            selectedPage = 1;
          });
        }
      } else if (userPermissions.contains('Chat_Permission') &&
          userActive != "") {
        if (event.data['type'] == "new_followed_post") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        } else if (event.data['type'] == "renew_subscription") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
          setState(() {
            selectedPage = 1;
          });
        } else if (event.data['type'] == "new_chat") {
          setState(() {
            messageUnread++;
          });
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return Center(
          //           child: AlertDialog(
          //               title: const Text(''),
          //               content: SingleChildScrollView(
          //                 child: ListBody(
          //                   children: const <Widget>[
          //                     Text('تجديد إشتراك'),
          //                     Text('لقد تم تجديد إشتراكّ'),
          //                   ],
          //                 ),
          //               )));
          //     });
        } else if (event.data['type'] == "currency_price_change") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        } else if (event.data['type'] == "transfer_change") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        } else if (event.data['type'] == "new_auction") {
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(temp2),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
  //test

  callBody(int value) {
    if (userPermissions.contains('Chat_Permission')) {
      switch (value) {
        case 0:
          return AllPost();
        case 1:
          return CentralBorssa();
        case 2:
          return MainChat();
        case 3:
          return CompanyProfile();
          // ignore: dead_code
          break;
        default:
      }
    } else if (userPermissions.contains('Trader_Permission')) {
      switch (value) {
        case 0:
          return Trader();
        case 1:
          return CentralBorssa();
        case 2:
          return GlobalAuction();
        case 3:
          return Auction();

          // ignore: dead_code
          break;
        default:
      }
    } else if (userPermissions.contains('Update_Auction_Price_Permission')) {
      switch (value) {
        case 0:
          return CentralBorssa();
        case 1:
          return Profile();
          // ignore: dead_code
          break;
        default:
      }
    }
  }

  late Future navbarbottom;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    fireBase();
    navbarbottom = sharedValue();
    super.initState();
  }

  myfire() {
    print('test');
    _loginBloc.add(MeInformationEvent());
  }

  choosePage(int index) async {
    await myfire();
    if (selectedPage != index && allow) {
      print('1');
      setState(() {
        selectedPage = index;
      });
    }
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return FutureBuilder(
        future: navbarbottom,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Welcome();
            case ConnectionState.none:
              return Welcome();
            case ConnectionState.active:
              return Welcome();
            case ConnectionState.done:
              return Scaffold(
                  key: _scaffoldKey,
                  body: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is FcmTokenLoading) {
                        print(state);
                      } else if (state is FcmTokenLoaded) {
                        print(state);
                      } else if (state is FcmTokenError) {
                        print(state);
                      }
                      if (state is MeInformationLoading) {
                        print(state);
                      } else if (state is MeInformationLoaded) {
                        print(state);
                      } else if (state is MeInformationError) {
                        setState(() {
                          allow = false;
                        });
                        print(state);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          logout();
                          return Loginpage();
                        }));
                      }
                    },
                    child: callBody(selectedPage),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Color(navbar.hashCode),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white.withOpacity(.60),
                    selectedFontSize: 14,
                    unselectedFontSize: 14,
                    currentIndex: selectedPage,
                    onTap: choosePage,
                    items: [
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'الرئيسية',
                          icon: Icon(Icons.home),
                        ),
                      if (userPermissions.contains('Trader_Permission'))
                        BottomNavigationBarItem(
                          label: 'الرئيسية',
                          icon: Icon(Icons.person_rounded),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions.contains('Trader_Permission') ||
                          userPermissions
                              .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'البورصة',
                          icon: Icon(Icons.attach_money),
                        ),
                      if (userPermissions.contains('Trader_Permission'))
                        BottomNavigationBarItem(
                          label: 'البورصة العالمية',
                          icon: Icon(Icons.public_outlined),
                        ),
                      if (userPermissions.contains('Trader_Permission'))
                        BottomNavigationBarItem(
                          label: 'المزاد المركزي',
                          icon: Icon(Icons.account_balance_sharp),
                        ),
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'المحادثة',
                          icon: Icon(Icons.chat_outlined),
                          // Badge(
                          //   badgeContent: messageUnread == 0
                          //       ? Container(
                          //           color: Colors.transparent,
                          //         )
                          //       : Text(messageUnread.toString()),
                          //   child:
                          //   Icon(Icons.chat_outlined),
                          // ),
                        ),
                      if (userPermissions
                          .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'الشخصية',
                          icon: Icon(Icons.person_rounded),
                        ),
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'الشخصية',
                          icon: Icon(Icons.person_rounded),
                        ),
                    ],
                  ));

              // ignore: dead_code
              break;
            default:
              return Scaffold(
                  key: _scaffoldKey,
                  body: callBody(selectedPage),
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Color(navbar.hashCode),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white.withOpacity(.60),
                    selectedFontSize: 14,
                    unselectedFontSize: 14,
                    currentIndex: selectedPage,
                    onTap: choosePage,
                    items: [
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'الأساسية',
                          icon: Icon(Icons.home),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions.contains('Trader_Permission') ||
                          userPermissions
                              .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'مزاد العملات',
                          icon: Icon(Icons.attach_money),
                        ),
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'المحادثة',
                          icon: Icon(Icons.chat_outlined),
                        ),
                      if (userPermissions.contains('Chat_Permission'))
                        BottomNavigationBarItem(
                          label: 'الشخصية',
                          icon: Icon(Icons.person_rounded),
                        ),
                      if (userPermissions
                          .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'الشخصية',
                          icon: Icon(Icons.person_rounded),
                        ),
                    ],
                  ));
          }
        });
  }
}
