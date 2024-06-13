import 'package:arviya/MonitorProduk.dart';
import 'package:arviya/TrackPenjualan.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'MySQL.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final unfocusNode = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String retensi = "Minggu ini";
  List<Map<String, dynamic>> jumlah_penjualan = [],
      jumlah_produk_terjual = [],
      history_penjualan = [];
  List<Color> chart_color = [
    Colors.blue[200]!,
    Colors.green[200]!,
    Colors.orange[200]!,
    Colors.purple[200]!,
    Colors.yellow[200]!,
    Colors.red[200]!,
    Colors.teal[200]!,
    Colors.pink[200]!,
    Colors.indigo[200]!,
    Colors.amber[200]!,
    Colors.lightBlue[200]!,
    Colors.lightGreen[200]!,
    Colors.deepOrange[200]!,
    Colors.deepPurple[200]!,
    Colors.lime[200]!,
    Colors.cyan[200]!,
    Colors.brown[200]!,
    Colors.grey[400]!,
    Colors.blue[300]!,
    Colors.green[300]!,
    Colors.orange[300]!,
    Colors.purple[300]!,
    Colors.yellow[300]!,
    Colors.red[300]!,
    Colors.teal[300]!,
    Colors.pink[300]!,
    Colors.indigo[300]!,
    Colors.amber[300]!,
    Colors.lightBlue[300]!,
    Colors.lightGreen[300]!,
    Colors.deepOrange[300]!,
    Colors.deepPurple[300]!,
    Colors.lime[300]!,
    Colors.cyan[300]!,
    Colors.brown[300]!,
    Colors.grey[500]!,
    Colors.blue[400]!,
    Colors.green[400]!,
    Colors.orange[400]!,
    Colors.purple[400]!,
  ];

  @override
  void initState() {
    super.initState();
    ambil_data("Minggu ini");
  }

  @override
  void dispose() {
    unfocusNode.dispose();

    super.dispose();
  }

  void ambil_data(String Time) async {
    MySQL mysql = MySQL();
    String Query = "";
    retensi = Time;

    // Pengambilan Data untuk Grafik Batang
    if (retensi == "Hari ini") {
      Query =
          "SELECT DATE(Time) AS Day, COUNT(*) AS Sold FROM sales WHERE Time >= CURDATE() - INTERVAL 0 DAY GROUP BY Day ORDER BY Day DESC;";
    } else if (retensi == "Minggu ini") {
      Query =
          "SELECT DATE(Time) AS Day, COUNT(*) AS Sold FROM sales WHERE Time >= CURDATE() - INTERVAL 7 DAY GROUP BY Day ORDER BY Day DESC;";
    } else if (retensi == "Bulan ini") {
      Query =
          "SELECT DATE(Time) AS Day, COUNT(*) AS Sold FROM sales WHERE Time >= CURDATE() - INTERVAL 30 DAY GROUP BY Day ORDER BY Day DESC;";
    } else {
      Query =
          "SELECT DATE(Time) AS Day, COUNT(*) AS Sold FROM sales GROUP BY Day ORDER BY Day DESC;";
    }
    List<Map<String, dynamic>> result1 = await mysql.readDatabase(Query);

    // Pengambilan Data untuk Grafik Lingkaran

    if (retensi == "Hari ini") {
      Query =
          "SELECT ID AS ids, (SELECT Nama FROM product WHERE ID = ids LIMIT 1) AS Nama, SUM(Kuantitas) AS Quantity FROM sales WHERE Time >= CURDATE() - INTERVAL 0 DAY GROUP BY ids;";
    } else if (retensi == "Minggu ini") {
      Query =
          "SELECT ID AS ids, (SELECT Nama FROM product WHERE ID = ids LIMIT 1) AS Nama, SUM(Kuantitas) AS Quantity FROM sales WHERE Time >= CURDATE() - INTERVAL 7 DAY GROUP BY ids;";
    } else if (retensi == "Bulan ini") {
      Query =
          "SELECT ID AS ids, (SELECT Nama FROM product WHERE ID = ids LIMIT 1) AS Nama, SUM(Kuantitas) AS Quantity FROM sales WHERE Time >= CURDATE() - INTERVAL 30 DAY GROUP BY ids;";
    } else {
      Query =
          "SELECT ID AS ids, (SELECT Nama FROM product WHERE ID = ids LIMIT 1) AS Nama, SUM(Kuantitas) AS Quantity FROM sales GROUP BY ids;";
    }

    List<Map<String, dynamic>> result2 = await mysql.readDatabase(Query);

    // Pengambilan Data untuk Table Pembelian

    if (retensi == "Hari ini") {
      Query =
          "SELECT s.ID AS ids, p.Nama, s.Kuantitas AS Quantity, p.Harga * s.Kuantitas AS Price FROM sales s JOIN product p ON s.ID = p.ID WHERE s.Time >= CURDATE() - INTERVAL 0 DAY GROUP BY s.ID;";
    } else if (retensi == "Minggu ini") {
      Query =
          "SELECT s.ID AS ids, p.Nama, s.Kuantitas AS Quantity, p.Harga * s.Kuantitas AS Price FROM sales s JOIN product p ON s.ID = p.ID WHERE s.Time >= CURDATE() - INTERVAL 7 DAY GROUP BY s.ID;";
    } else if (retensi == "Bulan ini") {
      Query =
          "SELECT s.ID AS ids, p.Nama, s.Kuantitas AS Quantity, p.Harga * s.Kuantitas AS Price FROM sales s JOIN product p ON s.ID = p.ID WHERE s.Time >= CURDATE() - INTERVAL 30 DAY GROUP BY s.ID;";
    } else {
      Query =
          "SELECT s.ID AS ids, p.Nama, s.Kuantitas AS Quantity, p.Harga * s.Kuantitas AS Price FROM sales s JOIN product p ON s.ID = p.ID GROUP BY s.ID;";
    }

    List<Map<String, dynamic>> result3 = await mysql.readDatabase(Query);

    setState(() {
      jumlah_penjualan = result1;
      jumlah_produk_terjual = result2;
      history_penjualan = result3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 500) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TrackPenjualanWidget(),
            ),
          );
        } else if (details.primaryVelocity! < -500) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MonitorStockWidget(),
            ),
          );
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF1F4F8),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 193, 218),
          automaticallyImplyLeading: false,
          title: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'History Penjualan',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 22,
                letterSpacing: 0,
              ),
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 25, 15, 15),
                    child: DropdownMenu(
                      width: 200,
                      hintText: "Rentang waktu",
                      enableSearch: false,
                      onSelected: (value) async {
                        ambil_data(value);
                      },
                      dropdownMenuEntries: <DropdownMenuEntry>[
                        DropdownMenuEntry(value: "Hari ini", label: "Hari ini"),
                        DropdownMenuEntry(
                            value: "Minggu ini", label: "Minggu ini"),
                        DropdownMenuEntry(
                            value: "Bulan ini", label: "Bulan ini"),
                        DropdownMenuEntry(
                            value: "Seluruhnya", label: "Seluruhnya"),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 10),
                    child: Text(
                      'Data Jumlah Penjualan',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 45),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFe0e3e7),
                        width: 2,
                      ),
                    ),
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(
                          border: const Border(
                            top: BorderSide.none,
                            right: BorderSide.none,
                            left: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                          ),
                        ),
                        groupsSpace: 10,
                        barGroups: [
                          for (int i = 0; i < jumlah_penjualan.length; i++)
                            BarChartGroupData(
                              x: int.parse(jumlah_penjualan[i]['Day']
                                  .toString()
                                  .split('-')[2]),
                              barRods: [
                                BarChartRodData(
                                  toY: double.parse(
                                      jumlah_penjualan[i]['Sold'].toString()),
                                  color: chart_color[i],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 10),
                    child: Text(
                      'Presentase Produk Terjual',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFe0e3e7),
                        width: 2,
                      ),
                    ),
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: [
                          for (int i = 0; i < jumlah_produk_terjual.length; i++)
                            PieChartSectionData(
                              color: chart_color[i],
                              value: double.parse(jumlah_produk_terjual[i]
                                      ['Quantity']
                                  .toString()),
                              radius: 60,
                              titleStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (int i = 0; i < jumlah_produk_terjual.length; i++)
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: chart_color[i],
                                ),
                                SizedBox(width: 8),
                                Text(jumlah_produk_terjual[i]['Nama']
                                    .toString()),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(25, 45, 15, 30),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    constraints: BoxConstraints(
                      maxHeight: 700,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Table(
                            border: TableBorder.all(color: Colors.white30),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            columnWidths: {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(2),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 90, 158, 190),
                                ),
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Nama'),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Jumlah'),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Harga'),
                                    ),
                                  ),
                                ],
                              ),
                              for (int i = 0; i < history_penjualan.length; i++)
                                TableRow(
                                  children: [
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(history_penjualan[i]['Nama']
                                            .toString()),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(history_penjualan[i]
                                                ['Quantity']
                                            .toString()),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Rp'),
                                            Text(history_penjualan[i]['Price']
                                                .toString())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
