import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/presentation/Admin/Profile.dart';
import 'package:central_borssa/presentation/Auction/Auction.dart';
import 'package:central_borssa/presentation/Auction/Global.dart';
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
  late int countofAuctions = 0;
  late bool isTrader = true;
  late String userActive = "";
  int messageUnread = 0;
  int notificationcount = 0;
  late String temp2 = "ss";
  bool allow = true;
  late String? istrader = "";

  sharedValue() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('-------------');
    print(token);
    print('-------------');
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loginBloc.add(FireBaseTokenEvent(fcmToken: token));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    istrader = prefs.get('token').toString();
    print('dsa {$istrader}');
    if (istrader == "null" || istrader == "") {
      print('side trader');
      setState(() {
        isTrader = true;
      });
    } else if (istrader != "null" && istrader != "") {
      isTrader = false;

      userName = prefs.get('username').toString();
      userPhone = prefs.get('userphone').toString();
      print(prefs.get('token').toString());
      userLocation = "Empty";
      if (prefs.get('end_subscription') != null) {
        userActive = prefs.get('end_subscription').toString();
      }
      userPermissions = prefs.getStringList('permissions')!.toList();
      var y = userPermissions.contains('Update_Auction_Price_Permission');
      print('user permission$y');
      print(userLocation);
      companyuser = int.parse(prefs.get('companyid').toString());
      print(companyuser);
      userType = prefs.get('roles').toString();
      if (prefs.getInt('countofauction') != null) {
        countofAuctions = 0;
        countofAuctions = prefs.getInt('countofauction')!;
        print('--share---');
        print(countofAuctions);
      } else {
        countofAuctions = 0;
      }
    }
  }

  auctionRead() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      countofAuctions = 0;
    });
    if (prefs.getInt('countofauction') != null) {
      prefs.setInt('countofauction', 0);
    }
  }

  nothing() {}

  fireBase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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
        if (event.data['type'] == "new_auction") {
          prefs.setInt('countofauction', countofAuctions);
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');
          if (countofAuctions == 0) {
            setState(() {
              countofAuctions++;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(temp2),
                action: SnackBarAction(
                  label: 'تنبيه',
                  onPressed: () {},
                ),
              ),
            );
          } else if (countofAuctions != 0) {
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
              countofAuctions++;
            });
            prefs.setInt('countofauction', countofAuctions);
          }
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
          prefs.setInt('countofauction', countofAuctions);
          String? temp = event.notification!.body;
          temp2 = temp!;
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');
          if (countofAuctions == 0) {
            countofAuctions++;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(temp2),
                action: SnackBarAction(
                  label: 'تنبيه',
                  onPressed: () {},
                ),
              ),
            );
          } else if (countofAuctions != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(temp2),
                action: SnackBarAction(
                  label: 'تنبيه',
                  onPressed: () {},
                ),
              ),
            );
            countofAuctions++;
            prefs.setInt('countofauction', countofAuctions);
          }
        }
        if (event.data['type'] == "broadcast") {
          String? temp = event.notification!.body;
          temp2 = temp!;
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

  callBody(int index) {
    print(userPermissions);
    print(userType);

    if (isTrader == false && userType == "User") {
      switch (index) {
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
    } else if (isTrader || userType == "Trader") {
      switch (index) {
        case 0:
          return Trader();
        case 1:
          return CentralBorssa();
        case 2:
          return Global();
        case 3:
          countofAuctions != 0 ? auctionRead() : nothing();
          return Auction();

          // ignore: dead_code
          break;
        default:
      }
    } else if (isTrader == false && userType == "Admin") {
      switch (index) {
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
    navbarbottom = sharedValue();
    fireBase();

    super.initState();
  }

  myfire() {
    print('test');
    _loginBloc.add(MeInformationEvent());
  }

  choosePage(int index) async {
    // await myfire();
    if (selectedPage != index) {
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
              return (userType == "Trader" || isTrader == true)
                  ? Scaffold(
                      key: _scaffoldKey,
                      body: callBody(selectedPage),
                      bottomNavigationBar: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Color(navbar.hashCode),
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.white.withOpacity(.60),
                        selectedFontSize: 14,
                        unselectedFontSize: 14,
                        unselectedLabelStyle: TextStyle(
                          fontFamily: 'Cairo',
                        ),
                        currentIndex: selectedPage,
                        onTap: choosePage,
                        items: [
                          BottomNavigationBarItem(
                            label: 'الرئيسية',
                            icon: Icon(Icons.home),
                          ),
                          BottomNavigationBarItem(
                            label: 'البورصة',
                            icon: Icon(Icons.attach_money),
                          ),
                          BottomNavigationBarItem(
                            label: 'البورصة العالمية',
                            icon: Icon(Icons.public_outlined),
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
                          BottomNavigationBarItem(
                            label: 'المزاد المركزي',
                            icon: Icon(Icons.person_rounded),
                          ),
                        ],
                        selectedLabelStyle: TextStyle(
                          fontFamily: 'Cairo',
                        ),
                      ))
                  : Scaffold(
                      key: _scaffoldKey,
                      body: callBody(selectedPage),
                      bottomNavigationBar: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: Color(navbar.hashCode),
                        selectedItemColor: Colors.white,
                        unselectedItemColor: Colors.white.withOpacity(.60),
                        selectedFontSize: 14,
                        unselectedFontSize: 14,
                        unselectedLabelStyle: TextStyle(
                          fontFamily: 'Cairo',
                        ),
                        currentIndex: selectedPage,
                        onTap: choosePage,
                        items: [
                          if (userType == "User")
                            BottomNavigationBarItem(
                              label: 'الرئيسية',
                              icon: Icon(Icons.home),
                            ),
                          if (userType == "User" || userType == "Admin")
                            BottomNavigationBarItem(
                              label: 'البورصة',
                              icon: Icon(Icons.attach_money),
                            ),
                          if (userType == "User")
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
                          if (userType == "User" || userType == "Admin")
                            BottomNavigationBarItem(
                              label: 'الشخصية',
                              icon: Icon(Icons.person_rounded),
                            ),
                        ],
                        selectedLabelStyle: TextStyle(
                          fontFamily: 'Cairo',
                        ),
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
                    selectedLabelStyle: TextStyle(
                      fontFamily: 'Cairo',
                    ),
                  ));
          }
        });
  }
}
