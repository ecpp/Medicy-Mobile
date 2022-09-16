import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'categories_home_screen.dart';

List<Product> productListnew = [];

class Body extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection(dbProductsTable).snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null ||
            snapshot.hasError) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        productListnew.clear();
        snapshot.data!.docs.map((DocumentSnapshot document) {
          // BURDA BUTUN PRODUCTLARI TEKTE CEKIYORUZ = COK PRODUCTSA YAVAS OLUR??
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          Product newproduct = new Product(
              id: data['id'],
              images: data['images'],
              title: data['title'],
              price: data['price'],
              oldprice: data['oldprice'],
              description: data['description'],
              rating: data['rating'],
              isPopular: data['isPopular'],
              category: data['category'],
              numsold: data['timesold'],
              stock: data['stock']);

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
