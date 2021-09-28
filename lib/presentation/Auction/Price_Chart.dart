import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:central_borssa/business_logic/Currency/bloc/currency_bloc.dart';
import 'package:central_borssa/constants/string.dart';
import 'package:central_borssa/data/model/Chat.dart';

class PriceChart extends StatefulWidget {
  final int cityid;
  final String fromdate;
  final String todate;
  const PriceChart({
    Key? key,
    required this.cityid,
    required this.fromdate,
    required this.todate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PriceChartPage();
}

class PriceChartPage extends State<PriceChart> {
  late CurrencyBloc bloc;
  late List<DataChanges> datachange = [];
  late String fromdate = widget.fromdate;
  late String todate = widget.todate;
  late String dropdownvalue = itemsofchart.first.name;

  final List<Item> itemsofchart = [
    Item(name: 'منذ يوم', from: 'منذ يوم', to: DateTime.now().toString()),
    Item(
        name: 'منذ ثلاثة أيام',
        from: 'منذ ثلاثة أيام',
        to: DateTime.now().toString()),
    Item(
        name: 'منذ سبعة أيام',
        from: 'منذ سبعة أيام',
        to: DateTime.now().toString()),
    Item(name: 'منذ شهر', from: 'منذ شهر', to: DateTime.now().toString()),
  ];
  bool isSelectd = false;
  getChart() async {
    if (!isSelectd) {
      bloc.add(ChartEvent(
          cityid: widget.cityid, fromdate: fromdate, todate: todate));
    }
    bloc.add(ChartEvent(
        cityid: widget.cityid, fromdate: dropdownvalue, todate: todate));
    setState(() {
      isSelectd = true;
    });
  }

  @override
  void initState() {
    datachange.clear();
    bloc = BlocProvider.of<CurrencyBloc>(context);
    getChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(
            child: Text('تغيرات سعر الصرف'),
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
                      child: DropdownButton(
                        value: dropdownvalue,
                        icon: Icon(Icons.keyboard_arrow_down),
                        items: itemsofchart.map((Item items) {
                          return DropdownMenuItem(
                              value: items.name, child: Text(items.name));
                        }).toList(),
                        onChanged: (String? newValue) {
                          print(newValue);
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height - 250),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      // title: ChartTitle(text: 'أسعار العرض'),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<DataChanges, String>>[
                        LineSeries<DataChanges, String>(
                          dataSource: datachange,
                          xValueMapper: (DataChanges buy, _) => DateFormat.Hms()
                              .format(DateTime.parse(buy.updatedAt)),
                          yValueMapper: (DataChanges buy, _) => buy.buy,
                          name: 'أسعار العرض',
                          // Enable data label
                          // dataLabelSettings: DataLabelSettings(isVisible: true)
                        )
                      ]),
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
  late String to;
  Item({
    required this.name,
    required this.from,
    required this.to,
  });
}
