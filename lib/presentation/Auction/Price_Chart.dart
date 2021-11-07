import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
  var newtimeFormat = DateFormat("hh:mm");
  TooltipBehavior _tooltipBehavior = TooltipBehavior();

  late String dropdownvalue = itemsofchart.first.name;
  late int valueofselect;
  late ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior();
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
      if (isSelectd) {
        datachange.clear();
        print(dropdownvalue);
        bloc.add(ChartEvent(
            cityid: widget.cityid, fromdate: dropdownvalue, type: widget.type));
      }
      if (!isSelectd) {
        datachange.clear();
        bloc.add(ChartEvent(
            cityid: widget.cityid, fromdate: 'منذ ساعة', type: widget.type));
        setState(() {
          isSelectd = true;
        });
      }
    } else if (widget.type == "transfer") {
      if (isSelectd) {
        datachange.clear();
        print(dropdownvalue);
        bloc.add(ChartEvent(
            cityid: widget.cityid, fromdate: dropdownvalue, type: widget.type));
      }
      if (!isSelectd) {
        datachange.clear();
        bloc.add(ChartEvent(
            cityid: widget.cityid, fromdate: 'منذ ساعة', type: widget.type));
        setState(() {
          isSelectd = true;
        });
      }
    }
  }

  @override
  void initState() {
    // _tooltipBehavior = TooltipBehavior(
    //     enable: true,
    //     header: "التفاصيل",
    //     builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
    //         int seriesIndex) {
    //       return Container(
    //           height: 50,
    //           width: 100,
    //           decoration:
    //               const BoxDecoration(color: Color.fromRGBO(66, 244, 164, 1)),
    //           child: Row(
    //             children: <Widget>[
    //               Container(
    //                   width: 50, child: Text(series[seriesIndex].toString())),
    //             ],
    //           ));
    //     });

    _zoomPanBehavior = ZoomPanBehavior(
        enableDoubleTapZooming: true,
        enablePinching: true,
        // zoomMode: ZoomMode.xy,
        selectionRectColor: Colors.red,
        // Enables the selection zooming
        enablePanning: true,
        enableMouseWheelZooming: true);

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
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(opposedPosition: true),
                    title: ChartTitle(text: widget.title),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      header: "التفاصيل",
                    ),
                    series: <LineSeries<DataChanges, String>>[
                      LineSeries<DataChanges, String>(
                        dataSource: datachange,
                        xValueMapper: (DataChanges sales, _) => sales.updatedAt,
                        yValueMapper: (DataChanges sales, _) => sales.buy,
                        markerSettings: MarkerSettings(
                            isVisible: true, height: 4, width: 4),
                      )
                    ],
                    zoomPanBehavior: _zoomPanBehavior,
                  )
                  // child: SfCartesianChart(
                  //   trackballBehavior: _trackballBehavior,
                  //   series: <CartesianSeries>[
                  //     AreaSeries<DataChanges, DateTime>(
                  //         dataSource: datachange,
                  //         xValueMapper: (DataChanges data, _) =>
                  //             DateTime.parse(data.updatedAt),
                  //         yValueMapper: (DataChanges data, _) => data.buy,
                  //         dataLabelMapper: (DataChanges data, _) =>
                  //             data.updatedAt,
                  //         enableTooltip: true),

                  //   ],
                  //   zoomPanBehavior: _zoomPanBehavior,
                  //   primaryXAxis: DateTimeAxis(),
                  // )
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
