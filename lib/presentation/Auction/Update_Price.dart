import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Home/Central_Borssa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePrice extends StatefulWidget {
  final int cityid;
  final int id;
  final double buy;
  final double sell;
  final String buystate;
  final String sellstate;
  final int close;
  final String type;
  UpdatePrice({
    Key? key,
    required this.cityid,
    required this.id,
    required this.buy,
    required this.sell,
    required this.buystate,
    required this.sellstate,
    required this.close,
    required this.type,
  }) : super(key: key);
  UpdatePricePage createState() => UpdatePricePage();
}

class UpdatePricePage extends State<UpdatePrice> {
  late String buyValue;
  late String sellValue;
  late CurrencyBloc currencybloc;
  late String buyState;
  late String sellState;
  late bool lastupdate = false;
  late bool closeCurrency = widget.close == 1 ? true : false;
  late int closeCurrencyvalue = widget.close;
  TextEditingController buyTextEdit = TextEditingController(text: "");
  TextEditingController sellTextEdit = TextEditingController(text: "");
  Future storeBuyandSellValue(String buy, String sell) async {
    setState(() {
      buyTextEdit.text = buy;
      sellTextEdit.text = sell;
    });
  }

  @override
  void initState() {
    currencybloc = BlocProvider.of<CurrencyBloc>(context);
    storeBuyandSellValue(widget.buy.toString(), widget.sell.toString());
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
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return CentralBorssa();
              }));
            }
            if (state is UpdateBorssaError) {
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
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return CentralBorssa();
              }));
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
                    children: [
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
                                    controller: buyTextEdit,
                                    // maxLength: 4,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.black),
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء إدخال قيمة العرض الجديدة';
                                      }
                                      return null;
                                    },
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
                                  )))),
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
                                    keyboardType: TextInputType.number,
                                    // maxLength: 4,
                                    controller: sellTextEdit,
                                    style: TextStyle(color: Colors.black),
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء إدخال قيمة الطلب الجديدة';
                                      }
                                      return null;
                                    },
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
                                  )))),
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
                                  cityid: widget.cityid,
                                  buy: widget.buy,
                                  sell: widget.sell,
                                  sellstatus: widget.buystate,
                                  buystatus: widget.sellstate,
                                  type: widget.type,
                                  close: widget.close));
                            }
                            if (widget.buy != 0) {
                              if (widget.buy > double.parse(buyTextEdit.text)) {
                                buyState = "down";
                                print('1');
                              } else if (widget.buy ==
                                  double.parse(buyTextEdit.text)) {
                                buyState = widget.buystate;
                                print('2');
                              } else if (widget.buy <
                                  double.parse(buyTextEdit.text)) {
                                buyState = "up";
                                print('3');
                              }
                              if (widget.sell >
                                  double.parse(sellTextEdit.text)) {
                                sellState = "down";
                                print('4');
                              } else if (widget.sell ==
                                  double.parse(sellTextEdit.text)) {
                                sellState = widget.buystate;
                                print('5');
                              } else if (widget.sell <
                                  double.parse(sellTextEdit.text)) {
                                sellState = "up";
                                print('6');
                              }
                              currencybloc.add(UpdatePriceEvent(
                                  id: widget.id,
                                  buy: double.parse(buyTextEdit.text),
                                  sell: double.parse(sellTextEdit.text),
                                  buystate: buyState,
                                  sellstate: sellState,
                                  type: widget.type,
                                  close: closeCurrencyvalue));
                              print(closeCurrencyvalue);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(navbar.hashCode)),
                          child: Text("تعديل الأسعار"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
              // ),
            ),
          ),
        ));
  }
}
