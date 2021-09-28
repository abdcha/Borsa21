import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Home/Central_Borssa.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home/All_post.dart';
import '..//Home/Chat.dart';
import '../Home/Company_Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  callBody(int value) {
    switch (value) {
      case 0:
        return
            // userType.toLowerCase() == "admin" ||
            //         userType.toLowerCase() == "trader"
            //     ? EmptyPage()
            //     :
            AllPost();
      case 1:
        return
            // userType.toLowerCase() == "admin" ||
            //         userType.toLowerCase() == "trader"
            //     ? EmptyPage()
            //     :
            //     Chat();
            Chat();
      case 2:
        return CentralBorssa();
      case 3:
        return
            // userType.toLowerCase() == "admin" ||
            //         userType.toLowerCase() == "trader"
            //     ? EmptyPage()
            //     :
            CompanyProfile();
        // ignore: dead_code
        break;
      default:
    }
  }

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    print(userPhone);

    userLocation = "Empty";
    print(userLocation);
    companyuser = int.parse(prefs.get('companyid').toString());
    print(companyuser);

    userType = prefs.get('roles').toString();
    setState(() {
      // print(prefs.getStringList('permissions'));
    });
  }

  @override
  void initState() {
    addStringToSF();
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
    return Scaffold(
        key: _scaffoldKey,
        drawer: new Drawer(
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
                          title:
                              userActive != 0 ? Text('فعال') : Text('غير فعال'),
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
        ),
        appBar: new AppBar(
          title: Center(
            child: Text('البورصة المركزية'),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                child: Icon(Icons.filter_alt_sharp),
                onTap: () {
                  endDrawer:
                  new Drawer(
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
                                      // Update the state of the app.
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
                                    leading:
                                        new Icon(Icons.location_on_outlined),
                                    onTap: () {
                                      // Update the state of the app.
                                      // ...
                                    },
                                  ),
                                  ListTile(
                                    title: userActive != 0
                                        ? Text('فعال')
                                        : Text('غير فعال'),
                                    leading: new Icon(
                                        Icons.online_prediction_outlined),
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
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                  child: Icon(Icons.notification_add_outlined), onTap: () {}),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                child: Icon(Icons.search),
                onTap: () {},
              ),
            ),
          ],
          backgroundColor: Color(navbar.hashCode),
        ),
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
              title: Text('الأساسية'),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              title: Text('المحادثة'),
              icon: Icon(Icons.chat_outlined),
            ),
            BottomNavigationBarItem(
              title: Text('مزاد الحواللات'),
              icon: Icon(Icons.attach_money),
            ),
            BottomNavigationBarItem(
              title: Text('الشخصية'),
              icon: Icon(Icons.person_rounded),
            ),
          ],
        ));
  }
}
