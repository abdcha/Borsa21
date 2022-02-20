import 'package:central_borssa/business_logic/Global%20Auction/bloc/globalauction_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/GlobalAuction.dart';
import 'package:central_borssa/presentation/Main/Loginpage.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global extends StatefulWidget {
  GlobalPage createState() => GlobalPage();
}

class GlobalPage extends State<Global> {
  late GlobalauctionBloc bloc2;
  Rates? rates;
  bool isCalculate = false;
  bool isload = true;
  int current = 1;
  bool isClose = false;
  late List<String> userPermissions = [];
  late String userName = "";
  late String userPhone = "";
  late String userLocation = "";
  late String userType = "";
  TextEditingController productValueTextEdit = TextEditingController(text: '1');
  late double productValue = 1.0;
  TextEditingController productvalue = TextEditingController(text: '1');
  int companyuser = 0;
  late int userActive = 0;

  // sharedValue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userName = prefs.get('username').toString();
  //   userPhone = prefs.get('userphone').toString();
  //   userLocation = "Empty";
  //   userPermissions = prefs.getStringList('permissions')!.toList();
  //   var y = userPermissions.contains('Update_Auction_Price_Permission');
  //   print('user permission$y');
  //   companyuser = int.parse(prefs.get('companyid').toString());
  //   userType = prefs.get('roles').toString();
  //   await Future.delayed(Duration(milliseconds: 50));
  // }

  @override
  void initState() {
    bloc2 = BlocProvider.of<GlobalauctionBloc>(context);
    bloc2.add(GetGlobalauctionEvent());
    // sharedValue();

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

  Widget globaltable(Rates rates) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Container(
        //     width: 200,
        //   ),
        // ),
        Container(
          width: double.infinity,
          // margin: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 0),
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
                          'المدينه',
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
                          'السعر',
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
                            ' الدولار',
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
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.EU,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'يورو',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.eUR.rate,
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
                          rates.eUR.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.CN,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'يوان صيني',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.cNY.rate,
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
                          rates.cNY.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.AE,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'الدرهم الإماراتي',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.aED.rate,
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
                          rates.aED.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.CA,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'الدولار الكندي',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.cAD.rate,
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
                          rates.cAD.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.QA,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'ريال قطري',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.qAR.rate,
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
                          rates.qAR.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.SA,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'ريال سعودي',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.sAR.rate,
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
                          rates.sAR.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.TR,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'ليرة تركية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.tRY.rate,
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
                          rates.tRY.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.GB,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'جنيه إسترليني',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.gBP.rate,
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
                          rates.gBP.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.JP,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'ين ياباني',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.jPY.rate,
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
                          rates.jPY.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.SE,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'كرونة سويدية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.sEK.rate,
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
                          rates.sEK.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.NO,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'كرونة نرويجية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.nOK.rate,
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
                          rates.nOK.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.DK,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'كرونة دنماركية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.dKK.rate,
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
                          rates.dKK.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.AZ,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'مانات أذربيجاني',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.aZN.rate,
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
                          rates.aZN.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.LB,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'ليرة لبنانية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.lBP.rate,
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
                          rates.lBP.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.EG,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'جنيه مصري',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.eGP.rate,
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
                          rates.eGP.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.BH,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'دينار بحريني',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.bHD.rate,
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
                          rates.bHD.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
                DataRow(cells: [
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.KW,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'دينار كويتي',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          rates.kWD.rate,
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
                          rates.kWD.rateForAmount,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Flag.fromCode(
                              FlagsCode.US,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ]),
              ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6e7d91),
      drawer: null,
      appBar: userType == "Trader"
          ? new AppBar(
              title: Container(
                height: 50,
                margin: EdgeInsets.only(right: 60),
                child: Center(
                  child: Image.asset('assest/Images/test2.png'),
                ),
              ),
              backgroundColor: Color(navbar.hashCode),
            )
          : new AppBar(
              automaticallyImplyLeading: false,
              title: Container(
                height: 50,
                child: Center(
                  child: Image.asset('assest/Images/test2.png'),
                ),
              ),
              backgroundColor: Color(navbar.hashCode),
            ),
      body: BlocListener<GlobalauctionBloc, GlobalauctionState>(
        listener: (context, state) {
          if (state is GetGlobalauctionLoading) {
            print(state);
          } else if (state is GetGlobalauctionLoaded) {
            print(productValue);
            print(state);
            rates = state.rates;
            setState(() {
              isCalculate = true;
            });
          } else if (state is GetGlobalauctionError) {
            print(state);
          } else if (state is GetProductGlobalauctionLoading) {
            print(state);
          } else if (state is GetProductGlobalauctionError) {
            print(state);
          } else if (state is GetProductGlobalauctionLoaded) {
            print(state);
            rates = state.rates;
            setState(() {
              current++;
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: isCalculate && rates != null
                ? Card(
                    color: Color(0xff7d8a99),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: new BorderSide(color: Colors.white),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Card(
                            color: Color(0xff6e7d91),
                            elevation: 5.0,
                            child: Column(
                              children: [
                                rates != null
                                    ? Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    bloc2.add(
                                                        ProductGlobalauctionEvent(
                                                            prodcut:
                                                                productValue));
                                                  },
                                                  child: Text('تحويل'),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Color(
                                                                  0xff6e7d99)),
                                                      shadowColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .black)),
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: Container(
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            230,
                                                    child: new Theme(
                                                        data: new ThemeData(
                                                            primaryColor:
                                                                Colors.red,
                                                            primaryColorDark:
                                                                Colors.red,
                                                            focusColor:
                                                                Colors.red),
                                                        child: Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child:
                                                                TextFormField(
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              cursorColor:
                                                                  Colors.white,
                                                              maxLength: 18,
                                                              controller:
                                                                  productValueTextEdit,
                                                              // maxLength: 4,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                if (value !=
                                                                    null) {
                                                                  productValue =
                                                                      double.parse(
                                                                          value);
                                                                }
                                                                if (value ==
                                                                    null) {
                                                                  productValue =
                                                                      1.0;
                                                                }
                                                              },
                                                              onSaved: (String?
                                                                  value) {
                                                                setState(() {
                                                                  productValue =
                                                                      double.parse(
                                                                          value!);
                                                                });
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            8,
                                                                            8),
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                fillColor:
                                                                    Colors.red,
                                                                border:
                                                                    OutlineInputBorder(),
                                                                enabledBorder: new OutlineInputBorder(
                                                                    borderSide:
                                                                        new BorderSide(
                                                                            color:
                                                                                Colors.white)),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              3,
                                                                          color:
                                                                              Colors.white),
                                                                ),
                                                              ),
                                                            )))),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text(
                                                  'قيمة التحويل',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
                                globaltable(rates!)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(child: Center(child: CircularProgressIndicator())),
          ),
        ),
      ),
    );
  }
}
