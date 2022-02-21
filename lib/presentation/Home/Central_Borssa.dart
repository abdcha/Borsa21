import 'package:badges/badges.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Auction/Auction.dart';
import 'package:central_borssa/presentation/Auction/GlobalAuction.dart';
import 'package:central_borssa/presentation/Auction/Price_Chart.dart';
import 'package:central_borssa/presentation/Auction/Update_Price.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:central_borssa/data/model/Transfer.dart' as transfer;
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';

class CentralBorssa extends StatefulWidget {
  CentralBorssaPage createState() => CentralBorssaPage();
}

class CentralBorssaPage extends State<CentralBorssa> {
  late List<CurrencyPrice?> currencyprice = [];
  late List<transfer.Transfer> transferprice = [];
  late bool isloading = true;
  late bool istransferloading = true;
  late BorssaBloc bloc;
  late LoginBloc loginbloc;
  late String temp2 = "ss";
  late int countofAuctions = 0;
  late String startpoint;
  late String endpoint;
  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  int companyuser = 0;
  late String? userActive = "";
  late String? istrader = "";
  late LoginBloc authloginBloc;

  final phoneNumberTextEdit = TextEditingController();
  final passwordTextEdit = TextEditingController();
  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('central borsaa ' + prefs.get('token').toString());
    istrader = prefs.get('token').toString();
    if (istrader == "null" || istrader == "") {
      print('ss');
      setState(() {
        isloading = false;
      });
    } else if (istrader != null) {
      var now = DateTime.now();
      var newFormat = DateFormat("yyyy-MM-dd");
      String updatedDt = newFormat.format(now);
      startpoint = '$updatedDt 1:00:00.00';
      endpoint = DateTime.now().toString();
      userName = prefs.get('username').toString();
      userPhone = prefs.get('userphone').toString();
      userLocation = "Empty";
      if (prefs.getStringList('permissions') != null) {
        userPermissions = prefs.getStringList('permissions')!.toList();
      }

      if (prefs.get('end_subscription') != null) {
        userActive = prefs.get('end_subscription').toString();
        isloading = false;
        print('---------');
        print(userActive);
        print('---------');
      } else {
        userActive = null;
      }

      if (prefs.getInt('countofauction') != null) {
        countofAuctions = 0;
        countofAuctions = prefs.getInt('countofauction')!;
        print('--share---');
        print(countofAuctions);
      } else {
        countofAuctions = 0;
      }
      bloc.add(AllCity());
      bloc.add(GetAllTransfersEvent());
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

  firebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseMessaging.onMessage.handleError((error) {
      print("Erorrrrrr : ${error.toString()}");
    }).listen((event) {
      if (event.data['type'] == "new_auction") {
        if (countofAuctions == 0) {
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');
          setState(() {
            countofAuctions++;
          });
          prefs.setInt('countofauction', countofAuctions);
        } else if (countofAuctions != 0) {
          print('------');
          print(event.notification?.title.toString());
          print(event.notification?.body.toString());
          print('------');
          setState(() {
            countofAuctions++;
          });
          prefs.setInt('countofauction', countofAuctions);
        }
      }
      if (event.data['type'] == "currency_price_change" && userActive != "") {
        bloc.add(AllCity());
      } else if (event.data['type'] == "transfer_change" && userActive != "") {
        print('from fire');
        bloc.add(GetAllTransfersEvent());
      }
    });
  }

  @override
  void initState() {
    bloc = BlocProvider.of<BorssaBloc>(context);
    loginbloc = BlocProvider.of<LoginBloc>(context);
    authloginBloc = BlocProvider.of<LoginBloc>(context);

    print('from init central borsa');
    sharedValue();
    firebase();
    super.initState();
  }

  void whatsappSender({@required number}) {
    final String url = "https://api.whatsapp.com/send?phone=$number";
    launch(url);
  }

