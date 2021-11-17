import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:central_borssa/data/model/GlobalAuction.dart';

class GlobalTable extends StatefulWidget {
  final Rates? r;
  final int? product;
  const GlobalTable({
    Key? key,
    required this.r,
    required this.product,
  }) : super(key: key);

  GlobalTablePage createState() => GlobalTablePage();
}

class GlobalTablePage extends State<GlobalTable> {
  late int product;
  late Rates r;
  @override
  void initState() {
    r = widget.r!;
    product = widget.product!;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 200,
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 0),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          'المدينة',
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          r.eUR.rate,
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
                          (product * double.parse((r.eUR.rate))).toString(),
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
                          r.cNY.rate,
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
                          (product * double.parse((r.cNY.rate))).toString(),
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
                          r.aED.rate,
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
                          (product * double.parse((r.aED.rate))).toString(),
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
                          r.cAD.rate,
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
                          (product * double.parse((r.cAD.rate))).toString(),
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
                          r.qAR.rate,
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
                          (product * double.parse((r.qAR.rate))).toString(),
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
                          r.sAR.rate,
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
                          (product * double.parse((r.sAR.rate))).toString(),
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
                          r.tRY.rate,
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
                          (product * double.parse((r.tRY.rate))).toString(),
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
                          r.gBP.rate,
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
                          (product * double.parse((r.gBP.rate))).toString(),
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
                          r.jPY.rate,
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
                          (product * double.parse((r.jPY.rate))).toString(),
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
                          r.sEK.rate,
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
                          (product * double.parse((r.sEK.rate))).toString(),
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
                          r.nOK.rate,
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
                          (product * double.parse((r.nOK.rate))).toString(),
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
                          r.dKK.rate,
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
                          (product * double.parse((r.dKK.rate))).toString(),
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
                          r.aZN.rate,
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
                          (product * double.parse((r.aZN.rate))).toString(),
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
                          r.lBP.rate,
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
                          (product * double.parse((r.lBP.rate))).toString(),
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
                          r.eGP.rate,
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
                          (product * double.parse((r.eGP.rate))).toString(),
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
                          r.bHD.rate,
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
                          (product * double.parse((r.bHD.rate))).toString(),
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
                          r.kWD.rate,
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
                          (product * double.parse((r.kWD.rate))).toString(),
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
                              FlagsCode.SY,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'ليرة سورية',
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
                          r.sYP.rate,
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
                          (product * double.parse((r.sYP.rate))).toString(),
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
                              FlagsCode.IR,
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                        Text(
                          'تومان إيراني',
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
                          r.iRR.rate,
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
                          (product * double.parse((r.iRR.rate))).toString(),
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
}
