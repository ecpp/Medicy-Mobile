
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/categories/category_whey.dart';
import 'package:shop_app/screens/home/components/search_field.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import '../components/product_card.dart';
import '../helper/database_manager.dart';
import '../models/Product.dart';

class SearchResults extends StatelessWidget {
  @override
  //_SearchResultsState createState() => _SearchResultsState();
  Widget build(BuildContext context) {
    return Scaffold(
      body: _SearchResultsState(),
    );
  }
}

class _SearchResultsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
      body: _buildListView()

      
    
    
    );
    

  }
}

Widget _buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: searchList == null ? 0 : searchList.length,
        itemBuilder: (context, index) {
            return ProductCard(product: searchList[index]);

          // return _buildRow(data[index]);
        });
  }