import 'package:flutter/material.dart';
import '../helper/database_manager.dart';

class Product {
  int id = 1;
  String images = "asdasd";
  num rating = 0;
  bool isPopular = false;
  String title = "asdasd";
  num price = 0;
  String description = "test123";
  String category = "whey";
  int stock = 0;
  int numsold = 0;

  Product({
    this.id = 1,
    this.images = "asdasd",
    this.rating = 0,
    this.isPopular = false,
    this.title = "asdasd",
    this.price = 0,
    this.description = "test123",
    this.category = "whey",
    this.stock = 0,
    this.numsold = 0,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    images = json['images'];
    rating = json['rating'];
    price = json['price'];
    isPopular = json['isPopular'];
    category = json['whey'];
    stock = json['stock'];
    numsold = json['numsold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['images'] = this.images;
    data['rating'] = this.rating;
    data['price'] = this.price;
    data['isPopular'] = this.isPopular;
    data['category'] = this.category;
    data['stock'] = this.stock;
    data['numsold'] = this.numsold;
    return data;
  }

// Our demo Products
}
