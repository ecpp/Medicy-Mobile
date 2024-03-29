import 'package:flutter/material.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/home/components/search_field.dart';
import 'package:shop_app/screens/home/components/product_cart.dart';
import '../components/product_card.dart';

class SearchResults extends StatelessWidget {
  @override
  //_SearchResultsState createState() => _SearchResultsState();
  Widget build(BuildContext context) {
    return Scaffold(
      body: _SearchResultsState(),
      appBar: AppBar(
        title: Text("Search Results", style: TextStyle(color: Colors.black)),

      ),
    );
  }
}

class _SearchResultsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }
}

Widget _buildListView() {
  return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: searchList == null ? 0 : searchList.length,
      itemBuilder: (context, index) {
        return ProductCardSearch(product: searchList[index]);

        // return _buildRow(data[index]);
      });
}
