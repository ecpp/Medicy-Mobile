import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/refundModal.dart';
import 'package:shop_app/screens/sales_manager/refunds/pending_refund.dart';

List<RefundModal> refundList = [];
RefundModal newrefund = new RefundModal(
    name: "asd", pricePaid: 0, itemCount: 1, itemName: " ", refundid: "");

class pendingRefundsScreen extends StatefulWidget {
  static String routeName = "/smanagerRefunds";
  pendingRefundsScreen({Key? key}) : super(key: key);

  @override
  _PendingRefundsState createState() => _PendingRefundsState();
}

class _PendingRefundsState extends State<pendingRefundsScreen> {
  bool isMore = false;
  //List<double> ratings = [0.1, 0.3, 0.5, 0.7, 0.9];

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('refunds').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        refundList.clear();
        snapshot.data!.docs.map((DocumentSnapshot doc2) {
          Map<String, dynamic> data = doc2.data()! as Map<String, dynamic>;
          for (var key in data.keys) {
            newrefund = new RefundModal(
                refundid: doc2.reference.id,
                name: data['name'],
                itemCount: data['itemCount'],
                pricePaid: data['pricePaid'],
                itemName: data['productName']);
          }
          if (data['status'] == "pending") {
            refundList.add(newrefund);
          }
        }).toList();
        return refundListUI();
      },
    );
  }

  Widget refundListUI() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PENDING REFUND REQUESTS",
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
              itemCount: refundList.length,
              itemBuilder: (context, index) {
                return PendingRefundUI(
                  itemName: refundList[index].itemName,
                  name: refundList[index].name,
                  pricePaid: refundList[index].pricePaid,
                  itemCount: refundList[index].itemCount,
                  refundid: refundList[index].refundid,
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
