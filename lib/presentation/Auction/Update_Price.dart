import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:central_borssa/presentation/Main/HomeOfApp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePrice extends StatefulWidget {
  final CurrencyPrice? currencyPrice;
  UpdatePrice({
    Key? key,
    required this.currencyPrice,
  }) : super(key: key);
  UpdatePricePage createState() => UpdatePricePage();
}

class UpdatePricePage extends State<UpdatePrice> {
  late String buyValue;
  late String sellValue;
  late String? buy;
  late String? sell;
  late CurrencyBloc currencybloc;
  late String buyState;
  late String sellState;
  late bool lastupdate = false;
  late bool closeCurrency = widget.currencyPrice!.close == 1 ? true : false;
  late int? closeCurrencyvalue = widget.currencyPrice!.close;
  TextEditingController buyTextEdit = TextEditingController();
  TextEditingController sellTextEdit = TextEditingController();
  shared() {
    if (widget.currencyPrice != null) {
      buy = widget.currencyPrice!.buy.toString();
      sell = widget.currencyPrice!.sell.toString();
      setState(() {
        buyTextEdit.text = buy!;
        sellTextEdit.text = sell!;
      });
    }
  }

  @override
  void initState() {
    currencybloc = BlocProvider.of<CurrencyBloc>(context);
    print('--------------');
    print(widget.currencyPrice!.id);
    shared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(
          child: Text('تحديث الأسعار'),
        ),
        backgroundColor: Color(navbar.hashCode),
      ),
      body: BlocListener<CurrencyBloc, CurrencyState>(
          listener: (context, state) {
            if (state is UpdateBorssaSuccess) {
              print(state);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم التعديل بنجاح'),
                  action: SnackBarAction(
                    label: 'تنبيه',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            }
            if (state is UpdateBorssaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('خطأ في المعلومات'),
                  action: SnackBarAction(
                    label: 'تنبيه',
                    onPressed: () {},
                  ),
                ),
              );
            } else if (state is UpdateBorssaLoading) {
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return Center(child: CircularProgressIndicator());
              //     });
            }
            if (state is UndoUpdateLoaded) {
              print(state);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم حذف التعديل بنجاح'),
                  action: SnackBarAction(
                    label: 'تنبيه',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            }
            if (state is UndoUpdateError) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: AlertDialog(
                        title: Text(
                          'خطأ في المعلومات',
                          textAlign: TextAlign.right,
                        ),
                        content: Text('الرجاء التأكد من صحة المعلومات المدخلة'),
                      ),
                    );
                  });
            } else if (state is UndoUpdateLoading) {
              // showDialog(
              //     context: context,
              //     builder: (context) {
              //       return Center(child: CircularProgressIndicator());
              //     });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(
                      top: 40.0, left: 10.0, right: 10.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                              top: 25.0, left: 15.0, right: 15.0, bottom: 20.0),
                          child: new Theme(
                              data: new ThemeData(
                                  primaryColor: Colors.red,
                                  primaryColorDark: Colors.red,
                                  focusColor: Colors.red),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  cursorColor: Colors.black,
                                  // maxLength: 4,
                                  controller: buyTextEdit,
                                  style: TextStyle(color: Colors.black),
                                  onSaved: (String? value) {
                                    buyValue = value ?? "";
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 0, 40, 35),
                                    labelText: 'العرض',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: Colors.red,
                                    border: OutlineInputBorder(),
                                    enabledBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Color(navbar.hashCode))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3,
                                          color: Color(navbar.hashCode)),
                                    ),
                                  ),
                                ),
                              ))),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 25.0, left: 15.0, right: 15.0, bottom: 20.0),
                          child: new Theme(
                              data: new ThemeData(
                                  primaryColor: Colors.red,
                                  primaryColorDark: Colors.red,
                                  focusColor: Colors.red),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  textAlign: TextAlign.right,
                                  cursorColor: Colors.black,
                                  // maxLength: 4,
                                  controller: sellTextEdit,
                                  style: TextStyle(color: Colors.black),
                                  onSaved: (String? value) {
                                    sellValue = value ?? "";
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 0, 40, 35),
                                    labelText: 'الطلب',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: Colors.red,
                                    border: OutlineInputBorder(),
                                    enabledBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Color(navbar.hashCode))),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 3,
                                          color: Color(navbar.hashCode)),
                                    ),
                                  ),
                                ),
                              ))),
                      Container(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: CheckboxListTile(
                            title: Text(
                              "إغلاق السوق",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            value: closeCurrency,
                            onChanged: (newValue) {
                              setState(() {
                                closeCurrency = newValue!;
                                closeCurrencyvalue = newValue == true ? 1 : 0;
                              });
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          ),
                        ),
                      ),
                      Container(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: CheckboxListTile(
                            title: Text(
                              "التراجع عن آخر تعديل",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            value: lastupdate,
                            onChanged: (newValue) {
                              setState(() {
                                lastupdate = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (lastupdate) {
                              currencybloc.add(UndoEvent(
                                  cityid: widget.currencyPrice!.cityId,
                                  buy: widget.currencyPrice!.buy,
                                  sell: widget.currencyPrice!.sell,
                                  sellstatus: widget.currencyPrice!.buyStatus,
                                  buystatus: widget.currencyPrice!.sellStatus,
                                  type: "",
                                  close: widget.currencyPrice!.close));
                            }
                            if (widget.currencyPrice!.buy != 0) {
                              if (widget.currencyPrice!.buy >
                                  double.parse(buyTextEdit.text)) {
                                buyState = "down";
                                print('1');
                              } else if (widget.currencyPrice!.buy ==
                                  double.parse(buyTextEdit.text)) {
                                buyState = widget.currencyPrice!.buyStatus;
                                print('2');
                              } else if (widget.currencyPrice!.buy <
                                  double.parse(buyTextEdit.text)) {
                                buyState = "up";
                                print('3');
                              }
                              if (widget.currencyPrice!.sell >
                                  double.parse(sellTextEdit.text)) {
                                sellState = "down";
                                print('4');
                              } else if (widget.currencyPrice!.sell ==
                                  double.parse(sellTextEdit.text)) {
                                sellState = widget.currencyPrice!.buyStatus;
                                print('5');
                              } else if (widget.currencyPrice!.sell <
                                  double.parse(sellTextEdit.text)) {
                                sellState = "up";
                                print('6');
                              }

                              currencybloc.add(UpdatePriceEvent(
                                  id: widget.currencyPrice!.id,
                                  buy: double.parse(buyTextEdit.text),
                                  sell: double.parse(sellTextEdit.text),
                                  buystate: buyState,
                                  sellstate: sellState,
                                  type: "currency",
                                  close: closeCurrencyvalue));
                              print(closeCurrencyvalue);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(navbar.hashCode)),
                          child: Text("تعديل الأسعار"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return HomeOfApp();
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(navbar.hashCode)),
                          child: Text("رجوع"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
              // ),
            ),
          )),
    );
  }
}
