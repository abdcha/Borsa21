import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
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

  late bool isloading = true;
  late bool istransferloading = true;

  late BorssaBloc bloc;
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
    sharedValue();

    super.initState();
  }

  Future<void> currencypusher(String channel) async {}

  Widget dataTable(double buy, double sell, String name) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25.0,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 0),
            child: DataTable(
                dataTextStyle: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                ),
                headingRowHeight: 28,
                horizontalMargin: 5.5,
                dividerThickness: 2,
                dataRowHeight: 120,
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
                  DataColumn(
                      label: Expanded(
                    child: Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            name,
                            style: TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )
                      ],
                    )),
                  )),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flag.fromCode(
                                  FlagsCode.IQ,
                                  height: 30,
                                  width: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                  ),
                                ),
                                Flag.fromCode(
                                  FlagsCode.US,
                                  height: 30,
                                  width: 30,
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 12),
                                  child: InkWell(
                                    child: Text(
                                      buy.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flag.fromCode(
                                    FlagsCode.IQ,
                                    height: 30,
                                    width: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      right: 8.0,
                                    ),
                                  ),
                                  Flag.fromCode(
                                    FlagsCode.US,
                                    height: 30,
                                    width: 30,
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, right: 12),
                                    child: InkWell(
                                      child: Text(
                                        sell.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
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
                    ),
                  ]),
                ]),
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
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    dataTable(122.2, 1222.9, "بغداد"),
                    dataTable(122.2, 1222.9, "االشمال"),
                    dataTable(122.2, 1222.9, 'االجنوب'),
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