  Widget dataTabletransfer(
      List<transfer.Transfer> TransferPricelist, String tableName) {
    return Card(
      color: Color(0xff7d8a99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: new BorderSide(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableName == "currency" ? "أسعار الدولار" : "أسعار الحوالات",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            Container(
              height: 210,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Theme(
                  data:
                      Theme.of(context).copyWith(dividerColor: Colors.white12),
                  child: DataTable(
                      dataTextStyle: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                      ),
                      headingRowHeight: 28,
                      horizontalMargin: 5.5,
                      dividerThickness: 2,
                      dataRowHeight: 30,
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
                        //remove head of table
                        DataColumn(
                            label: Expanded(
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'العرض',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              )
                            ],
                          )),
                        )),
                        DataColumn(
                            label: Expanded(
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'الطلب',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              )
                            ],
                          )),
                        )),
                        DataColumn(
                            label: Expanded(
                          child: Container(
                            // color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    'المدينة',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                      rows: [
                        for (int i = 0; i < TransferPricelist.length - 1; i++)
                          DataRow(cells: [
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TransferPricelist[i].buyStatus == "up"
                                      ? Icon(
                                          Icons.arrow_circle_up,
                                          color: Colors.green[700],
                                        )
                                      : Icon(
                                          Icons.arrow_circle_down,
                                          color: Colors.red[700],
                                        ),
                                  userPermissions.contains(
                                          'Update_Auction_Price_Permission')
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UpdatePrice(
                                                currencyPrice:
                                                    TransferPricelist[i],
                                                type: tableName,
                                              );
                                            }));
                                          },
                                          child: Text(
                                            TransferPricelist[i].buy.toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          child: Text(
                                            TransferPricelist[i].buy.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        )
                                ],
                              ),

                              // }
                            ),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TransferPricelist[i].sellStatus == "up"
                                      ? Icon(
                                          Icons.arrow_circle_up,
                                          color: Colors.green[700],
                                        )
                                      : Icon(
                                          Icons.arrow_circle_down,
                                          color: Colors.red[700],
                                        ),
                                  Text(
                                    TransferPricelist[i]
                                        .sell
                                        .toStringAsFixed(2),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    TransferPricelist[i].firstCity.name +
                                        " " +
                                        TransferPricelist[i].secondCity.name,
                                    maxLines: 1,
                                    // textWidthBasis: TextWidthBasis.parent,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Icon(
                                        Icons.remove_red_eye_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PriceChart(
                                            cityid: TransferPricelist[i].id,
                                            fromdate: 1,
                                            todate: 1,
                                            title: TransferPricelist[i]
                                                    .firstCity
                                                    .name +
                                                " " +
                                                TransferPricelist[i]
                                                    .secondCity
                                                    .name,
                                            type: tableName,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  (userPermissions
                                              .contains('Chat_Permission') ||
                                          userPermissions
                                              .contains('Trader_Permission'))
                                      ? InkWell(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Icon(
                                              TransferPricelist[i].close == 0
                                                  ? Icons.lock_clock
                                                  : Icons.lock_open

                                              //remove
                                              ,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PriceChart(
                                                  cityid:
                                                      TransferPricelist[i].id,
                                                  fromdate: 1,
                                                  todate: 1,
                                                  title: TransferPricelist[i]
                                                          .firstCity
                                                          .name +
                                                      " " +
                                                      TransferPricelist[i]
                                                          .secondCity
                                                          .name,
                                                  type: tableName,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(),
                                  (userPermissions.contains(
                                          'Update_Auction_Price_Permission'))
                                      ? InkWell(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Icon(
                                              TransferPricelist[i].close == 1
                                                  ? Icons.lock_clock
                                                  : Icons.lock_open
                                              //remove
                                              ,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PriceChart(
                                                  cityid:
                                                      TransferPricelist[i].id,
                                                  fromdate: 1,
                                                  todate: 1,
                                                  title: TransferPricelist[i]
                                                          .firstCity
                                                          .name +
                                                      " " +
                                                      TransferPricelist[i]
                                                          .secondCity
                                                          .name,
                                                  type: tableName,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container()
                                ],
                              ),
                            ))
                          ]),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataTable(List<CurrencyPrice?> currencyPricelist, String tableName) {
    return Card(
      color: Color(0xff7d8a99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: new BorderSide(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableName == "currency" ? "أسعار الدولار" : "أسعار الحوالات",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            Container(
              height: 270,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Theme(
                  data:
                      Theme.of(context).copyWith(dividerColor: Colors.white12),
                  child: DataTable(
                      dataTextStyle: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                      ),
                      headingRowHeight: 28,
                      horizontalMargin: 5.5,
                      dividerThickness: 2,
                      dataRowHeight: 30,
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
                        //remove head of table
                        DataColumn(
                            label: Expanded(
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'العرض',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              )
                            ],
                          )),
                        )),
                        DataColumn(
                            label: Expanded(
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'الطلب',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              )
                            ],
                          )),
                        )),
                        DataColumn(
                            label: Expanded(
                          child: Container(
                            // color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    'المدينة',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                      rows: [
                        for (var i = 0; i < currencyPricelist.length; i++)
                          DataRow(cells: [
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  currencyPricelist[i]!.buyStatus == "up"
                                      ? Icon(
                                          Icons.arrow_circle_up,
                                          color: Colors.green[700],
                                        )
                                      : Icon(
                                          Icons.arrow_circle_down,
                                          color: Colors.red[700],
                                        ),
                                  userPermissions.contains(
                                          'Update_Auction_Price_Permission')
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UpdatePrice(
                                                currencyPrice:
                                                    currencyPricelist[i]!,
                                                type: tableName,
                                              );
                                            }));
                                          },
                                          child: Text(
                                            currencyPricelist[i]!
                                                .buy
                                                .toString(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        )
                                      : Text(
                                          currencyPricelist[i]!.buy.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Cairo',
                                          ),
                                        )
                                ],
                              ),

                              // }
                            ),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  currencyPricelist[i]!.sellStatus == "up"
                                      ? Icon(
                                          Icons.arrow_circle_up,
                                          color: Colors.green[700],
                                        )
                                      : Icon(
                                          Icons.arrow_circle_down,
                                          color: Colors.red[700],
                                        ),
                                  Text(
                                    currencyPricelist[i]!
                                        .sell
                                        .toStringAsFixed(2),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  currencyPricelist[i]!.city.name,
                                  maxLines: 1,
                                  textWidthBasis: TextWidthBasis.parent,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PriceChart(
                                          cityid: tableName == "currency"
                                              ? currencyPricelist[i]!.city.id
                                              : currencyPricelist[i]!.id,
                                          fromdate: 1,
                                          todate: 1,
                                          title:
                                              currencyPricelist[i]!.city.name,
                                          type: tableName,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                (userPermissions.contains('Chat_Permission') ||
                                        userPermissions
                                            .contains('Trader_Permission'))
                                    ? InkWell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Icon(
                                            currencyPricelist[i]!.close == 0
                                                ? Icons.lock_clock
                                                : Icons.lock_open

                                            //remove
                                            ,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PriceChart(
                                                cityid: tableName == "currency"
                                                    ? currencyPricelist[i]!
                                                        .city
                                                        .id
                                                    : currencyPricelist[i]!.id,
                                                fromdate: 1,
                                                todate: 1,
                                                title: currencyPricelist[i]!
                                                    .city
                                                    .name,
                                                type: tableName,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(),
                                (userPermissions.contains(
                                        'Update_Auction_Price_Permission'))
                                    ? InkWell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Icon(
                                            currencyPricelist[i]!.close == 1
                                                ? Icons.lock_clock
                                                : Icons.lock_open
                                            //remove
                                            ,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PriceChart(
                                                cityid: tableName == "currency"
                                                    ? currencyPricelist[i]!
                                                        .city
                                                        .id
                                                    : currencyPricelist[i]!.id,
                                                fromdate: 1,
                                                todate: 1,
                                                title: currencyPricelist[i]!
                                                    .city
                                                    .name,
                                                type: tableName,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container()
                              ],
                            ))
                          ])
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
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
      // drawer: newDrawer(),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          height: 50,
          // margin: EdgeInsets.only(right: 60),
          child: Center(
            child: Image.asset('assest/Images/test2.png'),
          ),
        ),
        backgroundColor: Color(navbar.hashCode),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BorssaBloc, BorssaState>(
            listener: (context, state) {
              if (state is GetAllCityState) {
                setState(() {
                  print(state);
                  currencyprice = state.cities;
                  isloading = false;
                });
              } else if (state is BorssaErrorLoading) {
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
              } else if (state is GetAllTransfersLoading) {
                print(state);
              } else if (state is GetAllTransfersLoaded) {
                setState(() {
                  print(state);
                  transferprice = state.cities;
                  istransferloading = false;
                });
              } else if (state is GetAllTransfersError) {
                print(state);
                setState(() {
                  istransferloading = true;
                });
              }
            },
          ),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is UserLoginScreen) {
                setState(() {
                  sharedValue();
                });
                print(state);
              }
              if (state is ErrorLoginState) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('الرجاء التأكد من المعلومات المدخلة'),
                    action: SnackBarAction(
                      label: 'تنبيه',
                      onPressed: () {
                        // Code to execute.
                      },
                    ),
                  ),
                );
              } else if (state is LoginLoadingState) {
                setState(() {});
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              isloading
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : istrader == "null" && userActive != null
                      ? Container(
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Colors.transparent,
                                    child:
                                        Image.asset('assest/Images/Logo.png'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'هذه الصفحة خاصة بموظفي المصارف ومحلات الصرافة والمتعاملين الرسميين بالبورصة. للحصول على معلومات الدخول يمكن مراسلتنا على الرقم التالي 07700198027.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: phoneNumberTextEdit,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 17),
                                      hintText: 'الاسم',
                                    ),
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: passwordTextEdit,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 17),
                                      hintText: 'كلمة المرور',
                                    ),
                                    keyboardType: TextInputType.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  navbar)),
                                      child: Text(
                                        'دخول',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (passwordTextEdit.text.isEmpty ||
                                            phoneNumberTextEdit.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'الرجاء التأكد من المعلومات المدخلة'),
                                              action: SnackBarAction(
                                                label: 'تنبيه',
                                                onPressed: () {},
                                              ),
                                            ),
                                          );
                                        } else if (passwordTextEdit
                                                .text.isNotEmpty &&
                                            phoneNumberTextEdit
                                                .text.isNotEmpty) {
                                          authloginBloc.add(LoginSubmite(
                                              phone: phoneNumberTextEdit.text,
                                              password: passwordTextEdit.text));
                                        }
                                      },
                                    )),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              !istransferloading &&
                                      currencyprice.isNotEmpty &&
                                      transferprice.isNotEmpty
                                  ? Container(
                                      child: Column(
                                        children: [
                                          dataTable(currencyprice, "currency"),
                                          dataTabletransfer(
                                              transferprice, "transfer"),
                                          (userPermissions.contains(
                                                      'Trader_Permission') ||
                                                  userPermissions.contains(
                                                      'Update_Auction_Price_Permission'))
                                              ? Container()
                                              : istransferloading
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Card(
                                                        elevation: 4,
                                                        shadowColor:
                                                            Colors.black,
                                                        color:
                                                            Color(0xff7d8a99),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          side: new BorderSide(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Spacer(),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          24.0),
                                                              child: Container(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          auctionRead();
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => Auction()),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              right: 0.0,
                                                                              top: 0),
                                                                          child:
                                                                              Badge(
                                                                            badgeContent:
                                                                                Text(countofAuctions.toString()),
                                                                            child: Icon(Icons.account_balance_sharp,
                                                                                color: Colors.white,
                                                                                size: 55),
                                                                            showBadge: countofAuctions != 0
                                                                                ? true
                                                                                : false,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "المزاد المركزي",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontFamily:
                                                                              'Cairo',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          24.0),
                                                              child: Container(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                                  child: Column(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => GlobalAuction()),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .public_outlined,
                                                                          size:
                                                                              55,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "البورصة العالميه",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontFamily:
                                                                              'Cairo',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Spacer(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    )
                                  : Container()),
            ],
          ),
        ),
      ),
    );
  }
}
