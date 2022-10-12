import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:uuid/uuid.dart';

import '../../../../constants.dart';
import '../../../../helper/database_manager.dart';

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {
  final nameController = TextEditingController();
  final imageController = TextEditingController();
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateOnlyTextSelectImage = ButtonState.idle;
  String? urlDownload;
  dynamic _image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: new InputDecoration(
                      hintText: 'Category Name',
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400)),
                  controller: nameController,
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: selectImageButton(),),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: addCategoryButton(),
                  ),
                ],
              )
            ])),
        Divider(
          color: Colors.black,
        ),

        Text(
          "Categories",
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          "Swipe to delete", style: TextStyle(
            color: Colors.black, fontSize: 12, fontWeight: FontWeight.w200
        )),
        SizedBox(
          height: 10,
        ),


        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('categories').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else
                return ListView(
                  children: (snapshot.data!).docs.map((doc) {
                    return Card(
                      child: Dismissible(
                        key: Key(doc["name"]),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          await removeCategory(doc["name"]);
                        },
                        background: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Spacer(),
                              SvgPicture.asset("assets/icons/Trash.svg"),
                            ],
                          ),
                        ),
                        child: ListTile(
                          title: Text(doc["name"]),
                        ),
                      ),
                    );
                  }).toList(),
                );
            },
          ),
        ),
      ],
    );
  }

  Widget addCategoryButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Kategori Ekle",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Oluşturuluyor",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          "Hata",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Başarılı",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: kPrimaryColor,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: kRedColor,
        ButtonState.success: kGreenColor,
      },
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Colors.red),
        strokeWidth: 1,
      ),
      onPressed: () async {
        if (nameController.text.isNotEmpty){
          if (urlDownload != null) {
            setState(() {
              stateOnlyText = ButtonState.loading;
            });
            await addCategory(
                nameController.text, urlDownload!);
            nameController.clear();
            urlDownload = null;
            setState(() {
              stateOnlyText = ButtonState.success;
            });
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              stateOnlyText = ButtonState.idle;
              stateOnlyTextSelectImage = ButtonState.idle;
            });
          }
          else {
            setState(() {
              stateOnlyText = ButtonState.fail;
              SnackBar snackBar = SnackBar(
                content: Text('Lütfen resim seçiniz!'),
                duration: Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              stateOnlyText = ButtonState.idle;
            });
          }
        }
        else {
          setState(() {
            stateOnlyText = ButtonState.fail;
            SnackBar snackBar = SnackBar(
              content: Text('Lütfen kategori adını giriniz!'),
              duration: Duration(seconds: 1),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            stateOnlyText = ButtonState.idle;
          });
        }

      },
      state: stateOnlyText,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  Widget selectImageButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Resim Seç",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Yükleniyor",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          "Hata",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Resim Seçildi",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: kPrimaryColor,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: kRedColor,
        ButtonState.success: kGreenColor,
      },
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Colors.red),
        strokeWidth: 1,
      ),
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'jpeg'],
        );
        if (result != null) {
          setState(() {
            stateOnlyTextSelectImage = ButtonState.loading;
          });
          final path = result.files.single.path;
          _image = File(path!);
          String randomid = Uuid().v1();
          UploadTask uploadTask;
          String saveName = "category_" + randomid;
          final pathToReport = 'categories/$saveName';
          final ref = FirebaseStorage.instance.ref().child(pathToReport);
          uploadTask = ref.putFile(_image!);

          final snapshot = await uploadTask.whenComplete(() => {});
          urlDownload = await snapshot.ref.getDownloadURL();
          setState(() {
            stateOnlyTextSelectImage = ButtonState.success;
          });
        }
      },
      state: stateOnlyTextSelectImage,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }


}
