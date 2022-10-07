import 'package:cloud_firestore/cloud_firestore.dart';

class UserReport {
  String createdBy;
  String createdFor;
  String reportLink;
  String reportID;
  Timestamp createdDate;


  UserReport(
      {
        required this.createdBy,
        required this.createdFor,
        required this.reportLink,
        required this.reportID,
        required this.createdDate,});

// Our demo Products
}
