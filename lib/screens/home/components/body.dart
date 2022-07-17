import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

num ratingloop = 0;
List<Product> productListnew = [];
Product newproduct = new Product(
  id: 1,
  images: "assets/images/ps4_console_white_1.png",
  title: "Wireless Controller for PS4™",
  price: 65,
  description: "test123",
  rating: 4,
  category: "whey",
  isPopular: true,
);
Product newerproduct = new Product(
  id: 1,
  images: "assets/images/ps4_console_white_1.png",
  title: "Wireless Controller for PS4™",
  price: 65,
  description: "test123",
  rating: 4,
  category: "whey",
  isPopular: true,
);

class Body extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('products_new').snapshots();
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
        productListnew.clear();
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          for (var key in data.keys) {
            newproduct = new Product(
                id: data['id'],
                images: data['images'],
                title: data['title'],
                price: data['price'],
                description: data['description'],
                rating: data['rating'],
                isPopular: data['isPopular'],
                category: data['category'],
                numsold: data['timesold'],
                stock: data['stock']);
          }

          productListnew.add(newproduct);
        }).toList();

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                HomeHeader(),
                DiscountBanner(),
                //SizedBox(height: getProportionateScreenWidth(10)),
                //Categories(),
                SpecialOffers(),
                SizedBox(height: getProportionateScreenWidth(15)),
                PopularProducts(),
                //SizedBox(height: getProportionateScreenWidth(30)),
              ],
            ),
          ),
        );
      },
    );
  }
}
