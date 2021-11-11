import 'package:central_borssa/business_logic/Global%20Auction/bloc/globalauction_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/GlobalAuction.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:central_borssa/presentation/Share/GlobalTable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_pusher/pusher.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_bloc.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flag/flag.dart';

class GlobalAuction extends StatefulWidget {
  GlobalAuctionPage createState() => GlobalAuctionPage();
}

class GlobalAuctionPage extends State<GlobalAuction> {
  late GlobalauctionBloc bloc2;
  Rates? rates;

  bool isClose = false;
  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  TextEditingController productValueTextEdit = TextEditingController(text: '1');
  late int productValue = 1;
  TextEditingController productvalue = TextEditingController(text: '1');
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
    bloc2 = BlocProvider.of<GlobalauctionBloc>(context);
    bloc2.add(GetGlobalauctionEvent());
    super.initState();
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
          child: Text('البورصة العالمية'),
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
      body: BlocListener<GlobalauctionBloc, GlobalauctionState>(
        listener: (context, state) {
          if (state is GetGlobalauctionLoading) {
            print(state);
          } else if (state is GetGlobalauctionLoaded) {
            rates = null;

            print(productValue);
            print(state);
            rates = state.rates;
            setState(() {});
          } else if (state is GetGlobalauctionError) {
            print(state);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    rates != null
                        ? Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              print(productValue);
                                              setState(() {
                                                bloc2.add(
                                                    GetGlobalauctionEvent());
                                                rates = null;
                                              });
                                            },
                                            child: Text('تحويل')),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: new Theme(
                                                data: new ThemeData(
                                                    primaryColor: Colors.red,
                                                    primaryColorDark:
                                                        Colors.red,
                                                    focusColor: Colors.red),
                                                child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: TextFormField(
                                                      textAlign:
                                                          TextAlign.right,
                                                      cursorColor: Colors.black,
                                                      controller:
                                                          productValueTextEdit,
                                                      // maxLength: 4,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          productValue =
                                                              int.parse(value!);
                                                        });
                                                      },
                                                      onSaved: (String? value) {
                                                        setState(() {
                                                          productValue =
                                                              int.parse(value!);
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 40, 35),
                                                        labelText: 'القيمة',
                                                        labelStyle: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                        fillColor: Colors.red,
                                                        border:
                                                            OutlineInputBorder(),
                                                        enabledBorder: new OutlineInputBorder(
                                                            borderSide:
                                                                new BorderSide(
                                                                    color: Color(
                                                                        navbar
                                                                            .hashCode))),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 3,
                                                              color: Color(navbar
                                                                  .hashCode)),
                                                        ),
                                                      ),
                                                    )))),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            child: Center(child: CircularProgressIndicator())),
                    if (rates != null)
                      GlobalTable(
                        r: rates,
                        product: productValue,
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
