import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/reviewModal.dart';
import 'package:shop_app/screens/comment/reviewUI.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

List<ReviewModal> reviewList = [];
ReviewModal newreview = new ReviewModal(name: "asd", comment: "asd", rating: 5, itemName: " ", reviewid: "");
Map<int, int> countlar = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
num totalrating = 0;

class Reviews extends StatefulWidget {
  final String itemname;
  Reviews({Key? key, required this.itemname}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
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
        }

        reviewList.clear();
        totalrating = 0;
        snapshot.data!.docs.map((DocumentSnapshot doc2) {
          countlar = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
          Map<String, dynamic> data = doc2.data()! as Map<String, dynamic>;
          for (var key in data.keys) {
            newreview = new ReviewModal(
              name: data['name'],
              rating: data['rating'],
              comment: data['comment'],
              itemName: data['productName'],
              reviewid: doc2.reference.id,
            );
          }
          if (data['productName'] == widget.itemname &&
              data['status'] == "approved") {
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 2, color: kPrimaryColor)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: totalrating.toString(),
                            style: TextStyle(
                                fontSize: 48.0,
                                color: totalrating > 2.5
                                    ? (totalrating > 3.9
                                        ? Color.fromARGB(255, 10, 165, 1)
                                        : Color.fromARGB(255, 254, 170, 13))
                                    : Color.fromARGB(255, 193, 6, 6)),
                          ),
                          TextSpan(
                            text: "/5",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "${reviewList.length} Reviews",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                SmoothStarRating(
                  starCount: 5,
                  rating: totalrating.toDouble(),
                  size: 28.0,
                  color: kPrimaryColor,
                  borderColor: kPrimaryColor,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
              itemCount: reviewList.length,
              itemBuilder: (context, index) {
                return ReviewUI(
                  name: reviewList[index].name,
                  comment: reviewList[index].comment,
                  rating: reviewList[index].rating,
                  onTap: () {
                    Future.delayed(const Duration(seconds: 4), () async {
                      if (mounted){
                        setState(() {
                          isMore = !isMore;
                        });
                      }
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
