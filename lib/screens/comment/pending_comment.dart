import 'package:flutter/material.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:shop_app/constants.dart';
import '../../components/default_button.dart';

class PendingCommentUI extends StatelessWidget {
  final String name, comment, itemName, reviewid;
  final num rating;
  final Function onTap;
  final bool isLess;
  const PendingCommentUI({
    Key? key,
    required this.itemName,
    required this.name,
    required this.comment,
    required this.rating,
    required this.onTap,
    required this.isLess,
    required this.reviewid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: kPrimaryLightColor,
          width: 3,
        ),
      ),
      padding: EdgeInsets.only(
        top: 2.0,
        bottom: 2.0,
        left: 16.0,
        right: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Product: ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Expanded(
                child: Text(
                  itemName,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              Text(
                "Owner: ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              Text(
                "Stars: ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              SizedBox(
                width: 5,
              ),
              SmoothStarRating(
                starCount: 5,
                rating: rating.toDouble(),
                size: 22.0,
                color: kPrimaryColor,
                borderColor: kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: 6.0),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              Text(
                "Comment: ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap(),
            child: isLess
                ? Text(
                    comment,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    comment,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
          ),
          SizedBox(height: 6.0),
          Divider(
            thickness: 3,
            color: Colors.grey,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: DefaultButton(
                  text: "Approve Comment",
                  press: () async {
                    num currentRating = await getcurrentRating(itemName);
                    print("Suanki rating: " + currentRating.toString());
                    int kackererateedildi = await gethowmanyRated(itemName);
                    print(
                        "Suanki kackererate: " + kackererateedildi.toString());
                    currentRating = currentRating + rating;
                    print("Toplanmis hali: " + currentRating.toString());
                    kackererateedildi = kackererateedildi + 1;
                    currentRating = currentRating / kackererateedildi;
                    currentRating = num.parse(currentRating.toStringAsFixed(2));
                    print("Son hali rating: " + currentRating.toString());
                    await updateProductRating(
                        itemName, currentRating, kackererateedildi);
                    await approveReview(reviewid);
                    await updateRating2(itemName);
                  }))
        ],
      ),
    );
  }
}
