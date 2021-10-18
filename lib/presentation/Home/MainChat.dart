import 'package:central_borssa/business_logic/Chat/bloc/chat_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Chat.dart' as MessageOfChat;
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_pusher/pusher.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
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

  ScrollController _scrollcontroller = ScrollController();

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _refresherKey = GlobalKey();
  int currentPage = 1;
  late int countItemPerpage = 100;
  final messagebody = TextEditingController();
  bool isbottom = true;
  late ChatBloc bloc;
  late List<MessageOfChat.Message> messages = [];
  late int companyuser = 0;
  late int totalpost = 1;
  late String? location;
  bool isEmpty = true;
  late Channel _ourChannel;
  late String? test;
  Future<void> pusherTerster() async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      test = _pref.get('roles').toString();
      await Pusher.init(
          'borsa_app',
          PusherOptions(
              cluster: 'mt1',
              host: 'www.ferasalhallak.online',
              encrypted: false,
              port: 6001));
      print('1');

      Pusher.connect(onConnectionStateChange: (val) {
        print('2');
        print(val!.currentState);
      }, onError: (error) {
        print('3');

        print(error!.message);
      });

      //Subscribe
      _ourChannel = await Pusher.subscribe('MessageChannel');

      //Bind
      _ourChannel.bind('newMessage', (onEvent) {
        print('fromhere');
        print('4');

        print(onEvent!.data);
        bloc.add(GetAllMessagesEvent(pageSize: 100, page: 1));
      });
    } catch (e) {}
  }

  Future<bool> postloading({bool isRefresh = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyuser = int.parse(prefs.get('companyid').toString());

    currentPage = 0;
    messages.clear();
    print('is refresh');
    bloc.add(GetAllMessagesEvent(pageSize: 1000, page: 1));
    setState(() {});

    currentPage++;
    // print(companypost.length);
    // else if (messages.length != totalpost) {
    //   bloc.add(GetAllMessagesEvent(pageSize: 100, page: currentPage));
    //   print('Not Empty');
    //   currentPage++;
    // }
    // print(currentPage);
    return true;
  }

  _sendMessageArea() {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 8),

        height: 45,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 8, left: 0, right: 8, top: 8),
                child: TextField(
                  controller: messagebody,
                  maxLines: null,
                  expands: true,
                  // keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration.collapsed(hintText: 'الرسالة'),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                if (messagebody.text.isNotEmpty) {
                  bloc.add(SendMessageEvent(message: messagebody.text));
                  messagebody.text = "";
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('الرجاء إدخال الرسالة'),
                      action: SnackBarAction(
                        label: 'تنبيه',
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget ourListview() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            key: _contentKey,
            controller: _scrollcontroller,
            reverse: true,
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return Directionality(
                textDirection: userName.toLowerCase() ==
                        messages[index].username.toLowerCase()
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
                child: Column(
                  children: [
                    Align(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (index < messages.length - 1)
                                  messages[index].username ==
                                          messages[index + 1].username
                                      ? Container(
                                          margin: EdgeInsets.all(24),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.only(
                                              right: 4.0, left: 4.0),
                                          child: CircleAvatar(
                                            child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: NetworkImage(
                                                "https://ferasalhallak.online${messages[index].companyImage}",
                                              ),
                                            ),
                                          ),
                                        ),
                                if (index == messages.length - 1)
                                  Container(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 8),
                                      child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  // right: 10.0,
                                                  ),
                                              child: CircleAvatar(
                                                // backgroundColor: navbar,

                                                child: CircleAvatar(
                                                  // radius: 12.0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: NetworkImage(
                                                    "https://ferasalhallak.online${messages[index].companyImage}",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]))),
                                Container(
                                  width: messages[index]
                                              .message
                                              .length
                                              .toDouble() >
                                          23
                                      ? 300
                                      : messages[index]
                                                  .message
                                                  .length
                                                  .toDouble() >
                                              16
                                          ? 230
                                          : messages[index]
                                                      .message
                                                      .length
                                                      .toDouble() >
                                                  9
                                              ? 180
                                              : 120,
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    color: Color(0xffdcf8c6),
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 15,
                                            bottom: 30,
                                          ),
                                          child: Text(
                                            messages[index].message,
                                            textAlign:
                                                messages[index].username ==
                                                        userName
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 4,
                                          right: 5,
                                          child: Row(
                                            children: [
                                              Text(
                                                DateFormat.jm().format(
                                                    DateTime.parse(
                                                        messages[index]
                                                            .createdAt)),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              // Icon(
                                              //   Icons.done_all,
                                              //   size: 20,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 1,
            ),
          ),
        ),
        Container(
          child: _sendMessageArea(),
        )
      ],
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
    messages.clear();
    postloading();
    pusherTerster();
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is GetAllMessagesIsLoading) {
                print(state);
              } else if (state is GetAllMessagesIsLoaded) {
                print(state);

                messages = state.data.message;
                // _scrollcontroller.animateTo(
                //     _scrollcontroller.position.maxScrollExtent,
                //     duration: Duration(milliseconds: 200),
                //     curve: Curves.easeOut);
                totalpost = state.data.total;
                setState(() {
                  print('get all message');
                });
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
              } else if (state is SendMessageIsLoading) {
                print(state);
              }
              if (state is SendMessageIsLoaded) {
                print(state);
                pusherTerster();
                // _scrollcontroller.animateTo(
                //     _scrollcontroller.position.maxScrollExtent,
                //     duration: Duration(milliseconds: 200),
                //     curve: Curves.easeOut);
              } else if (state is SendMessageError) {
                print(state);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('??? ?? ???????'),
                    action: SnackBarAction(
                      label: '?????',
                      onPressed: () {},
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ourListview(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
