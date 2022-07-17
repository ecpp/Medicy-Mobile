import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import 'package:shop_app/constants.dart';

class ReviewUI extends StatelessWidget {
  final String name, comment;
  final num rating;
  final Function onTap;
  final bool isLess;
  const ReviewUI({
    Key? key,
    required this.name,
    required this.comment,
    required this.rating,
    required this.onTap,
    required this.isLess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.white,
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
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SmoothStarRating(
                starCount: 5,
                rating: rating.toDouble(),
                size: 28.0,
                color: kPrimaryColor,
                borderColor: kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: onTap(),
            child: isLess
                ? Text(
                    comment,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: kPrimaryColor,
                    ),
                  )
                : Text(
                    comment,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: kPrimaryColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
