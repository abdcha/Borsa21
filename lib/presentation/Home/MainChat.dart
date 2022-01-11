import 'package:central_borssa/business_logic/Chat/bloc/chat_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Chat.dart' as MessageOfChat;
import 'package:central_borssa/presentation/Company/company.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  int currentPage = 1;
  final messagebody = TextEditingController();
  late ChatBloc bloc;
  late List<MessageOfChat.Message> messages = [];
  late int companyuser = 0;
  late int totalpost = 1;
  // late Channel _ourChannel;
  Future<void> messagePusher() async {
    // try {
    //   await Pusher.init(
    //       'borsa_app',
    //       PusherOptions(
    //           cluster: 'mt1',
    //           host: 'www.ferasalhallak.online',
    //           encrypted: false,
    //           port: 6001));
    //   Pusher.connect(onConnectionStateChange: (val) {
    //     print(val!.currentState);
    //   }, onError: (error) {
    //     print(error!.message);
    //   });

    //   //Subscribe
    //   _ourChannel = await Pusher.subscribe('MessageChannel');

    //   //Bind
    //   _ourChannel.bind('newMessage', (onEvent) {
    //     print(onEvent!.data);
    //     bloc.add(GetAllMessagesEvent(pageSize: 100, page: 1));
    //   });
    //   setState(() {});
    // } catch (e) {}
  }

  Future<bool> messageLoaing({bool isRefresh = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyuser = int.parse(prefs.get('companyid').toString());
    currentPage = 0;
    messages.clear();
    print('is refresh');
    bloc.add(GetAllMessagesEvent(pageSize: 1000, page: 1));
    setState(() {});

    currentPage++;
    return true;
  }

  _sendMessageArea() {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Card(
                      margin:
                          EdgeInsets.only(left: 2, right: 2, bottom: 8, top: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          controller: messagebody,
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "الرسالة",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding:
                                EdgeInsets.only(right: 12, bottom: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      right: 2,
                      left: 2,
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(navbar.hashCode),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (messagebody.text.isNotEmpty) {
                            bloc.add(
                                SendMessageEvent(message: messagebody.text));
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
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                                      ? MediaQuery.of(context).size.width - 115
                                      : messages[index]
                                                  .message
                                                  .length
                                                  .toDouble() >
                                              18
                                          ? MediaQuery.of(context).size.width -
                                              160
                                          : messages[index]
                                                      .message
                                                      .length
                                                      .toDouble() >
                                                  9
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  200
                                              : 120,
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    // color: Color(0xffdcf8c6),
                                    margin: EdgeInsets.symmetric(),
                                    child: Stack(
                                      children: [
                                        if (index == messages.length - 1)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 2,
                                                bottom: 15),
                                            child: InkWell(
                                              child: PopupMenuButton(
                                                child: Text(
                                                  messages[index].companyName,
                                                  textAlign: messages[index]
                                                              .username ==
                                                          userName
                                                      ? TextAlign.right
                                                      : TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuEntry>[
                                                  PopupMenuItem(
                                                    child: ListTile(
                                                      leading: Icon(Icons.phone,
                                                          color: Color(
                                                              navbar.hashCode)),
                                                      title: Text('اتصال'),
                                                      onTap: () {
                                                        launch(
                                                            "tel://${messages[index].userPhone}");
                                                      },
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    child: ListTile(
                                                      leading: Icon(
                                                        Icons.person_rounded,
                                                        color: Color(
                                                            navbar.hashCode),
                                                      ),
                                                      title: Text('الشخصيه'),
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AnyCompanyProfile(
                                                                    id: messages[
                                                                            index]
                                                                        .companyId,
                                                                    name: messages[
                                                                            index]
                                                                        .companyName,
                                                                  )),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    child: ListTile(
                                                      leading: Image.asset(
                                                        'assest/Images/whatsapp.png',
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                      title: Text('الخاص'),
                                                      onTap: () {
                                                        whatsappSender(
                                                            message: "hi",
                                                            number:
                                                                messages[index]
                                                                    .userPhone);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        if (index < messages.length - 1)
                                          messages[index + 1].username ==
                                                  messages[index].username
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          top: 2,
                                                          bottom: 15),
                                                  child: InkWell(
                                                    child: PopupMenuButton(
                                                      child: Text(
                                                        messages[index]
                                                            .companyName,
                                                        textAlign: messages[
                                                                        index]
                                                                    .username ==
                                                                userName
                                                            ? TextAlign.right
                                                            : TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <PopupMenuEntry>[
                                                        PopupMenuItem(
                                                          child: ListTile(
                                                            leading: Icon(
                                                                Icons.phone,
                                                                color: Color(navbar
                                                                    .hashCode)),
                                                            title:
                                                                Text('اتصال'),
                                                            onTap: () {
                                                              launch(
                                                                  "tel://${messages[index].userPhone}");
                                                            },
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          child: ListTile(
                                                            leading: Icon(
                                                              Icons
                                                                  .person_rounded,
                                                              color: Color(navbar
                                                                  .hashCode),
                                                            ),
                                                            title:
                                                                Text('الشخصيه'),
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            AnyCompanyProfile(
                                                                              id: messages[index].companyId,
                                                                              name: messages[index].companyName,
                                                                            )),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          child: ListTile(
                                                            leading:
                                                                Image.asset(
                                                              'assest/Images/whatsapp.png',
                                                              width: 25,
                                                              height: 25,
                                                            ),
                                                            title:
                                                                Text('الخاص'),
                                                            onTap: () {
                                                              whatsappSender(
                                                                  message: "hi",
                                                                  number: messages[
                                                                          index]
                                                                      .userPhone);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 35,
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
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey[300],
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
  void initState() {
    bloc = BlocProvider.of<ChatBloc>(context);
    messages.clear();
    messageLoaing();
    // messagePusher();
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
    if (prefs.get('end_subscription') != null) {
      userActive = prefs.get('end_subscription').toString();
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
                        logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => Loginpage()),
                          ModalRoute.withName('/'),
                        );
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
      // drawer: newDrawer(),
      appBar: AppBar(
        title: Container(
          height: 50,
          child: Center(
            child: Image.asset('assest/Images/test2.png'),
          ),
        ),
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
                setState(() {});

                messages = state.data.message;
                totalpost = state.data.total;
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
                setState(() {});
                // messagePusher();
              } else if (state is SendMessageError) {
                print(state);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('خطأ في الإرسال'),
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
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: true
                    ? Container(
                        height: MediaQuery.of(context).size.height - 168,
                        child: Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Card(
                            color: Colors.grey,
                            child: Column(
                              children: [
                                Container(
                                  height: 400,
                                  width: 400,
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Colors.transparent,
                                    child:
                                        Image.asset('assest/Images/Logo.png'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: Icon(
                                        Icons.lock_clock,
                                        size: 100,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ourListview(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
