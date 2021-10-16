import 'package:central_borssa/business_logic/Auction/bloc/auction_bloc.dart';
import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Auction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:open_file/open_file.dart';

class Auction extends StatefulWidget {
  AuctionPage createState() => AuctionPage();
}

class AuctionPage extends State<Auction> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late List<City> cities2 = [];
  late List<Auctions> auctionsfile = [];
  late bool isloading = true;
  late AuctionBloc bloc;
  late String? test;
  late String startpoint;
  late String endpoint;

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
    bloc = BlocProvider.of<AuctionBloc>(context);

    var now = DateTime.now();
    var newFormat = DateFormat("yyyy-MM-dd");
    String updatedDt = newFormat.format(now);
    startpoint = '$updatedDt 1:00:00.00';
    endpoint = DateTime.now().toString();
    bloc.add(GetAuctionEvent());
    auctionsfile.clear();
    sharedValue();
    super.initState();
  }

  Widget dataTable() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12),
      child: DataTable(
          dataTextStyle: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
          headingRowHeight: 28,
          horizontalMargin: 5.5,
          dividerThickness: 2,
          dataRowHeight: 50,
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
                      'القيمة',
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
                      'الملف',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        'التاريخ',
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
            for (int i = 0; i < auctionsfile.length; i++)
              DataRow(cells: [
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        auctionsfile[i].value,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),

                  // }
                ),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   currencyprice[i].value,
                      //   maxLines: 1,
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          print('from file');
                          openfiel(auctionsfile[i].filePath);
                        },
                        child: Icon(
                          Icons.file_copy_sharp,
                          color: Color(Colors.white.hashCode),
                        ),
                      )
                    ],
                  ),
                ),
                DataCell(Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        DateFormat.yMd()
                            .format(DateTime.parse(auctionsfile[i].createdAt)),
                        maxLines: 1,
                        textWidthBasis: TextWidthBasis.parent,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ))
              ]),
          ]),
    );
  }

  logout() async {
    print('from');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('المزاد المركزي'),
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
      body: BlocListener<AuctionBloc, AuctionState>(
        listener: (context, state) {
          if (state is GetAuctionLoading) {
            print(state);
          } else if (state is GetAuctionLoaded) {
            print(state);
            auctionsfile = state.auctions;
            setState(() {
              isloading = false;
            });
          } else if (state is GetAuctionError) {
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
        child: Column(
          children: <Widget>[
            isloading
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    child: dataTable(),
                  ),
          ],
        ),
      ),
    );
  }

  openfiel(String filePath) {
    OpenFile.open(filePath);
  }
}
