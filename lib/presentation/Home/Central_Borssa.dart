import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/repositroy/CurrencyRepository.dart';
import 'package:central_borssa/presentation/Auction/Auction.dart';
import 'package:central_borssa/presentation/Auction/Price_Chart.dart';
import 'package:central_borssa/presentation/Auction/Update_Price.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_pusher/pusher.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:central_borssa/data/model/Transfer.dart' as transfer;

class CentralBorssa extends StatefulWidget {
  CentralBorssaPage createState() => CentralBorssaPage();
}

class CentralBorssaPage extends State<CentralBorssa> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late List<City> cities2 = [];
  late List<CurrencyPrice> currencyprice = [];
  late List<transfer.Transfer> transferprice = [];

  late bool isloading = true;
  late bool istransferloading = true;

  late BorssaBloc bloc;
  late Channel _ourChannel;
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
  late int userActive = 0;
  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    userLocation = "Empty";
    userPermissions = prefs.getStringList('permissions')!.toList();
    var y = userPermissions.contains('Update_Auction_Price_Permission');
    print('user permission$y');
    companyuser = int.parse(prefs.get('companyid').toString());
    userType = prefs.get('roles').toString();
    setState(() {});
  }

  @override
  void initState() {
    bloc = BlocProvider.of<BorssaBloc>(context);

    var now = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    String updatedDt = newFormat.format(now);
    startpoint = '$updatedDt 1:00:00.00';
    endpoint = DateTime.now().toString();
    bloc.add(AllCity());
    bloc.add(GetAllTransfersEvent());

    currencyprice.clear();
    sharedValue();
    currencypusher("TransferChannel");
    currencypusher("PriceChannel");

    super.initState();
  }

  Future<void> currencypusher(String channel) async {
    try {
      SharedPreferences _pref = await SharedPreferences.getInstance();
      test = _pref.get('roles').toString();
      // print(test);
      await Pusher.init(
          'borsa_app',
          PusherOptions(
              cluster: 'mt1',
              host: 'www.ferasalhallak.online',
              encrypted: false,
              port: 6001));
    } catch (e) {
      print(e);
    }
    Pusher.connect(onConnectionStateChange: (val) {
      print(val!.currentState);
    }, onError: (error) {
      print(error!.message);
    });
    if (channel == "TransferChannel") {
      //Subscribe
      _ourChannel = await Pusher.subscribe('TransferChannel');

      //Bind
      _ourChannel.bind('Change', (onEvent) {
        print(onEvent!.data);
        bloc.add(GetAllTransfersEvent());
      });
    }
    if (channel == "PriceChannel") {
      //Subscribe
      _ourChannel = await Pusher.subscribe('PriceChannel');

      //Bind
      _ourChannel.bind('Change', (onEvent) {
        print(onEvent!.data);
        bloc.add(AllCity());
      });
    }
  }

  Widget dataTable(List<dynamic> currencyPricelist, String tableName) {
    return Column(
      children: [
        Container(
          width: 200,
          child: Card(
            color: Color(0xff7d8a99),
            child: Text(
              tableName == "currency" ? "أسعار الدولار" : "أسعار الحوالات",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 0),
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
                borderRadius: BorderRadius.circular(10),
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
                          userPermissions
                                  .contains('Update_Auction_Price_Permission')
                              ? InkWell(
                                  onTap: () {
                                    var route = new MaterialPageRoute(
                                        builder: (BuildContext contex) =>
                                            new BlocProvider(
                                              create: (context) => CurrencyBloc(
                                                  CurrencyInitial(),
                                                  CurrencyRepository()),
                                              child: UpdatePrice(
                                                id: currencyPricelist[i].id,
                                                buy: currencyPricelist[i].buy,
                                                sell: currencyPricelist[i].sell,
                                                buystate: currencyPricelist[i]
                                                    .buyStatus,
                                                sellstate: currencyPricelist[i]
                                                    .sellStatus,
                                                type: tableName,
                                                close:
                                                    currencyPricelist[i].close,
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
                                    cityid: currencyPricelist[i].city.id,
                                    fromdate: 1,
                                    todate: 1,
                                    title: currencyPricelist[i].city.name,
                                    type: tableName,
                                  ),
                                ),
                              );
                            },
                          ),
                          userPermissions.contains(
                                      'Update_Auction_Price_Permission') &&
                                  tableName == "currency"
                              ? InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      currencyPricelist[i].close == 0
                                          ? Icons.lock_open_rounded
                                          //remove
                                          : Icons.lock_clock_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PriceChart(
                                          cityid: currencyPricelist[i].city.id,
                                          fromdate: 1,
                                          todate: 1,
                                          title: currencyPricelist[i].city.name,
                                          type: tableName,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                          // Checkbox(
                          //   checkColor: Colors.white,
                          //   value: isClose,
                          //   onChanged: (bool? value) {
                          //     isClose = value!;
                          //   },
                          // ),
                        ],
                      ),
                    ))
                  ]),
              ]),
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
      body: BlocListener<BorssaBloc, BorssaState>(
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              isloading
                  ? Container(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Container(
                      child: Column(
                        children: [
                          dataTable(currencyprice, "currency"),
                          istransferloading
                              ? Container()
                              : dataTable(transferprice, "transfer"),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Container(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(navbar.hashCode),
                                        alignment: Alignment.center),
                                    onPressed: () {
                                      // getChart();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Auction()),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Icon(Icons.account_balance_sharp),
                                          Text(
                                            "البورصة المركزيه",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(navbar.hashCode),
                                          alignment: Alignment.center),
                                      onPressed: () {
                                        // getChart();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.public_outlined,
                                            ),
                                            Text(
                                              "البورصة العالميه",
                                            ),
                                          ],
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
