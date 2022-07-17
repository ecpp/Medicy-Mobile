import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/default_button.dart';
import '../../../helper/database_manager.dart';

String category = "";
String description = "";
String images = "";
num price = 0;
int stock = 0;
String title = "";

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => new _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imagesController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('App Name'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: "Product Name "),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontFamily: "Roboto"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(hintText: "Description "),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontFamily: "Roboto"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(hintText: "Stock Count "),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontFamily: "Roboto"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(hintText: "Price "),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontFamily: "Roboto"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  TextFormField(
                    controller: _categoryController,
                    decoration:
                        InputDecoration(hintText: "Category (pre/whey) "),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontFamily: "Roboto"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  TextFormField(
                    controller: _imagesController,
                    decoration: InputDecoration(hintText: "Image Link "),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontFamily: "Roboto"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  DefaultButton(
                      press: () async {
                        await addProduct(
                            _descriptionController.text,
                            _imagesController.text,
                            num.parse(_priceController.text),
                            int.parse(_stockController.text),
                            _titleController.text,
                            _categoryController.text);
                      },
                      text: "Add Product"),
                ]),
          ),
        ));
  }
}
