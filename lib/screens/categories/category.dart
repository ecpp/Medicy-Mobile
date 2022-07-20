import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/home/components/body.dart';
import '../../components/product_card.dart';

class CategoryScreen extends StatefulWidget {
  final String type;
  @override
  const CategoryScreen(this.type);
  _CategoryScreen createState() => _CategoryScreen(type);
}

class _CategoryScreen extends State<CategoryScreen> {
  final String type;
  _CategoryScreen(this.type) : super();

  //_PreScreenState createState() => _PreScreenState();
  final sortedItems = productListnew;
  bool isDescending = false;
  bool isPopular = false;
  String poptext = "Popularity";
  String pricetext = "Price";
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        body: Column(
          children: [
            SizedBox(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.all(1)),
                  TextButton.icon(
                      onPressed: () {
                        setState(() => isDescending = !isDescending);
                        if (isDescending) {
                          poptext = "Popularity";
                          pricetext = "Price Descending";
                          sortedItems
                              .sort((a, b) => b.price.compareTo(a.price));
                        } else {
                          poptext = "Popularity";
                          pricetext = "Price Ascending";
                          sortedItems
                              .sort((a, b) => a.price.compareTo(b.price));
                        }
                      },
                      icon: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.compare_arrows, size: 28),
                      ),
                      label: Text(isDescending ? pricetext : pricetext)),
                  TextButton.icon(
                      onPressed: () {
                        setState(() => isPopular = !isPopular);
                        if (isPopular) {
                          poptext = "Popularity: Ascending";
                          pricetext = "Price";
                          sortedItems
                              .sort((a, b) => b.price.compareTo(a.numsold));
                        } else {
                          poptext = "Popularity: Descending";
                          pricetext = "Price";
                          sortedItems
                              .sort((a, b) => a.price.compareTo(b.numsold));
                        }
                      },
                      icon: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.compare_arrows, size: 28),
                      ),
                      label: Text(isPopular ? poptext : poptext)),
                ]),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(15.0),
                    itemCount:
                        productListnew == null ? 0 : productListnew.length,
                    itemBuilder: (context, index) {
                      if (sortedItems[index].category == type)
                        return ProductCard(product: sortedItems[index]);
                      else
                        return Text("");
                    }))
          ],
        ));
  }
}
