// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, unused_import, unused_local_variable, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, prefer_is_empty

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diaryfood_app/models/diaryfood.dart';
import 'package:my_diaryfood_app/services/call_api.dart';

class AddDiaryfoodUI extends StatefulWidget {
  const AddDiaryfoodUI({super.key});

  @override
  State<AddDiaryfoodUI> createState() => _AddDiaryfoodUIState();
}

class _AddDiaryfoodUIState extends State<AddDiaryfoodUI> {
  //ประกาศ/สร้างตัวแปรใช้กับ TextField วันที่กิน
  TextEditingController foodDateCtrl = TextEditingController(text: '');
  TextEditingController foodshopCtrl = TextEditingController(text: '');
  TextEditingController foodPayCtrl = TextEditingController(text: '');

  // ตัวแปรใช้กับ GroupValue ของ Radio ที่อยู่กลุ่มเดียวกัน
  // และยังเป็นตัวแปรที่เก็บค่าอาหารมื้อไหนที่ผู้ใช้เลือกด้วย
  int time = 1;

  //ประกาศ/สร้างตัวแปรเพื่อเก็บข้อมูลรายการที่จะเอาไปใช้กับ DropdownButton
  List<DropdownMenuItem<String>> items = [
    'กรุงเทพมหานคร',
    'กระบี่',
    'กาญจนบุรี',
    'กาฬสินธุ์' 'กำแพงเพชร',
    'ขอนแก่น',
    'จันทบุรี',
    'ฉะเชิงเทรา',
    'ชลบุรี',
    'ชัยนาท',
    'ชัยภูมิ',
    'ชุมพร',
    'เชียงราย',
    'เชียงใหม่',
    'ตรัง',
    'ตราด',
    'ตาก',
    'นครนายก',
    'นครปฐม',
    'นครพนม',
    'นครราชสีมา',
    'นครศรีธรรมราช',
    'นครสวรรค์',
    'นนทบุรี',
    'นราธิวาส',
    'น่าน',
    'บึงกาฬ',
    'บุรีรัมย์',
    'ปทุมธานี',
    'ประจวบคีรีขันธ์',
    'ปราจีนบุรี',
    'ปัตตานี',
    'พระนครศรีอยุธยา',
    'พะเยา',
    'พังงา',
    'พัทลุง',
    'พิจิตร',
    'พิษณุโลก',
    'เพชรบุรี',
    'เพชรบูรณ์',
    'แพร่',
    'ภูเก็ต',
    'มหาสารคาม',
    'มุกดาหาร',
    'แม่ฮ่องสอน',
    'ยโสธร',
    'ยะลา',
    'ร้อยเอ็ด',
    'ระนอง',
    'ระยอง',
    'ราชบุรี',
    'ลพบุรี',
    'ลำปาง',
    'ลำพูน',
    'เลย',
    'ศรีสะเกษ',
    'สกลนคร',
    'สงขลา',
    'สตูล',
    'สมุทรปราการ',
    'สมุทรสงคราม',
    'สมุทรสาคร',
    'สระแก้ว',
    'สระบุรี',
    'สิงห์บุรี',
    'สุโขทัย',
    'สุพรรณบุรี',
    'สุราษฎร์ธานี',
    'สุรินทร์',
    'หนองคาย',
    'หนองบัวลำภู',
    'อ่างทอง',
    'อำนาจเจริญ',
    'อุดรธานี',
    'อุตรดิตถ์',
    'อุทัยธานี',
    'อุบลราชธานี'
  ]
      .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ))
      .toList();

  //ประกาศ/สร้างตัวแปรเก็บจังหวัดที่ผู้ใฃ้เลือก
  String foodProvince = 'กรุงเทพมหานคร';

  //เมธอดแสดงปฏิทิน
  showCalender() async {
    DateTime? foodDatePicker = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      dateFormat: 'dd MMMM yyyy',
      locale: DateTimePickerLocale.th,
      looping: true,
      confirmText: 'ตกลง',
      cancelText: 'ยกเลิก',
      titleText: 'เลือกวันที่กิน',
      itemTextStyle: GoogleFonts.kanit(),
      textColor: Colors.green,
    );

    setState(() {
      foodDateCtrl.text = foodDatePicker != null
          ? convertToThaiDate(foodDatePicker)
          : foodDateCtrl.text;
    });
  }

  //เมธอดแปลงวันที่จากสากลเป็นวันที่แบบไทย
  convertToThaiDate(date) {
    String day = date.toString().substring(8, 10);
    String year = (int.parse(date.toString().substring(0, 4)) + 543).toString();
    String month = '';
    int monthTemp = int.parse(date.toString().substring(5, 7));
    switch (monthTemp) {
      case 1:
        month = 'มกราคม';
        break;
      case 2:
        month = 'กุมภาพันธ์';
        break;
      case 3:
        month = 'มีนาคม';
        break;
      case 4:
        month = 'เมษายน';
        break;
      case 5:
        month = 'พฤษภาคม';
        break;
      case 6:
        month = 'มิถุนายน';
        break;
      case 7:
        month = 'กรกฎาคม';
        break;
      case 8:
        month = 'สิงหาคม';
        break;
      case 9:
        month = 'กันยายน';
        break;
      case 10:
        month = 'ตุลาคม';
        break;
      case 11:
        month = 'พฤศจิกายน';
        break;
      default:
        month = 'ธันวาคม';
    }

    return day + ' ' + month + ' พ.ศ. ' + year;
  }

  //ตัวแปลเก็บรูปที่เลือกจาก Gallery หรือ ถ่ายจากกล้อง
  XFile? foodImageSelected;

  String? foodImageBase64 = '';

  //เมธอดที่ใช้เปิดกล้อง หรือเปิดแกลอรี่
  openGalleryAndSelectImage() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (photo == null) return;
    foodImageBase64 = base64Encode(File(photo.path).readAsBytesSync());

    setState(() {
      foodImageSelected = photo;
    });
  }

  openCameraAndSelectImage() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    if (photo == null) return;
    foodImageBase64 = base64Encode(File(photo.path).readAsBytesSync());

    setState(() {
      foodImageSelected = photo;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'เพิ่มข้อมูล My Diary Food',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 5,
                        color: Colors.green,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: foodImageSelected == null
                            ? AssetImage('assets/images/banner.jpg')
                            : FileImage(
                                File(foodImageSelected!.path),
                              ) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                openCameraAndSelectImage();
                              },
                              leading: Icon(
                                Icons.camera_alt,
                                color: Colors.red,
                              ),
                              title: Text(
                                'Open Camera...',
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 5.0,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                openGalleryAndSelectImage();
                              },
                              leading: Icon(
                                Icons.browse_gallery,
                                color: Colors.blue,
                              ),
                              title: Text(
                                'Open Gallery...',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'ร้านอาหาร',
                    style: GoogleFonts.kanit(
                        color: Colors.grey[800],
                        fontSize: MediaQuery.of(context).size.height * 0.02),
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
                  controller: foodshopCtrl,
                  decoration: InputDecoration(
                    hintText: 'ป้อนชื่อร้านอาหาร',
                    helperStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'ค่าใช้จ่าย',
                    style: GoogleFonts.kanit(
                        color: Colors.grey[800],
                        fontSize: MediaQuery.of(context).size.height * 0.02),
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
                  controller: foodPayCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'ป้อนค่าใช้จ่าย',
                    helperStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'อาหารมื้อ',
                    style: GoogleFonts.kanit(
                        color: Colors.grey[800],
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    onChanged: (int? value) {
                      setState(() {
                        time = value!;
                      });
                    },
                    value: 1,
                    groupValue: time,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'เฃ้า',
                    style: GoogleFonts.kanit(),
                  ),
                  Radio(
                    onChanged: (int? value) {
                      setState(() {
                        time = value!;
                      });
                    },
                    value: 2,
                    groupValue: time,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'กลางวัน',
                    style: GoogleFonts.kanit(),
                  ),
                  Radio(
                    onChanged: (int? value) {
                      setState(() {
                        time = value!;
                      });
                    },
                    value: 3,
                    groupValue: time,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'เย็น',
                    style: GoogleFonts.kanit(),
                  ),
                  Radio(
                    onChanged: (int? value) {
                      setState(() {
                        time = value!;
                      });
                    },
                    value: 4,
                    groupValue: time,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'ว่าง',
                    style: GoogleFonts.kanit(),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'วันที่กิน',
                    style: GoogleFonts.kanit(
                        color: Colors.grey[800],
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: foodDateCtrl,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'เลือกวันที่',
                          helperStyle: GoogleFonts.kanit(
                            color: Colors.grey[400],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showCalender();
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'จังหวัด',
                    style: GoogleFonts.kanit(
                        color: Colors.grey[800],
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                    ),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    items: items,
                    onChanged: (String? value) {
                      setState(() {
                        foodProvince = value!;
                      });
                    },
                    value: foodProvince,
                    underline: SizedBox(),
                    style: GoogleFonts.kanit(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'ตำแหน่งที่ตั้ง',
                    style: GoogleFonts.kanit(
                        color: Colors.grey[800],
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              ElevatedButton(
                onPressed: () {
                  if (foodImageSelected == null) {
                    showWarningDialog(context, "เลือกรูปด้วยครับ....");
                  } else if (foodshopCtrl.text.trim().length == 0) {
                    showWarningDialog(context, "ป้อนชื่อร้านด้วยครับ....");
                  } else if (foodshopCtrl.text.trim().length == 0) {
                    showWarningDialog(
                        context, "ป้อนค่าใช้จ่ายด้วยด้วยครับ....");
                  } else if (foodshopCtrl.text.trim().length == 0) {
                    showWarningDialog(context, "เลือกวันที่กินด้วยครับ....");
                  } else {
                    Diaryfood diaryfood = Diaryfood(
                      foodShopname: foodshopCtrl.text.trim(),
                      foodImage: foodImageBase64,
                      foodPay: foodPayCtrl.text.trim(),
                      foodMeal: time.toString(),
                      foodDate: foodDateCtrl.text.trim(),
                      foodProvince: foodProvince,
                    );
                    callApi
                        .callAPIInsertDiaryfood(diaryfood)
                        .then((value) => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ผลการทำงาน',
                                    style: GoogleFonts.kanit(),
                                  ),
                                ),
                                content: Text(
                                  'บันทึกเรียบร้อยแล้ว',
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
                            ))
                        .then((value) => Navigator.pop(context));
                  }
                },
                child: Text(
                  'บันทึกการกิน',
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
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.02,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'ยกเลิก',
                  style: GoogleFonts.kanit(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.07,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
