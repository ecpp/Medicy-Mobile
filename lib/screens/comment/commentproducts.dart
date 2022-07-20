import 'package:flutter/material.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../../constants.dart';

class CommentProductScreen extends StatefulWidget {
  final String itemname;
  const CommentProductScreen({Key? key, required this.itemname})
      : super(key: key);

  @override
  _CommentProductScreenState createState() => _CommentProductScreenState();
}

class _CommentProductScreenState extends State<CommentProductScreen> {
  var rating = 0.0;
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Review your order",
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: Form(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 25)),
                        Container(
                          //padding: EdgeInsets.symmetric(),
                          child: Text(
                            "Write a review for: " + widget.itemname,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      SmoothStarRating(
                        allowHalfRating: false,
                        rating: rating,
                        size: 40,
                        starCount: 5,
                        onRatingChanged: (value) {
                          setState(() {
                            rating = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                          controller: commentController,
                          maxLines: 6,
                          decoration:
                              InputDecoration(hintText: "Add a review.")),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 100.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Thank you for your review!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: kPrimaryColor,
                          ));
                          addReview(widget.itemname, commentController.text,
                              rating.toInt());
                          Navigator.popUntil(
                              context, ModalRoute.withName('/home'));
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
