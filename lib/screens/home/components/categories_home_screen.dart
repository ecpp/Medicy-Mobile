import 'package:flutter/material.dart';
import 'package:shop_app/models/categoryModel.dart';
import '../../../helper/database_manager.dart';
import '../../../models/Product.dart';
import '../../../size_config.dart';
import '../../categories/category_default.dart';
import 'body.dart';
import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Categories",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
              future: getCategories(),
              builder: (context, AsyncSnapshot<List<categoryModel>> snap) {
                if (snap.connectionState == ConnectionState.none ||
                    snap.data == null) {
                  return CircularProgressIndicator();
                }
                return Row(
                    children: snap.data!
                        .map((value) => SpecialOfferCard(
                              image: value.image,
                              category: value.name,
                              numOfBrands: 0,
                              press: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DefaultCategoryScreen(
                                          categoryName: value.name,
                                          products:
                                              getProductsinCategory(value.name),
                                        )));
                              },
                            ))
                        .toList());
              },
            )),
      ],
    );
  }

  List<Product> getProductsinCategory(String str) {
    List<Product> prds = [];
    for (var task in productListnew) {
      // do something
      if (task.category == str) {
        prds.add(task);
      }
    }
    return prds;
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(250),
          height: getProportionateScreenWidth(140),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(image,
                    height: 300, width: 300, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(24),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //TextSpan(text: "$numOfBrands Brands")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
