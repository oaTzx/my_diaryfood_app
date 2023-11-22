// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings, unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:my_diaryfood_app/models/diaryfood.dart';
import 'package:my_diaryfood_app/services/call_api.dart';
import 'package:my_diaryfood_app/views/add_diaryfood_ui.dart';
import 'package:my_diaryfood_app/views/login_ui.dart';
import 'package:my_diaryfood_app/views/modify_diaryfood_ui.dart';

import '../utils/env.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  // สร้างตัวแปรเก็บข้อมูลที่ได้จากการเรียกใช้ API
  Future<List<Diaryfood>>? diaryfoodDataList;

  // สร้างเมธอดที่เรียกใช้เมธอดที่เรียกใช้ API
  getAllDiaryfood() {
    setState(() {
      diaryfoodDataList = callApi.callAPIGetAllDiaryfood();
    });
  }

  // อะไรก็ตามที่อยู่ในเมธอด initState จะทำงาน
  @override
  void initState() {
    getAllDiaryfood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'My Diary Food',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginUI(),
                ),
              );
            },
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            //เปิดไปหน้า AddDiaryfoodUI แบบย้อนกลับได้
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddDiaryfoodUI(),
              ),
            ).then((value) => getAllDiaryfood());
          },
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.green),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Column(
          children: [
            //แสดงรูปที่เตรียมไว้
            Image.asset(
              'assets/images/banner.jpg',
              fit: BoxFit.cover,
            ),
            //แสดงข้อมูลรายการกินที่ get มาจาก data ที่ Sever ในรูป ListView
            Expanded(
              child: FutureBuilder(
                future: callApi.callAPIGetAllDiaryfood(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    // เอาข้อมูลใส่ ListView โดยการตรวจสอบ message
                    if (snapshot.data[0].message == '0') {
                      return Center(
                        child: Text(
                          'ยังไม่มีข้อมูล',
                          style: GoogleFonts.kanit(),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        // นับจำนวนข้อมูลที่จะแสดงใน ListView
                        itemCount: snapshot.data.length,
                        // Layout ของ ListView ที่เราจะสร้าง
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  //เอาข้อมูลที่ได้มาจาก Server เก็บในตัวแปร
                                  Diaryfood diaryfood = Diaryfood(
                                    foodId: snapshot.data[index].foodId,
                                    foodShopname:
                                        snapshot.data[index].foodShopname,
                                    foodImage: snapshot.data[index].foodImage,
                                    foodPay: snapshot.data[index].foodPay,
                                    foodMeal: snapshot.data[index].foodMeal,
                                    foodDate: snapshot.data[index].foodDate,
                                    foodProvince:
                                        snapshot.data[index].foodProvince,
                                  );
                                  //เปิดหน้า modify พร้อมกับส่งข้อมูลในตัวแปรไปแสดงด้วย
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ModifyDiaryfoodUI(
                                        diaryfood: diaryfood,
                                      ),
                                    ),
                                  ).then((value) => getAllDiaryfood());
                                },
                                leading: Image.network(
                                  Env.domainURL +
                                      '/diaryfoodapi/images/' +
                                      snapshot.data[index].foodImage,
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                                title: Text(
                                  snapshot.data[index].foodShopname,
                                ),
                                subtitle: Text(
                                  snapshot.data[index].foodDate,
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'มีข้อผิดพลาด',
                        style: GoogleFonts.kanit(),
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
