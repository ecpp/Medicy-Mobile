import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/reviewModal.dart';
import 'package:shop_app/screens/comment/pending_comment.dart';

List<ReviewModal> reviewList = [];
ReviewModal newreview = new ReviewModal(
    name: "asd", comment: "asd", rating: 5, itemName: " ", reviewid: "");
Map<int, int> countlar = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
num totalrating = 0;

class pendingCommentsScreen extends StatefulWidget {
  static String routeName = "/pendingComments";
  pendingCommentsScreen({Key? key}) : super(key: key);

  @override
  _PendingCommentsState createState() => _PendingCommentsState();
}

class _PendingCommentsState extends State<pendingCommentsScreen> {
  bool isMore = false;
  List<double> ratings = [0.1, 0.3, 0.5, 0.7, 0.9];

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('productreviews').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        };

        reviewList.clear();
        totalrating = 0;
        snapshot.data!.docs.map((DocumentSnapshot doc2) {
          countlar = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
          Map<String, dynamic> data = doc2.data()! as Map<String, dynamic>;
          for (var key in data.keys) {
            newreview = new ReviewModal(
                reviewid: doc2.reference.id,
                name: data['name'],
                rating: data['rating'],
                comment: data['comment'],
                itemName: data['productName']);
          }
          if (data['status'] == "pending") {
            reviewList.add(newreview);
            countlar.update(data['rating'], (value) => value + 1);
            totalrating = totalrating + data['rating'];
          }
        }).toList();
        if (!reviewList.isEmpty) totalrating = totalrating / reviewList.length;
        return reviewListUI();
      },
    );
  }

  Widget reviewListUI() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PENDING COMMENTS",
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
              itemCount: reviewList.length,
              itemBuilder: (context, index) {
                return PendingCommentUI(
                  itemName: reviewList[index].itemName,
                  name: reviewList[index].name,
                  comment: reviewList[index].comment,
                  rating: reviewList[index].rating,
                  reviewid: reviewList[index].reviewid,
                  onTap: () {
                    Future.delayed(const Duration(seconds: 4), () async {
                      setState(() {
                        isMore = !isMore;
                      });
                    });
                  },
                  isLess: isMore,
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
