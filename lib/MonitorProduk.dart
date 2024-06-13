import 'dart:async';
import 'dart:math';

import 'package:arviya/HomePage.dart';
import 'package:arviya/TrackPenjualan.dart';
import 'package:arviya/UpdateProduk.dart';
import 'package:flutter/material.dart';

import 'MySQL.dart';

class MonitorStockWidget extends StatefulWidget {
  const MonitorStockWidget({super.key});

  @override
  State<MonitorStockWidget> createState() => _MonitorStockWidgetState();
}

class _MonitorStockWidgetState extends State<MonitorStockWidget> {
  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  Timer? search_delay;
  List<Map<String, dynamic>> Produk = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    textController ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
    ambil_produk();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    super.dispose();
  }

  void ambil_produk() async {
    MySQL mysql = MySQL();
    List<Map<String, dynamic>> result =
        await mysql.readDatabase("SELECT * FROM product");
    setState(() {
      Produk = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 500) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePageWidget(),
            ),
          );
        } else if (details.primaryVelocity! < -500) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TrackPenjualanWidget(),
            ),
          );
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFf1f4f8),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 193, 218),
          automaticallyImplyLeading: false,
          title: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'Monitor Stock',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.white,
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            child: TextFormField(
                              controller: textController,
                              focusNode: textFieldFocusNode,
                              autofocus: false,
                              obscureText: false,
                              onChanged: (value) {
                                if (search_delay?.isActive ?? false)
                                  search_delay!.cancel();
                                search_delay = Timer(
                                    const Duration(milliseconds: 2500), () {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Nama Produk',
                                labelStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF57636C),
                                  letterSpacing: 0,
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  color: Color(0xFF57636C),
                                  letterSpacing: 0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 90, 158, 190),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 90, 158, 190),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    10, 5, 10, 5),
                              ),
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Color(0xFF14181B),
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreateProductWidget(Product_No: "0"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 90, 158, 190),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: Text(
                          'Terbaru',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 100,
                  decoration: BoxDecoration(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        for (int i = 0; i < Produk.length; i++)
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                            child: GestureDetector(
                              onTap: () async {
                                var newData = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateProductWidget(
                                        Product_No: "${Produk[i]['ID']}"),
                                  ),
                                );
                                ambil_produk();
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE0E3E7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(0),
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(0),
                                      ),
                                      child: Image.network(
                                        "${Produk[i]['Gambar']}?v=${Random().nextInt(1000)}",
                                        width: 65,
                                        height: 65,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15, 0, 0, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment:
                                                  AlignmentDirectional(-1, -1),
                                              child: Text(
                                                Produk[i]['Nama'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Color(0xFF14181B),
                                                  fontSize: 16,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 15, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1, -1),
                                                        child: Text(
                                                          'Kuantitas ',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Color(
                                                                0xFF14181B),
                                                            fontSize: 14,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1, -1),
                                                        child: Text(
                                                          'Harga',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Color(
                                                                0xFF14181B),
                                                            fontSize: 14,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 15, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1, -1),
                                                        child: Text(
                                                          ': ${Produk[i]['Kuantitas']}',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Color(
                                                                0xFF14181B),
                                                            fontSize: 14,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                -1, -1),
                                                        child: Text(
                                                          ': ${Produk[i]['Harga']}',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            color: Color(
                                                                0xFF14181B),
                                                            fontSize: 14,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
