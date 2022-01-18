import 'package:central_borssa/business_logic/Auction/bloc/auction_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Auction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  bool _isLoading = false;
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  sharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.get('username').toString();
    userPhone = prefs.get('userphone').toString();
    userLocation = "Empty";
    userPermissions = prefs.getStringList('permissions')!.toList();
    var y = userPermissions.contains('Update_Auction_Price_Permission');
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

  openFile(String filePath) async {
    setState(() {
      _isLoading = true;
    });
    print(_isLoading);
    // OpenFile.open(filePath);
  }

  Widget dataTable() {
    return Container(
      height: MediaQuery.of(context).size.height - 190,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
                            myFormat.format(int.parse(auctionsfile[i].value)),
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
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        backgroundColor: Color(navbar.hashCode),
                                        title: Center(
                                          child: Text('البورصة المركزية'),
                                        ),
                                        actions: [],
                                      ),
                                      body: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 200,
                                                width: 200,
                                                child: Image.asset(
                                                    'assest/Images/Logo.png'),
                                              ),
                                            ),
                                            Center(
                                              child: Image.network(
                                                  auctionsfile[i].filePath),
                                            ),
                                          ],
                                        ),
                                      ),
                                      backgroundColor: Color(0xff6e7d91),
                                    );
                                  });
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
                            DateFormat.yMd().format(
                                DateTime.parse(auctionsfile[i].createdAt)),
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
        ),
      ),
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
      backgroundColor: Color(0xff6e7d91),
      appBar: userPermissions.contains('Chat_Permission')
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
              title: Container(
                height: 50,
                child: Center(
                  child: Image.asset('assest/Images/test2.png'),
                ),
              ),
              backgroundColor: Color(navbar.hashCode),
            ),
      body: BlocListener<AuctionBloc, AuctionState>(
        listener: (context, state) {
          if (state is GetAuctionLoading) {
            print(state);
          } else if (state is GetAuctionLoaded) {
            print(state);
            auctionsfile = state.auctions.reversed.toList();

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
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: isloading
              ? Container(child: Center(child: CircularProgressIndicator()))
              : Card(
                  color: Color(0xff7d8a99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: new BorderSide(color: Colors.white),
                  ),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            child: dataTable(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
