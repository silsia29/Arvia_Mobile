import 'package:arviya/HomePage.dart';
import 'package:arviya/MonitorProduk.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'MySQL.dart';

class TrackPenjualanWidget extends StatefulWidget {
  const TrackPenjualanWidget({super.key});

  @override
  State<TrackPenjualanWidget> createState() => _TrackPenjualanWidgetState();
}

class _TrackPenjualanWidgetState extends State<TrackPenjualanWidget> {
  final unfocusNode = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng Lokasi = LatLng(-1.5824545477351275, 113.71842186361921);
  List<Map<String, dynamic>> Penjualan = [];

  @override
  void initState() {
    super.initState();
    ambil_data();
  }

  @override
  void dispose() {
    unfocusNode.dispose();

    super.dispose();
  }

  void ambil_data() async {
    MySQL mysql = MySQL();
    List<Map<String, dynamic>> result = await mysql.readDatabase(
        "SELECT No, ID AS ids, (SELECT Nama FROM product WHERE ID = ids) AS Nama, Kuantitas, Latitude, Longitude, Time FROM sales ORDER BY No ASC");
    setState(() {
      Penjualan = result;
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
              builder: (context) => const MonitorStockWidget(),
            ),
          );
        } else if (details.primaryVelocity! < -500) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePageWidget(),
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
              'Tracking Penjualan',
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
                padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(-1.5824545477351275, 113.71842186361921),
                      zoom: 3.5,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('Lokasi'),
                        position: Lokasi,
                      ),
                    },
                  ),
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
                        for (int i = 0; i < Penjualan.length; i++)
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Lokasi = LatLng(
                                      double.parse(Penjualan[i]['Latitude']),
                                      double.parse(Penjualan[i]['Longitude']));
                                });
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE0E3E7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15, 10, 15, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(-1, -1),
                                        child: Text(
                                          'No. ${Penjualan[i]['No']}',
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
                                      Container(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 15, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1, -1),
                                                      child: Text(
                                                        'pembelian',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Color(0xFF14181B),
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
                                                        'Tanggal',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Color(0xFF14181B),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              -1, -1),
                                                      child: Text(
                                                        ': ${Penjualan[i]['Kuantitas']} x ${Penjualan[i]['Nama']}',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Color(0xFF14181B),
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
                                                        ': ${Penjualan[i]['Time']}',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color:
                                                              Color(0xFF14181B),
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
                                        ),
                                      ),
                                    ],
                                  ),
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
