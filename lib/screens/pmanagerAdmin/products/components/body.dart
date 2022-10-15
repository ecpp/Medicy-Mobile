import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:uuid/uuid.dart';

import '../../../../constants.dart';
import '../../../../helper/database_manager.dart';

class AddProductBody extends StatefulWidget {
  @override
  const AddProductBody({Key? key, required this.allCategories})
      : super(key: key);
  final List<String> allCategories;
  State<StatefulWidget> createState() {
    return _AddProductBodyState();
  }
}

class _AddProductBodyState extends State<AddProductBody> {
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  String? selectedCat;
  String? value;
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
                      hintText: 'Product Name',
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400)),
                  controller: _nameController,
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.38,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextField(
                      decoration: new InputDecoration(
                          hintText: 'Price',
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                      controller: _priceController,
                      style: new TextStyle(
                          fontSize: 16.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.38,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: TextField(
                          decoration: new InputDecoration(
                              hintText: 'Stock',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                          controller: _stockController,
                          style: new TextStyle(
                              fontSize: 16.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextField(
                      decoration: new InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                      controller: _descriptionController,
                      style: new TextStyle(
                          fontSize: 16.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: DropdownButton<String>(
                      hint: selectedCat != null ? Text(selectedCat!) : Text('Category'),
                      value: value,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCat = value;
                        });
                      },
                      items: widget.allCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: selectImageButton(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: addProductButton(),
                  ),
                ],
              )
            ])),
        Divider(
          color: Colors.black,
        ),
        Text(
          "Products",
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text("Swipe to delete",
            style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w200)),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(dbProductsTable)
                .snapshots(),
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
                        key: Key(doc["title"]),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          await removeProduct(doc["title"]);
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
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(doc["images"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(doc["title"]),
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

  Widget addProductButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Add Product",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Adding...",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          "Error",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Success",
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
        if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty && _stockController.text.isNotEmpty && _descriptionController.text.isNotEmpty && selectedCat != null) {
          if (urlDownload != null) {
            setState(() {
              stateOnlyText = ButtonState.loading;
            });
            await addProduct(_descriptionController.text, urlDownload!, num.parse(_priceController.text), int.parse(_stockController.text), _nameController.text, selectedCat!);
            _nameController.clear();
            _priceController.clear();
            _stockController.clear();
            _descriptionController.clear();
            selectedCat = null;
            urlDownload = null;
            setState(() {
              stateOnlyText = ButtonState.success;
            });
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              stateOnlyText = ButtonState.idle;
              stateOnlyTextSelectImage = ButtonState.idle;
            });
          } else {
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
        } else {
          setState(() {
            stateOnlyText = ButtonState.fail;
            SnackBar snackBar = SnackBar(
              content: Text('Lütfen boş alan bırakmayınız!'),
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
          String saveName = "product_" + randomid;
          final pathToReport = 'products/$saveName';
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
