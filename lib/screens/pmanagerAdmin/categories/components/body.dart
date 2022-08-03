import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
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
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextField(
                  decoration: new InputDecoration(
                      hintText: 'Image Link',
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400)),
                  controller: imageController,
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w400),
                ),
              ),
              ElevatedButton(
                  onPressed: () async{
                    await addCategory(nameController.text, imageController.text);
                    nameController.clear();
                    imageController.clear();
                    SnackBar snackBar = SnackBar(
                      content: Text('Category Added'),
                      duration: Duration(seconds: 1),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Text("Add New"))
            ],
          ),
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
}
