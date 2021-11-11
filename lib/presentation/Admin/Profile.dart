import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:central_borssa/data/model/Post/CompanyPost.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile> {
  void whatsappSender({@required number, @required message}) async {
    final String url = "https://api.whatsapp.com/send?phone=$number";
    await launch(url);
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  int currentPage = 1;
  late int countItemPerpage = 30;

  late CompanyBloc bloc;
  late List<Posts> companypost = [];
  late int companyuser = 0;
  late int totalpost = 0;
  late String? location;
  bool isEditn = true;

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    bloc = BlocProvider.of<CompanyBloc>(context);
    sharedValue();
    setState(() {});
    super.initState();
  }

  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userType = "";
  late String userActive = "";

  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    if (prefs.getStringList('permissions')!.toList().isNotEmpty) {
      userPermissions = prefs.getStringList('permissions')!.toList();
    }
    companyuser = int.parse(prefs.get('companyid').toString());
    userType = prefs.get('roles').toString();
    if (prefs.get('end_at') != null) {
      userActive = prefs.get('end_at').toString();
    }
    setState(() {});
  }

  logout() async {
    print('from');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
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
            color: Colors.grey[300],
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
                    ),
                    ListTile(
                      title: Text(userActive),
                      leading: new Icon(Icons.wifi_tethering_outlined),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                      },
                    ),
                    ListTile(
                      title: Text('تسجيل الخروج'),
                      leading: new Icon(Icons.logout_sharp),
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          logout();
                          return Loginpage();
                        }));
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
    return Scaffold(
      drawer: newDrawer(),
      appBar: AppBar(
        title: Center(
          child: Text('البورصة المركزية'),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
                child: Icon(Icons.notification_add_outlined), onTap: () {}),
          ),
        ],
        backgroundColor: Color(navbar.hashCode),
      ),
      backgroundColor: Colors.grey[300],
      body: MultiBlocListener(
        listeners: [
          BlocListener<CompanyBloc, CompanyState>(
            listener: (context, state) {
              if (state is EditPostLoaded) {
              } else if (state is DeletePostLoaded) {
              } else if (state is GetAllInformationLoading) {
                print(state);
              }
            },
          ),
        ],
        child: Card(
          child: Card(
            color: Color(navbar.hashCode),
            child: Column(
              children: [
                Container(
                  height: 400,
                  width: 400,
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assest/Images/Logo.png'),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, top: 8, right: 12, left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, top: 8, right: 12, left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          userPhone,
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: () {
                              launch("tel://$userPhone");
                            },
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, top: 8, right: 12, left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          userActive == "" ? "فعال" : userActive,
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.av_timer,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
