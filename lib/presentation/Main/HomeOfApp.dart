import 'package:central_borssa/presentation/Share/Welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Home/Central_Borssa.dart';

import '..//Home/Chat.dart';
import '../Home/All_post.dart';
import '../Home/Company_Profile.dart';

class HomeOfApp extends StatefulWidget {
  home_page createState() => home_page();
}

// ignore: camel_case_types
class home_page extends State<HomeOfApp>
    with AutomaticKeepAliveClientMixin<HomeOfApp> {
  int selectedPage = 0;
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  late List<String> userPermissions = [];
  int companyuser = 0;

  @override
  bool get wantKeepAlive => true;
  late int userActive = 0;
  //test

  callBody(int value) {
    if (userPermissions.contains('Chat_Permission')) {
      switch (value) {
        case 0:
          return AllPost();
        case 1:
          return CentralBorssa();
        case 2:
          return Chat();
        case 3:
          return CompanyProfile();
          // ignore: dead_code
          break;
        default:
      }
    } else if (userPermissions.contains('Trader_Permission')) {
      switch (value) {
        case 0:
          return CentralBorssa();
        case 1:
          return CompanyProfile();
          // ignore: dead_code
          break;
        default:
      }
    } else if (userPermissions.contains('Update_Auction_Price_Permission')) {
      switch (value) {
        case 0:
          return CentralBorssa();
        case 1:
          return Chat();
          // ignore: dead_code
          break;
        default:
      }
    }
  }

  late Future navbarbottom;
  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    print(userPhone);
    userLocation = "Empty";
    userPermissions = prefs.getStringList('permissions')!.toList();
    var y = userPermissions.contains('Update_Auction_Price_Permission');
    print('user permission$y');
    print(userLocation);
    companyuser = int.parse(prefs.get('companyid').toString());
    print(companyuser);
    userType = prefs.get('roles').toString();
    setState(() {});
  }

  @override
  void initState() {
    navbarbottom = sharedValue();
    super.initState();
  }

  void choosePage(int index) {
    if (selectedPage != index) {
      setState(() {
        selectedPage = index;
      });
    }
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
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions
                              .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'المحادثة',
                          icon: Icon(Icons.chat_outlined),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions.contains('Trader_Permission'))
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
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions
                              .contains('Update_Auction_Price_Permission'))
                        BottomNavigationBarItem(
                          label: 'المحادثة',
                          icon: Icon(Icons.chat_outlined),
                        ),
                      if (userPermissions.contains('Chat_Permission') ||
                          userPermissions.contains('Trader_Permission'))
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
