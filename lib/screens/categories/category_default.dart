import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import '../../components/product_card.dart';
import '../../models/Product.dart';

class DefaultCategoryScreen extends StatefulWidget {
  @override
  DefaultCategoryScreen2 createState() => DefaultCategoryScreen2();
  const DefaultCategoryScreen(
      {Key? key, required this.categoryName, required this.products})
      : super(key: key);

  final String categoryName;

  final List<Product> products;
}

class DefaultCategoryScreen2 extends State<DefaultCategoryScreen> {
  bool isDescending = false;
  bool isPopular = false;
  String poptext = "Popularity";
  String pricetext = "Price";

  Widget build(BuildContext context) {
    final sortedItems = widget.products;

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
                      label: Text(
                        isDescending ? pricetext : pricetext,
                      )),
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
                itemCount: sortedItems.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: sortedItems[index]);

                  // return _buildRow(data[index]);
                },
              ),
            ),
          ],
        ));
  }

  /*

  Future<List<Product>> getProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products_new')
        .where('category', isEqualTo: widget.categoryName)
        .get();
    ;

    // Get data from docs and convert map to Lis
    //for a specific field
    final allData = await querySnapshot.docs
        .map((doc) => Product(
            id: doc.get("id"),
            images: doc.get("images"),
            rating: doc.get("rating"),
            isPopular: doc.get("isPopular"),
            title: doc.get("title"),
            price: doc.get("price"),
            description: doc.get("description"),
            category: doc.get("category"),
            stock: doc.get("stock"),
            numsold: doc.get("timesold")))
        .toList();
    return allData;
  }

  Future<List<Product>> getProducts2() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products_new')
        .where('category', isEqualTo: widget.categoryName)
        .get();
    ;

    // Get data from docs and convert map to Lis
    //for a specific field
    final allData = await querySnapshot.docs
        .map((doc) => Product(
            id: doc.get("id"),
            images: doc.get("images"),
            rating: doc.get("rating"),
            isPopular: doc.get("isPopular"),
            title: doc.get("title"),
            price: doc.get("price"),
            description: doc.get("description"),
            category: doc.get("category"),
            stock: doc.get("stock"),
            numsold: doc.get("timesold")))
        .toList();
    sortedItems.clear();
    for (var task in allData) {
      // do something
      sortedItems.add(task);
    }
    return allData;
  }




  */
}
