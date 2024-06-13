import 'dart:io';
import 'dart:math';

import 'package:arviya/MonitorProduk.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'MySQL.dart';

class CreateProductWidget extends StatefulWidget {
  final String Product_No;
  const CreateProductWidget({super.key, required this.Product_No});

  @override
  State<CreateProductWidget> createState() => _CreateProductWidgetState();
}

class _CreateProductWidgetState extends State<CreateProductWidget> {
  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  List<Map<String, dynamic>> Produk = [];
  String Gambar_Produk = "", link_gambar = "";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    textController1 ??= TextEditingController();
    textFieldFocusNode1 ??= FocusNode();

    textController2 ??= TextEditingController();
    textFieldFocusNode2 ??= FocusNode();

    textController3 ??= TextEditingController();
    textFieldFocusNode3 ??= FocusNode();

    textController4 ??= TextEditingController();
    textFieldFocusNode4 ??= FocusNode();

    if (widget.Product_No != "0") {
      ambil_produk(widget.Product_No);
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    super.dispose();
  }

  void ambil_produk(String No) async {
    MySQL mysql = MySQL();
    List<Map<String, dynamic>> result =
        await mysql.readDatabase("SELECT * FROM product WHERE ID = $No");
    setState(() {
      Produk = result;
      textController1 = TextEditingController(text: Produk[0]['Nama']);
      textController2 = TextEditingController(text: Produk[0]['Deskripsi']);
      textController3 = TextEditingController(text: Produk[0]['Kuantitas']);
      textController4 = TextEditingController(text: Produk[0]['Harga']);
      Gambar_Produk = Produk[0]['Gambar'];
    });
  }

  Future<void> pilih_gambar() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (widget.Product_No != '0' && pickedImage != null) {
      MySQL mysql = MySQL();
      link_gambar = await mysql.uploadImage(
          pickedImage.path, textController1!.text + ".png");
      setState(() {
        Gambar_Produk = 'https://ums.blue/File_Hosting/$link_gambar';
      });
      print(Gambar_Produk);
    } else if (pickedImage != null) {
      setState(() {
        Gambar_Produk = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFf1f4f8),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 193, 218),
          automaticallyImplyLeading: false,
          title: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Text(
              'Produk',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 25),
                  child: GestureDetector(
                    onTap: () {
                      pilih_gambar();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Gambar_Produk.isEmpty
                          ? Image.network(
                              'https://i.ytimg.com/vi/QggJzZdIYPI/hq720.jpg?sqp=-oaymwE2CNAFEJQDSFXyq4qpAygIARUAAIhCGAFwAcABBvABAfgB_gmAAtAFigIMCAAQARhlIGUoZTAP&rs=AOn4CLA5IBnJmEgcH-LRm_4sCEGXj4CrZQ',
                              width: MediaQuery.sizeOf(context).width,
                              height: 250,
                              fit: BoxFit.cover,
                            )
                          : Gambar_Produk.contains("ums.blue")
                              ? Image.network(
                                  "$Gambar_Produk?v=${Random().nextInt(1000)}",
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(Gambar_Produk),
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 15),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: TextFormField(
                      controller: textController1,
                      focusNode: textFieldFocusNode1,
                      autofocus: false,
                      obscureText: false,
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
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 15),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: TextFormField(
                      controller: textController2,
                      focusNode: textFieldFocusNode2,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi Produk',
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
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                      ),
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF14181B),
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 15),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: TextFormField(
                          controller: textController3,
                          focusNode: textFieldFocusNode3,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Kuantitas Produk',
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
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                          ),
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Color(0xFF14181B),
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 15),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: TextFormField(
                          controller: textController4,
                          focusNode: textFieldFocusNode4,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Harga Produk (Rp)',
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
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                          ),
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Color(0xFF14181B),
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 90, 158, 190),
                        elevation: 3,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Kembali',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    if (widget.Product_No != '0')
                      ElevatedButton(
                        onPressed: () async {
                          MySQL mysql = MySQL();
                          await mysql.executeDatabase(
                              "DELETE FROM product WHERE ID  = ${widget.Product_No}");
                          await mysql.executeDatabase(
                              "DELETE FROM sales WHERE ID  = ${widget.Product_No}");
                          await mysql.executeDatabase(
                              "UPDATE product SET No = No - 1 WHERE No > ${widget.Product_No}");
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 90, 158, 190),
                          elevation: 3,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'Hapus',
                          style: TextStyle(
                            fontFamily: 'Readex Pro',
                            color: Colors.white,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        if (textController1!.text.isNotEmpty &&
                            textController2!.text.isNotEmpty &&
                            textController3!.text.isNotEmpty &&
                            textController4!.text.isNotEmpty) {
                          if (widget.Product_No == '0') {
                            MySQL mysql = MySQL();
                            link_gambar = await mysql.uploadImage(
                                Gambar_Produk, textController1!.text + ".png");
                            print(
                                "INSERT INTO product VALUES (DEFAULT, '${textController1!.text}', ${textController3!.text}, 'https://ums.blue/File_Hosting/$link_gambar', ${textController4!.text}, '${textController2!.text}')");
                            await mysql.executeDatabase(
                                "INSERT INTO product VALUES (DEFAULT, '${textController1!.text}', ${textController3!.text}, 'https://ums.blue/File_Hosting/$link_gambar', ${textController4!.text}, '${textController2!.text}')");
                          } else {
                            MySQL mysql = MySQL();
                            await mysql.executeDatabase(
                                "UPDATE product SET Nama = '${textController1!.text}', Kuantitas = '${textController3!.text}', Gambar = '$Gambar_Produk', Harga = '${textController4!.text}', Deskripsi = '${textController2!.text}' WHERE ID = ${widget.Product_No}");
                          }
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 90, 158, 190),
                        elevation: 3,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
