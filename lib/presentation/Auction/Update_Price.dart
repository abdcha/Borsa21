import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/presentation/Home/Central_Borssa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePrice extends StatefulWidget {
  late final int id;
  late final int buy;
  late final int sell;
  UpdatePrice({
    Key? key,
    required this.id,
    required this.buy,
    required this.sell,
  }) : super(key: key);
  UpdatePricePage createState() => UpdatePricePage();
}

class UpdatePricePage extends State<UpdatePrice> {
  late String buyValue;
  late String sellValue;
  late CurrencyBloc currencybloc;
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
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(child: CircularProgressIndicator());
                  });
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
                                    maxLength: 4,
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
                                    maxLength: 4,
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
                        margin: const EdgeInsets.all(25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            currencybloc.add(UpdatePriceEvent(
                                id: widget.id,
                                buy: int.parse(buyTextEdit.text),
                                sell: int.parse(sellTextEdit.text),
                                status: "up"));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(navbar.hashCode)),
                          child: Text("تعديل الأسعار"),
                        ),
                      ),
                    ],
                  ),
                  // margin: const EdgeInsets.only(
                  //     top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                  // child: Card(
                  //   color: Colors.white,
                  //   shadowColor: Colors.black,
                  //   child: Column(
                  //     children: [

                  //     ],
                  //   ),
                  // ),
                )
              ],
              // ),
            ),
          ),
        ));
  }
}
