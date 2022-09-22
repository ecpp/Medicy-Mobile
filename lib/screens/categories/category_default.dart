import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/enums.dart';
import '../../components/product_card.dart';
import '../../models/Product.dart';

class DefaultCategoryScreen extends StatefulWidget {
  @override
  _DefaultCategoryScreen createState() => _DefaultCategoryScreen();
  const DefaultCategoryScreen(
      {Key? key, required this.categoryName, required this.products})
      : super(key: key);

  final String categoryName;

  final List<Product> products;
}

class _DefaultCategoryScreen extends State<DefaultCategoryScreen> {
  bool isDescending = false;
  bool isPopular = false;
  String poptext = "Popularity";
  String pricetext = "Price";

  Widget build(BuildContext context) {
    final sortedItems = widget.products;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName, style: TextStyle(color: Colors.black)),
      ),
        body: Column(
          children: [
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: DropdownSearch(
                  items: ["Price Ascending", "Price Descending", "Popularity Ascending", "Popularity Descending"],

                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    baseStyle: TextStyle(fontSize: 15, color: kPrimaryColor),
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Sort By",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(color: Colors.black),
                      ),



                    ),
                  ),
                  onChanged: (value) {
                    if (value == "Price Ascending") {
                      setState(() => isDescending = false);
                      sortedItems.sort((a, b) => a.price.compareTo(b.price));
                    } else if (value == "Price Descending") {
                      setState(() => isDescending = true);
                      sortedItems.sort((a, b) => b.price.compareTo(a.price));
                    } else if (value == "Popularity Ascending") {
                      setState(() => isPopular = false);
                      sortedItems.sort((a, b) => a.numsold.compareTo(b.numsold));
                    } else if (value == "Popularity Descending") {
                      setState(() => isPopular = true);
                      sortedItems.sort((a, b) => b.numsold.compareTo(a.numsold));
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
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
