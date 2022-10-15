import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'discount_banner.dart';
import 'home_categories.dart';
import 'home_header.dart';
import 'popular_product.dart';

List<Product> productListnew = [];

class MainBody extends StatefulWidget {
  const MainBody({
    Key? key,
  }) : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();

}

class _MainBodyState extends State<MainBody>{
  late Stream<QuerySnapshot> _productsStream;

  @override
  void initState() {
    super.initState();
    _productsStream = FirebaseFirestore.instance.collection(dbProductsTable).snapshots();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null ||
            snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        productListnew.clear();
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          Product newProduct = new Product(
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
          productListnew.add(newProduct);
        }).toList();
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  HomeHeader(),
                  DiscountBanner(),
                  CategoriesHome(),
                  SizedBox(height: getProportionateScreenWidth(15)),
                  PopularProducts(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
