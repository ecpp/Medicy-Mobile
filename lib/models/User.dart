import 'package:shop_app/helper/user_database.dart';
import 'package:flutter/material.dart';

class UserData {
  String name = "";
  String surname = "";
  String email = "";
  String ID = "";
  List transactions = [];
  String usertype = "";

  UserData({
    this.name = "",
    this.surname = "",
    this.email = "",
    this.ID = "",
    this.usertype = "",
  });

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    ID = json['ID'];
    transactions = json['transactionid'];
    usertype = json['usertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['email'] = this.email;
    data['ID'] = this.ID;
    data['transactionid'] = this.transactions;
    data['usertype'] = this.usertype;
    return data;
  }
}
