import 'package:central_borssa/business_logic/Chat/bloc/chat_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Chat.dart' as MessageOfChat;
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class MainChat extends StatefulWidget {
  CompanyProfilePage createState() => CompanyProfilePage();
}

class CompanyProfilePage extends State<MainChat> {
  void whatsappSender({@required number, @required message}) async {
    final String url = "https://api.whatsapp.com/send?phone=$number";
    await launch(url);
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();
  int currentPage = 1;
  late int countItemPerpage = 5;

  late ChatBloc bloc;
  late List<MessageOfChat.Message> companypost = [];
  late int companyuser = 0;
  late int totalpost;
  late String? location;
  bool isEmpty = true;

  Future<bool> postloading({bool isRefresh = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyuser = int.parse(prefs.get('companyid').toString());

    if (isRefresh) {
      print('is refresh');
      bloc.add(GetAllMessagesEvent(pageSize: 100, page: 1));
      currentPage++;
    }
    print(companypost.length);
    if (companypost.isNotEmpty &&
        (totalpost / countItemPerpage).round() >= currentPage) {
      bloc.add(GetAllMessagesEvent(pageSize: 100, page: 1));
      print('Not Empty');
      currentPage++;
    }
    print(currentPage);
    return true;
  }

  _sendMessageArea() {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 70,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.photo),
            //   iconSize: 25,
            //   color: Theme.of(context).primaryColor,
            //   onPressed: () {},
            // ),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration.collapsed(
                  hintText: 'الرسالة',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget ourListview() {
    return SingleChildScrollView(
      child: ListView.separated(
        key: _contentKey,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(2),
        itemCount: companypost.length,
        itemBuilder: (BuildContext context, int index) {
          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 5.0,
              shadowColor: Colors.black,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, //change here don't //worked
                    children: [
                      Container(),
                      // Container(
                      //     margin: const EdgeInsets.only(
                      //         bottom: 10, left: 2, top: 10, right: 10),
                      //     child: Column(
                      //       children: [
                      //         Icon(Icons.location_on_outlined),
                      //         Text(companypost[index].user.city.name),
                      //       ],
                      //     )),
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  's',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(DateFormat.Hm().format(
                                      DateTime.parse(
                                          companypost[index].createdAt))),
                                ),
                                Text(
                                  companypost[index].username,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         CompanyProfile(id: post[index].companyId),
                            //   ),
                            // );
                          },
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                            // backgroundImage: NetworkImage(
                            //   'https://ferasalhallak.online$companypost[index].companyImage',
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      child: ReadMoreText(
                    companypost[index].message,
                    trimLines: 2,
                    trimCollapsedText: 'قرائة المزيد',
                    trimExpandedText: 'قرائة الأقل',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    bloc = BlocProvider.of<ChatBloc>(context);
    // companypost.clear();
    postloading();
    sharedValue();
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
    userPermissions = prefs.getStringList('permissions')!.toList();
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
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is GetAllMessagesIsLoading) {
            print(state);
          }
          if (state is GetAllMessagesIsLoaded) {
            print(state);
            if (companypost.isEmpty) {
              companypost = state.data.message;
              totalpost = state.data.total;
              print(totalpost);
            } else if (companypost.isNotEmpty) {
              // companypost.addAll(state.data.message);
            } else {
              print(state);
            }
          } else if (state is GetAllMessagesError) {
            print(state);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('خطأ في التحميل'),
                action: SnackBarAction(
                  label: 'تنبيه',
                  onPressed: () {},
                ),
              ),
            );
          }
        },
        child: Container(
          height: double.infinity,
          child: SmartRefresher(
            key: _refresherKey,
            controller: refreshController,
            enablePullUp: true,
            physics: BouncingScrollPhysics(),
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              completeDuration: Duration(milliseconds: 500),
            ),
            onRefresh: () async {
              postloading(isRefresh: true);
              await Future.delayed(Duration(milliseconds: 1000));
              if (mounted) setState(() {});
              refreshController.refreshCompleted();
            },
            onLoading: () async {
              await Future.delayed(Duration(milliseconds: 180));
              postloading();
              if (mounted) setState(() {});
              refreshController.loadFailed();
            },
            child: Column(
              children: [Expanded(child: ourListview()), _sendMessageArea()],
            ),
          ),
        ),
      ),
    );
  }
}
