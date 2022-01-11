import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:central_borssa/business_logic/Advertisement/bloc/advertisement_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Advertisement.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:central_borssa/data/model/Transfer.dart' as transfer;

class Trader extends StatefulWidget {
  TraderPage createState() => TraderPage();
}

class TraderPage extends State<Trader> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late List<City> cities2 = [];
  late List<CurrencyPrice> currencyprice = [];
  late List<transfer.Transfer> transferprice = [];
  late AdvertisementBloc advertisementbloc;
  late List<Advertisements> advertisements = [];

  late bool isloading = true;
  late bool istransferloading = true;
  late int countofMessage = 0;
  late List<String> messageBody = [];
  late BorssaBloc bloc;
  late String? test;
  late String startpoint;
  late String userActive = "";
  late String endpoint;
  bool isClose = false;
  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  int companyuser = 0;

  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    userLocation = "Empty";
    userPermissions = prefs.getStringList('permissions')!.toList();
    if (prefs.getInt('countofMessage') != null) {
      countofMessage = 0;
      countofMessage = prefs.getInt('countofMessage')!;
      print('--share---');
      print(countofMessage);
    }
    if (prefs.get('end_subscription') != null) {
      userActive = prefs.get('end_subscription').toString();
    }
    if (prefs.getStringList('MessageBody') != null) {
      messageBody.clear();
      messageBody = prefs.getStringList('MessageBody')!;
      print('--share---');
      print(messageBody);
    }
    var y = userPermissions.contains('Update_Auction_Price_Permission');
    print('user permission$y');
    companyuser = int.parse(prefs.get('companyid').toString());
    userType = prefs.get('roles').toString();
    setState(() {});
  }

  firebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseMessaging.onMessage.handleError((error) {
      print("Erorrrrrr : ${error.toString()}");
    }).listen((event) async {
      String? body = event.notification?.body;
      if (event.data['type'] == "broadcast") {
        if (messageBody.isEmpty) {
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');
          countofMessage++;
          messageBody.add(body!);
          prefs.setInt('countofMessage', countofMessage);
          prefs.setStringList('MessageBody', messageBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body),
              action: SnackBarAction(
                label: 'تنبيه',
                onPressed: () {},
              ),
            ),
          );
        } else if (messageBody.isNotEmpty) {
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');
          countofMessage++;
          messageBody.add(body!);
          prefs.setInt('countofMessage', countofMessage);
          prefs.setStringList('MessageBody', messageBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body),
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
  void initState() {
    sharedValue();
    advertisementbloc = BlocProvider.of<AdvertisementBloc>(context);
    advertisementbloc.add(GetAdvertisementEvent());
    firebase();
    bloc = BlocProvider.of<BorssaBloc>(context);
    bloc.add(TraderCurrencyEvent());

    super.initState();
  }

  final CarouselController _controller = CarouselController();
  int _current = 0;

  Widget sliderImage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 0),
      child: Column(
        children: [
          Card(
            color: Color(0xff505D6E),
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: advertisements
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        margin: EdgeInsets.only(
                          top: 15.0,
                          bottom: 15.0,
                        ),
                        elevation: 5.0,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: Image.network(item.image),
                                        );
                                      });
                                },
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: advertisements.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Color(navbar.hashCode)
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget dataTable(List<dynamic> currencyPricelist) {
    return Column(
      children: [
        for (int i = 0; i < currencyprice.length; i++)
          Container(
            width: double.infinity,
            child: Card(
              // color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: new BorderSide(color: Colors.white),
              ),
              margin: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 0),
              // elevation: 4,
              // shadowColor: Colors.black,
              // color: Color(0xff7d8a99),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(15.0),
              //   side: new BorderSide(color: Colors.white),
              // ),
              child: Container(
                // width: double.infinity,
                child: Column(
                  children: [
                    DataTable(
                        dataTextStyle: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                        ),
                        headingRowHeight: 28,
                        horizontalMargin: 5.5,
                        dividerThickness: 2,
                        dataRowHeight: 110,
                        columnSpacing: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff505D6E),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Color(0xff7d8a99),
                        ),
                        headingTextStyle: const TextStyle(
                          inherit: false,
                        ),
                        columns: [
                          DataColumn(
                              label: Expanded(
                            child: Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currencyPricelist[i].city.name == 'إربيل'
                                      ? "الشمال"
                                      : currencyPricelist[i].city.name ==
                                              'بغداد'
                                          ? "بغداد"
                                          : currencyPricelist[i].city.name ==
                                                  'بصرة'
                                              ? "الجنوب"
                                              : "",
                                  style: TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            )),
                          )),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Color(navbar.hashCode),
                                        child: Flag.fromCode(
                                          FlagsCode.IQ,
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                          right: 8.0,
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Color(navbar.hashCode),
                                        child: Flag.fromCode(
                                          FlagsCode.US,
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, right: 12),
                                        child: InkWell(
                                          child: Row(
                                            children: [
                                              currencyPricelist[i].buyStatus ==
                                                      "down"
                                                  ? Icon(
                                                      Icons.call_received,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(
                                                      Icons.call_made,
                                                      color: Colors.green,
                                                    ),
                                              Text(
                                                currencyPricelist[i]
                                                    .buy
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, right: 12),
                                        child: InkWell(
                                          child: Text(
                                            'العرض',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Color(navbar.hashCode),
                                          child: Flag.fromCode(
                                            FlagsCode.IQ,
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                            right: 8.0,
                                          ),
                                        ),
                                        CircleAvatar(
                                          backgroundColor:
                                              Color(navbar.hashCode),
                                          child: Flag.fromCode(
                                            FlagsCode.US,
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, right: 12),
                                          child: InkWell(
                                            child: Row(
                                              children: [
                                                currencyPricelist[i]
                                                            .sellStatus ==
                                                        "down"
                                                    ? Icon(
                                                        Icons.call_received,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(
                                                        Icons.call_made,
                                                        color: Colors.green,
                                                      ),
                                                Text(
                                                  currencyPricelist[i]
                                                      .sell
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, right: 18),
                                          child: InkWell(
                                            child: Text(
                                              'الطلب',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ]),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
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
              radius: 30.0,
              child: Image.asset(
                'assest/Images/test2.png',
              ),
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
                    ),
                    ListTile(
                      title: Text(userPhone),
                      leading: new Icon(Icons.phone),
                    ),
                    ListTile(
                      title: Text(userActive == "" ? "غيرفعال" : userActive),
                      leading: new Icon(Icons.wifi_tethering_outlined),
                      onTap: () {},
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
      backgroundColor: Color(0xff6e7d91),
      drawer: newDrawer(),
      appBar: AppBar(
        title: Center(
          child: Text('البورصة المركزية'),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
                child: countofMessage != 0
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 2),
                        child: Badge(
                          badgeContent: Text(countofMessage.toString()),
                          child: Icon(Icons.notification_add_outlined),
                        ),
                      )
                    : Icon(Icons.notification_add_outlined),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  countofMessage = 0;
                  prefs.setInt('countofMessage', 0);
                  messageBody.isNotEmpty
                      ? showDialog(
                          // barrierColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: Center(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    height: MediaQuery.of(context).size.height -
                                        350,
                                    child: SingleChildScrollView(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            for (int i = messageBody.length - 1;
                                                i >= 0;
                                                i--)
                                              Card(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'البورصة المركزية',
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    120,
                                                                child: Text(
                                                                  messageBody[
                                                                      i],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          })
                      : Container();
                }),
          ),
        ],
        backgroundColor: Color(navbar.hashCode),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BorssaBloc, BorssaState>(
            listener: (context, state) {
              if (state is GetTraderCurrencyLoading) {
                currencyprice.clear();

                print(state);
              } else if (state is GetTraderCurrencyLoaded) {
                print(state);
                currencyprice = state.cities;
                setState(() {
                  isloading = false;
                });
              } else if (state is GetTraderCurrencyError) {
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
          ),
          BlocListener<AdvertisementBloc, AdvertisementState>(
            listener: (context, state) {
              if (state is GetAdvertisementLoading) {
                print(state);
              } else if (state is GetAdvertisementLoaded) {
                print(state);
                advertisements.clear();
                advertisements = state.allAdvertisements;
                setState(() {});
              } else if (state is GetAdvertisementError) {
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
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    sliderImage(),
                    dataTable(currencyprice),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
