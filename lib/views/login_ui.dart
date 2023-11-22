// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_diaryfood_app/models/member.dart';
import 'package:my_diaryfood_app/services/call_api.dart';
import 'package:my_diaryfood_app/views/home_ui.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  //สร้าง Controller เพื่อใช้กับ TextField
  TextEditingController memUsernameCtrl = TextEditingController(text: '');
  TextEditingController memPasswordCtrl = TextEditingController(text: '');

  //เมธอดแสดงคำเตื่อน
  showWarningDialog(context, msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'คำเตือน',
            style: GoogleFonts.kanit(),
          ),
        ),
        content: Text(
          msg,
          style: GoogleFonts.kanit(),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ตกลง',
                  style: GoogleFonts.kanit(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Member? member;

  //เมธอดเรียกใช้ callAPIChecklogin เพื่อตรวจสอบ ชื่อผู้ใช้ รหัสผ่าน
  checklogin() async {
    member = await callApi.callAPIChecklogin(member!);
    return member;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Dialy Food App',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset(
                'assets/images/banner.jpg',
                height: MediaQuery.of(context).size.width * 0.45,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                'Dialy Food App',
                style: GoogleFonts.kanit(
                  fontSize: MediaQuery.of(context).size.height * 0.035,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'เข้าใช้งานระบบ',
                style: GoogleFonts.kanit(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ชื่อผู้ใช้ :',
                    style: GoogleFonts.kanit(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: TextField(
                  controller: memUsernameCtrl,
                  decoration: InputDecoration(
                    hintText: 'ป้อนชื่อผู้ใช้',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'รหัสผ่าน :',
                    style: GoogleFonts.kanit(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: TextField(
                  controller: memPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'ป้อนรหัสผ่าน',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.03,
                  bottom: MediaQuery.of(context).size.height * 0.1,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    //Validate UI
                    if (memUsernameCtrl.text.trim().length <= 0) {
                      showWarningDialog(context, "ป้อนชื่อผู้ใช้ด้วย");
                    } else if (memPasswordCtrl.text.trim().length <= 0) {
                      showWarningDialog(context, "ป้อนรหัสผ่านด้วย");
                    } else {
                      //กำหนดค่า ชื่อผู้ใช้และรหัสผ่านให้กับ member เพื่อใช้ส่งไปกับการเรียกใช้ API
                      member = Member(
                        memUsername: memUsernameCtrl.text.trim(),
                        memPassword: memPasswordCtrl.text.trim(),
                      );

                      //เรียกใช้ checklogin() เพื่อตรวจสอบ username, password
                      checklogin().then((value) => {
                            if (value.message == '0')
                              {
                                showWarningDialog(
                                    context, "ชื่อผู้ใช้ รหัสผ่าน ไม่ถูกต้อง"),
                              }
                            else
                              {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeUI(),
                                  ),
                                ),
                              }
                          });
                    }
                  },
                  child: Text(
                    'เข้าใช้งานระบบ',
                    style: GoogleFonts.kanit(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.07,
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
