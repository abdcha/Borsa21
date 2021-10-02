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
  int companyuser = 0;

  @override
  bool get wantKeepAlive => true;
  late int userActive = 0;
  //test

  callBody(int value) {
    switch (value) {
      case 0:
        return AllPost();
      case 1:
        return Chat();
      case 2:
        return CentralBorssa();
      case 3:
        return CompanyProfile();
        // ignore: dead_code
        break;
      default:
    }
  }

  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    print(userPhone);

    userLocation = "Empty";
    print(userLocation);
    companyuser = int.parse(prefs.get('companyid').toString());
    print(companyuser);

    userType = prefs.get('roles').toString();
    setState(() {});
  }

  @override
  void initState() {
    sharedValue();
    super.initState();
  }

  void choosePage(int index) {
    if (selectedPage != index) {
      setState(() {
        selectedPage = index;
      });
    }
  }

  Widget newDrawer() {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            child: new DrawerHeader(
                child: new CircleAvatar(
              backgroundColor: navbar,
              // child: Image.asset('asesst/Images/Logo.png')
            )),
            color: Colors.white,
          ),
          new Container(
              color: Colors.white30,
              child: Center(
                child: new Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(userName),
                      leading: new Icon(Icons.account_circle),
                      onTap: () {
                        // Update the state of the app.//feas
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text(userPhone),
                      leading: new Icon(Icons.phone),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text(userLocation),
                      leading: new Icon(Icons.location_on_outlined),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      title: userActive != 0 ? Text('فعال') : Text('غير فعال'),
                      leading: new Icon(Icons.online_prediction_outlined),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        drawer: newDrawer(),
        appBar: selectedPage == 1
            ? AppBar(
                title: Center(
                  child: Text('البورصة المركزية'),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                        child: Icon(Icons.notification_add_outlined),
                        onTap: () {}),
                  ),
                  // selectedPage == 0
                  //     ? Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 4),
                  //         child: InkWell(
                  //           child: Icon(Icons.search),
                  //           onTap: () {
                  //             showSearch(
                  //                 context: context, delegate: CitySearch());
                  //           },
                  //         ),
                  //       )
                  //     : Container(),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.filter_alt_sharp),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    ),
                  ),
                ],
                backgroundColor: Color(navbar.hashCode),
              )
            : null,
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
            BottomNavigationBarItem(
              label: 'الأساسية',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'المحادثة',
              icon: Icon(Icons.chat_outlined),
            ),
            BottomNavigationBarItem(
              label: 'مزاد الحواللات',
              icon: Icon(Icons.attach_money),
            ),
            BottomNavigationBarItem(
              label: 'الشخصية',
              icon: Icon(Icons.person_rounded),
            ),
          ],
        ));
  }
}
