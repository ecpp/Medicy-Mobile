// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Transaction.dart';
import 'package:shop_app/models/userReport.dart';
import 'package:shop_app/screens/profile/my_orders/order_details.dart';
import 'package:shop_app/screens/sign_in/components/login_firebase.dart';
import 'package:url_launcher/url_launcher.dart';

List<UserReport> userReports = [];

class UserReportsScreen extends StatelessWidget {
  static String routeName = "/userReports";
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Reports').orderBy('date').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        userReports.clear();
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          if (data['forUser'] == user!.uid){
            UserReport report = new UserReport(
              createdBy: data['createdBy'],
              createdDate: data['date'],
              reportID: document.id,
              createdFor: data['forUser'],
              reportLink: data['reportLink'],
            );
            userReports.add(report);
          }
        }).toList();
        return Scaffold(
            appBar: AppBar(
              title: Text(
                "My Reports",
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                ListView.builder(
                  itemCount: userReports.length,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.all(1),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Divider(color: Colors.grey),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              iconText(
                                  Icon(
                                    Icons.edit,
                                    color: kRedColor,
                                  ),
                                  Text(
                                    "Rapor NO",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(userReports[index].reportID,
                                  style: TextStyle(fontSize: 11))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              iconText(
                                  Icon(
                                    Icons.today,
                                    color: kOrangeColor,
                                  ),
                                  Text(
                                    "Oluşturulma Tarihi",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Text(
                                  DateFormat('dd/MM/yyyy, HH:mm').format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          userReports[index]
                                              .createdDate
                                              .microsecondsSinceEpoch)),
                                  style: TextStyle(fontSize: 14))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              iconText(
                                  Icon(
                                    Icons.link,
                                    color: kGreenColor,
                                  ),
                                  Text(
                                    "Link",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                              InkWell(
                                  child: new Text('Raporu Aç',
                                      style: TextStyle(color: kBlueColor)),
                                  onTap: () =>
                                      launch(userReports[index].reportLink)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ]),
                      ),
                    );
                  },
                )
              ],
            ));
      },
    );
  }

  Widget iconText(Icon iconWidget, Text textWidget) {
    return Row(children: [
      iconWidget,
      SizedBox(
        width: 5,
      ),
      textWidget
    ]);
  }
}
