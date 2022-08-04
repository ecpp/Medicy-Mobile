import 'package:flutter/material.dart';
import '../helper/database_manager.dart';

class Product {
  int id;
  String images;
  num rating;
  bool isPopular;
  String title;
  num price;
  num discountprice;
  String description;
  String category;
  int stock;
  int numsold;

  Product({
    required this.id,
    required this.images,
    required this.rating,
    required this.isPopular,
    required this.title,
    required this.price,
    required this.discountprice,
    required this.description,
    required this.category,
    required this.stock,
    required this.numsold,
  });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['images'] = this.images;
    data['rating'] = this.rating;
    data['price'] = this.price;
    data['discountprice'] = this.discountprice;
    data['isPopular'] = this.isPopular;
    data['category'] = this.category;
    data['stock'] = this.stock;
    data['numsold'] = this.numsold;
    return data;
  }

// Our demo Products
}
