import 'package:flutter/material.dart';
import 'package:shop_app/models/Cart.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';
import 'dart:async';
StreamController<num> cartStreamController = StreamController<num>.broadcast();
StreamController<num> cartStreamController2 = StreamController<num>.broadcast();

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(stream: cartStreamController2.stream,),
      bottomNavigationBar: CheckoutCard(stream: cartStreamController.stream,),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
