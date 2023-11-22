// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_interpolation_to_compose_strings, unused_import, prefer_is_empty, sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_diaryfood_app/models/diaryfood.dart';
import 'package:my_diaryfood_app/utils/env.dart';
import 'package:my_diaryfood_app/services/call_api.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ModifyDiaryfoodUI extends StatefulWidget {
  //ตัวแปรหรือออกเจ็กต์ที่เก็บข้องมูลที่ส่งมาจากหน้า Home ที่ผู้ใช้เลือกรายการที่จะดูเพื่อแก้ไขหรือลบ
  Diaryfood? diaryfood;

  ModifyDiaryfoodUI({super.key, this.diaryfood});

  @override
  State<ModifyDiaryfoodUI> createState() => _ModifyDiaryfoodUIState();
}

class _ModifyDiaryfoodUIState extends State<ModifyDiaryfoodUI> {
  TextEditingController foodDateCtrl = TextEditingController(text: '');
  TextEditingController foodshopCtrl = TextEditingController(text: '');
  TextEditingController foodPayCtrl = TextEditingController(text: '');

  int time = 1;

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

  String foodProvince = 'กรุงเทพมหานคร';

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
  void initState() {
    foodshopCtrl.text = widget.diaryfood!.foodShopname!;
    foodDateCtrl.text = widget.diaryfood!.foodDate!;
    foodPayCtrl.text = widget.diaryfood!.foodPay!;
    foodProvince = widget.diaryfood!.foodProvince!;
    time = int.parse(widget.diaryfood!.foodMeal!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'แก้ไช-ลบ ข้อมูล My Diary Food',
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
                            ? NetworkImage(
                                Env.domainURL +
                                    'diaryfoodapi/images/' +
                                    widget.diaryfood!.foodImage!,
                              )
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
                  if (foodshopCtrl.text.trim().length == 0) {
                    showWarningDialog(context, "ป้อนชื่อร้านด้วยครับ....");
                  } else if (foodshopCtrl.text.trim().length == 0) {
                    showWarningDialog(
                        context, "ป้อนค่าใช้จ่ายด้วยด้วยครับ....");
                  } else if (foodshopCtrl.text.trim().length == 0) {
                    showWarningDialog(context, "เลือกวันที่กินด้วยครับ....");
                  } else {
                    Diaryfood diaryfood = Diaryfood(
                      foodId: widget.diaryfood!.foodId!,
                      foodShopname: foodshopCtrl.text.trim(),
                      foodImage: foodImageBase64 == '' ? '' : foodImageBase64,
                      foodPay: foodPayCtrl.text.trim(),
                      foodMeal: time.toString(),
                      foodDate: foodDateCtrl.text.trim(),
                      foodProvince: foodProvince,
                    );
                    callApi
                        .callAPIUpdateDiaryfood(diaryfood)
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
                                  'แก้ไขเรียบร้อยแล้ว',
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
                  'แก้ไขบันทึกการกิน',
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
                onPressed: () {
                  Diaryfood diaryfood = Diaryfood(
                    foodId: widget.diaryfood!.foodId!,
                  );
                  callApi.callAPIDeleteDiaryfood(diaryfood)
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
                                'ลบเรียบร้อยแล้ว',
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
                },
                child: Text(
                  'ลบข้อมูล',
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
