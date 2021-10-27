import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PriceChart extends StatefulWidget {
  final int cityid;
  final int fromdate;
  final int todate;
  final String title;
  final String type;
  const PriceChart({
    Key? key,
    required this.cityid,
    required this.fromdate,
    required this.todate,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PriceChartPage();
}

class PriceChartPage extends State<PriceChart> {
  late CurrencyBloc bloc;
  late List<DataChanges> datachange = [];
  // late int fromdate = widget.fromdate;
  // late int todate = widget.todate;
  var newFormat = DateFormat("yyyy-MM-dd");

  late String dropdownvalue = itemsofchart.first.name;
  late int valueofselect;
  late ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior();
  late TrackballBehavior _trackballBehavior = TrackballBehavior();
  final List<Item> itemsofchart = [
    Item(name: 'منذ ساعة', from: 'منذ ساعة'),
    Item(name: 'منذ ثلاثة ساعات', from: 'منذ ثلاثة ساعات'),
    Item(name: 'منذ سبعة ساعات', from: 'منذ سبعة ساعات'),
    Item(
      name: 'منذ يوم',
      from: 'منذ يوم',
    ),
    Item(
      name: 'منذ ثلاثة أيام',
      from: 'منذ ثلاثة أيام',
    ),
    Item(
      name: 'منذ سبعة أيام',
      from: 'منذ سبعة أيام',
    ),
    Item(name: 'منذ شهر', from: 'منذ شهر'),
  ];
  bool isSelectd = false;
  getChart() async {
    if (widget.type == "currency") {
    } else if (widget.type == "transfer") {}
    if (isSelectd) {
      datachange.clear();
      print(dropdownvalue);
      bloc.add(ChartEvent(cityid: widget.cityid, fromdate: dropdownvalue));
    }
    if (!isSelectd) {
      datachange.clear();
      bloc.add(ChartEvent(cityid: widget.cityid, fromdate: 'منذ ساعة'));
      setState(() {
        isSelectd = true;
      });
    }
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
        enableDoubleTapZooming: true,
        enablePinching: true,
        // Enables the selection zooming
        enableSelectionZooming: true);
    _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        lineColor: Colors.red,
        builder: (BuildContext context, TrackballDetails trackballDetails) {
          return Container(
              height: 75,
              width: 120,
              decoration: const BoxDecoration(color: Colors.blue),
              child: Row(
                children: <Widget>[
                  Container(
                      child: Column(
                    children: <Widget>[
                      Container(
                        height: 25,
                        alignment: Alignment.center,
                        child: Text(
                            'العرض ${trackballDetails.point!.open.toString()}'),
                      ),
                      Container(
                          height: 25,
                          child: Text(
                              'الطلب ${trackballDetails.point!.close.toString()}')),
                      Container(
                          height: 25,
                          alignment: Alignment.center,
                          child: Text(
                              'التاريخ ${newFormat.format(trackballDetails.point!.x)}')),
                    ],
                  ))
                ],
              ));
        });
    // datachange.clear();
    bloc = BlocProvider.of<CurrencyBloc>(context);
    getChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text(widget.title),
          ),
          backgroundColor: Color(navbar.hashCode),
        ),
        body: BlocListener<CurrencyBloc, CurrencyState>(
          listener: (context, state) {
            if (state is ChartBorssaLoading) {
              print(state);
            } else if (state is ChartBorssaError) {
              print('error');
            } else if (state is ChartBorssaLoaded) {
              print(state);
              datachange = state.dataChanges;
              setState(() {});
            }
          },
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(navbar.hashCode),
                              alignment: Alignment.center),
                          onPressed: () {
                            getChart();
                          },
                          child: Text(
                            "إظهار المخطط",
                            style: TextStyle(),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButton(
                          value: dropdownvalue,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: itemsofchart.map((Item items) {
                            return DropdownMenuItem(
                              value: items.name,
                              child: Text(items.name),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                              print(dropdownvalue);
                              isSelectd = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height - 250),
                child: SfCartesianChart(
                  trackballBehavior: _trackballBehavior,
                  series: <CandleSeries>[
                    CandleSeries<DataChanges, DateTime>(
                      dataSource: datachange,
                      xValueMapper: (DataChanges s, _) =>
                          DateTime.parse(s.updatedAt),
                      lowValueMapper: (DataChanges s, _) => s.sell,
                      highValueMapper: (DataChanges s, _) => s.buy,
                      openValueMapper: (DataChanges s, _) => s.sell,
                      closeValueMapper: (DataChanges s, _) => s.buy,
                    )
                  ],
                  zoomPanBehavior: _zoomPanBehavior,
                  primaryXAxis: DateTimeAxis(dateFormat: DateFormat.Md()),
                ),
              ),
            ]),
          ),
        ));
  }
}

class Item {
  late String name;
  late String from;
  Item({
    required this.name,
    required this.from,
  });
}
