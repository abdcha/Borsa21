import 'package:badges/badges.dart';
import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/repositroy/CurrencyRepository.dart';
import 'package:central_borssa/presentation/Auction/Auction.dart';
import 'package:central_borssa/presentation/Auction/GlobalAuction.dart';
import 'package:central_borssa/presentation/Auction/Price_Chart.dart';
import 'package:central_borssa/presentation/Auction/Update_Price.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:my_flutter_pusher/pusher.dart';
import 'package:pusher_client/pusher_client.dart';

import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:central_borssa/data/model/Transfer.dart' as transfer;
import 'dart:ui' as ui;

import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';

class CentralBorssa extends StatefulWidget {
  CentralBorssaPage createState() => CentralBorssaPage();
}

class CentralBorssaPage extends State<CentralBorssa> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late List<City> cities2 = [];
  late List<CurrencyPrice> currencyprice = [];
  late List<transfer.Transfer> transferprice = [];
  late bool isloading = false;
  late bool istransferloading = true;
  late BorssaBloc bloc;
  late LoginBloc loginbloc;
  late String temp2 = "ss";

  late String? test;
  late String startpoint;
  late String endpoint;
  bool isClose = false;
  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  int companyuser = 0;
  late PusherClient pusher;
  // ignore: avoid_init_to_null
  late String? userActive = null;
  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginbloc.add(MeInformationEvent());

    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    userLocation = "Empty";
    userPermissions = prefs.getStringList('permissions')!.toList();
    if (prefs.get('end_at') != null) {
      userActive = prefs.get('end_at').toString();
      setState(() {
        isloading = false;
      });
    }
    var y = userPermissions.contains('Trader_Permission');
    print('user permission$y');
    companyuser = int.parse(prefs.get('companyid').toString());
    userType = prefs.get('roles').toString();
    setState(() {});
  }

  firebase() {
    FirebaseMessaging.onMessage.handleError((error) {
      print("Erorrrrrr : ${error.toString()}");
    }).listen((event) {
      if (event.data['type'] == "currency_price_change") {
        String? temp = event.notification!.body;
        temp2 = temp!;
        print('------');
        print(event.notification?.title.toString());
        print(event.notification?.body.toString());
        print('------');

        bloc.add(AllCity());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(temp2),
            action: SnackBarAction(
              label: 'تنبيه',
              onPressed: () {},
            ),
          ),
        );
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return Container(
        //         color: Colors.transparent,
        //         height: 30,
        //         child: AlertDialog(
        //             content: SingleChildScrollView(
        //           child: ListBody(
        //             children: <Widget>[
        //               Padding(
        //                   padding: EdgeInsets.only(left: 8.0),
        //                   child: Center(
        //                     child: Text(temp2),
        //                   )),
        //             ],
        //           ),
        //         )),
        //       );
        //     });
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) {
        //   return CentralBorssa();
        // }));
        // Navigator.pop(context);
      } else if (event.data['type'] == "transfer_change") {
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       Future.delayed(Duration(milliseconds: 12), () {
        //         Navigator.of(context).pop(true);
        //       });
        //       return AlertDialog(
        //           title: const Text(''),
        //           content: SingleChildScrollView(
        //             child: ListBody(
        //               children: const <Widget>[
        //                 Text('تجديد إشتراك'),
        //                 Text('لقد تم تجديد إشتراكّ'),
        //               ],
        //             ),
        //           ));
        //     });

      } else if (event.data['type'] == "trader_currency_price_change") {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                  child: AlertDialog(
                      title: const Text('البورصة المركزية'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('some text from here'),
                          ],
                        ),
                      )));
            });
      }
    });
  }

  @override
  void initState() {
    bloc = BlocProvider.of<BorssaBloc>(context);
    loginbloc = BlocProvider.of<LoginBloc>(context);

    var now = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    String updatedDt = newFormat.format(now);
    startpoint = '$updatedDt 1:00:00.00';
    endpoint = DateTime.now().toString();
    bloc.add(AllCity());
    bloc.add(GetAllTransfersEvent());
    currencyprice.clear();
    sharedValue();
    firebase();
    if (!isloading) {
      currencypusher("TransferChannel");
      currencypusher("PriceChannel");
    }

    super.initState();
  }

  void whatsappSender({@required number}) async {
    final String url = "https://api.whatsapp.com/send?phone=$number";
    await launch(url);
  }

  Future<void> currencypusher(String channel) async {
    // print('good step');
    // PusherOptions options = PusherOptions(
    //   host: 'www.ferasalhallak.online',
    //   wsPort: 6001,
    //   encrypted: false,
    // );
    // pusher = PusherClient('borsa_app', options, autoConnect: true);
    // pusher.connect();
    // pusher.onConnectionStateChange((state) {
    //   print(state!.currentState);
    // });
    // pusher.onConnectionError((error) {
    //   print("error: ${error!.message}");
    // });

    // if (channel == "PriceChannel") {
    //   _ourChannel = pusher.subscribe('PriceChannel');

    //   _ourChannel.bind('Change', (onEvent) {
    //     print(onEvent!.data);
    //     bloc.add(AllCity());
    //   });
    // }
    // SharedPreferences _pref = await SharedPreferences.getInstance();
    // test = _pref.get('roles').toString();
    // // print(test);
    // await Pusher.init(
    //     'borsa_app',
    //     PusherOptions(
    //         cluster: 'mt1',
    //         host: 'www.ferasalhallak.online',
    //         encrypted: false,
    //         port: 6001));
    // Pusher.connect(onConnectionStateChange: (val) {
    //   print(val!.currentState);
    // }, onError: (error) {
    //   print(error!.message);
    // });
    // if (channel == "TransferChannel") {
    //   //Subscribe
    //   _ourChannel = await Pusher.subscribe('TransferChannel');

    //   //Bind
    //   _ourChannel.bind('Change', (onEvent) {
    //     print(onEvent!.data);
    //     bloc.add(GetAllTransfersEvent());
    //   });
    // }
    // if (channel == "PriceChannel") {
    //   //Subscribe
    //   _ourChannel = await Pusher.subscribe('PriceChannel');

    //   //Bind
    //   _ourChannel.bind('Change', (onEvent) {
    //     print(onEvent!.data);
    //     bloc.add(AllCity());
    //   });
    // }
  }

  Widget dataTabletransfer(List<dynamic> currencyPricelist, String tableName) {
    return Card(
      color: Color(0xff7d8a99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: new BorderSide(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tableName == "currency" ? "أسعار الدولار" : "أسعار الحوالات",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Container(
            height: 210,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.white12),
                child: DataTable(
                    dataTextStyle: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
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
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.bold,
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
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.bold,
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
                                    color: const Color(0xffffffff),
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
                      for (int i = 0; i < currencyPricelist.length; i++)
                        DataRow(cells: [
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                currencyPricelist[i].buyStatus == "up"
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
                                          var route = new MaterialPageRoute(
                                              builder: (BuildContext contex) =>
                                                  new BlocProvider(
                                                    create: (context) =>
                                                        CurrencyBloc(
                                                            CurrencyInitial(),
                                                            CurrencyRepository()),
                                                    child: UpdatePrice(
                                                      cityid: tableName ==
                                                              "currency"
                                                          ? currencyPricelist[i]
                                                              .city
                                                              .id
                                                          : currencyPricelist[i]
                                                              .id,
                                                      id: currencyPricelist[i]
                                                          .id,
                                                      buy: currencyPricelist[i]
                                                          .buy,
                                                      sell: currencyPricelist[i]
                                                          .sell,
                                                      buystate:
                                                          currencyPricelist[i]
                                                              .buyStatus,
                                                      sellstate:
                                                          currencyPricelist[i]
                                                              .sellStatus,
                                                      type: tableName,
                                                      close:
                                                          currencyPricelist[i]
                                                              .close,
                                                    ),
                                                  ));

                                          BlocProvider(
                                              create: (context) => CurrencyBloc(
                                                  CurrencyInitial(),
                                                  CurrencyRepository()));
                                          Navigator.of(context).push(route);
                                        },
                                        child: Text(
                                          currencyPricelist[i].buy.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        child: Text(
                                          currencyPricelist[i].buy.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
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
                                currencyPricelist[i].sellStatus == "up"
                                    ? Icon(
                                        Icons.arrow_circle_up,
                                        color: Colors.green[700],
                                      )
                                    : Icon(
                                        Icons.arrow_circle_down,
                                        color: Colors.red[700],
                                      ),
                                Text(
                                  currencyPricelist[i].sell.toStringAsFixed(2),
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
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
                                  currencyPricelist[i].firstCity.name +
                                      "" +
                                      currencyPricelist[i].secondCity.name,
                                  maxLines: 1,
                                  textWidthBasis: TextWidthBasis.parent,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w400,
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
                                              ? currencyPricelist[i].city.id
                                              : currencyPricelist[i].id,
                                          fromdate: 1,
                                          todate: 1,
                                          title: tableName == "currency"
                                              ? currencyPricelist[i].city.name
                                              : currencyPricelist[i]
                                                      .firstCity
                                                      .name +
                                                  " " +
                                                  currencyPricelist[i]
                                                      .secondCity
                                                      .name,
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
                                            currencyPricelist[i].close == 0
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
                                                    ? currencyPricelist[i]
                                                        .city
                                                        .id
                                                    : currencyPricelist[i].id,
                                                fromdate: 1,
                                                todate: 1,
                                                title: tableName == "currency"
                                                    ? currencyPricelist[i]
                                                        .city
                                                        .name
                                                    : currencyPricelist[i]
                                                            .firstCity
                                                            .name +
                                                        " " +
                                                        currencyPricelist[i]
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
                                            currencyPricelist[i].close == 1
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
                                                    ? currencyPricelist[i]
                                                        .city
                                                        .id
                                                    : currencyPricelist[i].id,
                                                fromdate: 1,
                                                todate: 1,
                                                title: tableName == "currency"
                                                    ? currencyPricelist[i]
                                                        .city
                                                        .name
                                                    : currencyPricelist[i]
                                                            .firstCity
                                                            .name +
                                                        " " +
                                                        currencyPricelist[i]
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
    );
  }

  Widget dataTable(List<dynamic> currencyPricelist, String tableName) {
    return Card(
      color: Color(0xff7d8a99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: new BorderSide(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tableName == "currency" ? "أسعار الدولار" : "أسعار الحوالات",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Container(
            height: 270,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.white12),
                child: DataTable(
                    dataTextStyle: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                    headingRowHeight: 28,
                    horizontalMargin: 5.5,
                    dividerThickness: 2,
                    dataRowHeight: 30,
                    columnSpacing: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
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
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.bold,
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
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.bold,
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
                                    color: const Color(0xffffffff),
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
                      for (int i = 0; i < currencyPricelist.length; i++)
                        DataRow(cells: [
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                currencyPricelist[i].buyStatus == "up"
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
                                          var route = new MaterialPageRoute(
                                              builder: (BuildContext contex) =>
                                                  new BlocProvider(
                                                    create: (context) =>
                                                        CurrencyBloc(
                                                            CurrencyInitial(),
                                                            CurrencyRepository()),
                                                    child: UpdatePrice(
                                                      cityid:
                                                          currencyPricelist[i]
                                                              .city
                                                              .id,
                                                      id: currencyPricelist[i]
                                                          .id,
                                                      buy: currencyPricelist[i]
                                                          .buy,
                                                      sell: currencyPricelist[i]
                                                          .sell,
                                                      buystate:
                                                          currencyPricelist[i]
                                                              .buyStatus,
                                                      sellstate:
                                                          currencyPricelist[i]
                                                              .sellStatus,
                                                      type: tableName,
                                                      close:
                                                          currencyPricelist[i]
                                                              .close,
                                                    ),
                                                  ));

                                          BlocProvider(
                                              create: (context) => CurrencyBloc(
                                                  CurrencyInitial(),
                                                  CurrencyRepository()));
                                          Navigator.of(context).push(route);
                                        },
                                        child: Text(
                                          currencyPricelist[i].buy.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        child: Text(
                                          currencyPricelist[i].buy.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
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
                                currencyPricelist[i].sellStatus == "up"
                                    ? Icon(
                                        Icons.arrow_circle_up,
                                        color: Colors.green[700],
                                      )
                                    : Icon(
                                        Icons.arrow_circle_down,
                                        color: Colors.red[700],
                                      ),
                                Text(
                                  currencyPricelist[i].sell.toStringAsFixed(2),
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                currencyPricelist[i].city.name,
                                maxLines: 1,
                                textWidthBasis: TextWidthBasis.parent,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w400,
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
                                            ? currencyPricelist[i].city.id
                                            : currencyPricelist[i].id,
                                        fromdate: 1,
                                        todate: 1,
                                        title: tableName == "currency"
                                            ? currencyPricelist[i].city.name
                                            : currencyPricelist[i]
                                                    .firstCity
                                                    .name +
                                                " " +
                                                currencyPricelist[i]
                                                    .secondCity
                                                    .name,
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
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Icon(
                                          currencyPricelist[i].close == 0
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
                                                  ? currencyPricelist[i].city.id
                                                  : currencyPricelist[i].id,
                                              fromdate: 1,
                                              todate: 1,
                                              title: tableName == "currency"
                                                  ? currencyPricelist[i]
                                                      .city
                                                      .name
                                                  : currencyPricelist[i]
                                                          .firstCity
                                                          .name +
                                                      " " +
                                                      currencyPricelist[i]
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
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Icon(
                                          currencyPricelist[i].close == 1
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
                                                  ? currencyPricelist[i].city.id
                                                  : currencyPricelist[i].id,
                                              fromdate: 1,
                                              todate: 1,
                                              title: tableName == "currency"
                                                  ? currencyPricelist[i]
                                                      .city
                                                      .name
                                                  : currencyPricelist[i]
                                                          .firstCity
                                                          .name +
                                                      " " +
                                                      currencyPricelist[i]
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
                          ))
                        ])
                    ]),
              ),
            ),
          ),
        ],
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
      backgroundColor: Color(0xff6e7d91),
      // drawer: newDrawer(),
      appBar: AppBar(
        title: Container(
          height: 50,
          // margin: EdgeInsets.only(right: 60),
          child: Center(
            child: Image.asset('assest/Images/test2.png'),
          ),
        ),
        actions: [
          // Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //     child: InkWell(
          //         child: Badge(
          //           badgeContent: Text('3'),
          //           child: Icon(Icons.notification_add_outlined),
          //         ),
          //         onTap: () {
          //           showDialog(
          //               // barrierColor: Colors.transparent,
          //               context: context,
          //               builder: (context) {
          //                 return Directionality(
          //                   textDirection: ui.TextDirection.rtl,
          //                   child: Center(
          //                     child: Container(
          //                         width: MediaQuery.of(context).size.width - 80,
          //                         height:
          //                             MediaQuery.of(context).size.height - 350,
          //                         child: Card(
          //                           child: Column(
          //                             children: [
          //                               Card(
          //                                 child: Row(
          //                                   children: [
          //                                     Padding(
          //                                       padding:
          //                                           const EdgeInsets.all(8.0),
          //                                       child: Column(
          //                                         crossAxisAlignment:
          //                                             CrossAxisAlignment.start,
          //                                         children: [
          //                                           Row(
          //                                             children: [
          //                                               Text(
          //                                                 'البورصة المركزية',
          //                                               ),
          //                                             ],
          //                                           ),
          //                                           Row(
          //                                             children: [
          //                                               Text(
          //                                                 'بعض من النصوص من أجل التوضيح',
          //                                               ),
          //                                             ],
          //                                           ),
          //                                         ],
          //                                       ),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                               Card(
          //                                 child: Row(
          //                                   children: [
          //                                     Padding(
          //                                       padding:
          //                                           const EdgeInsets.all(8.0),
          //                                       child: Column(
          //                                         crossAxisAlignment:
          //                                             CrossAxisAlignment.start,
          //                                         children: [
          //                                           Text(
          //                                             'البورصة المركزية',
          //                                           ),
          //                                           Text(
          //                                               'بعض من النصوص من أجل التوضيح')
          //                                         ],
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         )),
          //                   ),
          //                 );
          //               });
          //         })),
        ],
        backgroundColor: Color(navbar.hashCode),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BorssaBloc, BorssaState>(
            listener: (context, state) {
              if (state is BorssaReloadingState) {
                print(state);
              } else if (state is GetAllCityState) {
                print(state);
                currencyprice = state.cities;
                setState(() {
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
                print(state);
                transferprice = state.cities;
                setState(() {
                  istransferloading = false;
                });
              } else if (state is GetAllTransfersError) {
                print(state);
              }
            },
          ),
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is MeInformationLoading) {
                print(state);
              } else if (state is MeInformationLoaded) {
                print(state);
                setState(() {});
              } else if (state is MeInformationError) {
                print(state);
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
                  : (userPermissions.contains('Trader_Permission') &&
                              ((userActive == DateTime.now().toString()) ||
                                  (userActive == null))) ||
                          (userPermissions.contains('Chat_Permission') &&
                              ((userActive == DateTime.now().toString()) ||
                                  (userActive == null)))
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
                                    child: InkWell(
                                      onTap: () {
                                        whatsappSender(number: '07700198027');
                                      },
                                      child: Text(
                                        'هذه الصفحة خاصة بموظفي المصارف ومحلات الصرافة والمتعاملين الرسميين بالبورصات. للحصول على معلومات نرجو التواصل معنا من خلال الرقم التالي 07700198027.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              children: [
                                istransferloading
                                    ? Container()
                                    : dataTable(currencyprice, "currency"),
                                istransferloading
                                    ? Container()
                                    : dataTabletransfer(
                                        transferprice, "transfer"),
                                (userPermissions
                                            .contains('Trader_Permission') ||
                                        userPermissions.contains(
                                            'Update_Auction_Price_Permission'))
                                    ? Container()
                                    : istransferloading
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Card(
                                              elevation: 4,
                                              shadowColor: Colors.black,
                                              color: Color(0xff7d8a99),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                side: new BorderSide(
                                                    color: Colors.white),
                                              ),
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 24.0),
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Auction()),
                                                                );
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .account_balance_sharp,
                                                                color: Colors
                                                                    .white,
                                                                size: 55,
                                                              ),
                                                            ),
                                                            Text(
                                                                "المزاد المركزي",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white54)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 24.0),
                                                    child: Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              GlobalAuction()),
                                                                );
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .public_outlined,
                                                                size: 55,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Text(
                                                              "البورصة العالميه",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white54),
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
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
