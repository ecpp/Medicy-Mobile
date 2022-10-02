import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionClass {
  num totalprice;
  String user;
  String transactionid;
  String orderstatus;
  String invoicePath;
  Timestamp purchaseDate;
  Map<String, dynamic> items;

  TransactionClass(
      {required this.totalprice,
      required this.user,
      required this.transactionid,
      required this.orderstatus,
      required this.invoicePath,
      required this.purchaseDate,
      required this.items});

// Our demo Products
}
