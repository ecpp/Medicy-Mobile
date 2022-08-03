import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/comment/reviews.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/models/Cart.dart';
import '../../../main.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import 'item_counter.dart';

int maxlim = 0;

class Body extends StatelessWidget {
  final Product product;
  int numOfItemToAdd = 0;
  bool found = false;
  bool problem = false;
  int count = 0;
  Body({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white10,
          child: Column(
            children: [
              ProductDescription(
                product: product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Colors.white10,
                child: Column(
                  children: [
                    NumericStepButton(
                      minValue: 0,
                      maxValue: 5,
                      onChanged: (value) {
                        numOfItemToAdd = value;
                      },
                    ),
                    TopRoundedContainer(
                      color: Colors.white10,
                      child: Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth * 0.15,
                            right: SizeConfig.screenWidth * 0.15,
                            bottom: getProportionateScreenWidth(40),
                          ),
                          child: Column(children: [
                            DefaultButton(
                              text: "Add To Cart",
                              press: () async {
                                await FirebaseFirestore.instance
                                    .collection(dbProductsTable)
                                    .doc(product.title)
                                    .get()
                                    .then((dataFromDB) {
                                  product.stock = dataFromDB.data()!["stock"];
                                });
                                print('stock: ');
                                print(product.stock);
                                problem = false;
                                if (product.stock == 0) {
                                  problem = true;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "There is no item left in the Stock",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: kPrimaryColor,
                                  ));
                                } else if (numOfItemToAdd == 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Please increase the amount of items!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: kPrimaryColor,
                                  ));
                                } else {
                                  for (int i = 0;
                                      i < currentCart.cartItems!.length;
                                      i++) {
                                    if (currentCart
                                            .cartItems![i].product.title ==
                                        product.title) {
                                      if (currentCart.cartItems![i].numOfItem +
                                              numOfItemToAdd >
                                          product.stock) {
                                        if (product.stock -
                                                currentCart
                                                    .cartItems![i].numOfItem <
                                            1) {
                                          problem = true;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              "You have all items in your cart!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: kPrimaryColor,
                                          ));
                                        } else {
                                          problem = true;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              "You can only add " +
                                                  (product.stock -
                                                          currentCart
                                                              .cartItems![i]
                                                              .numOfItem)
                                                      .toString() +
                                                  " items more!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            duration: Duration(seconds: 1),
                                            backgroundColor: kPrimaryColor,
                                          ));
                                        }
                                      } else if (!problem) {
                                        currentCart.cartItems![i].numOfItem +=
                                            numOfItemToAdd;
                                        if (loginStatus == true) {
                                          await addToCartDB(
                                              product.title,
                                              currentCart
                                                  .cartItems![i].numOfItem);
                                        }

                                        found = true;
                                      }
                                    }
                                  }
                                  ;
                                  if (!found && !problem) {
                                    currentCart.cartItems!.add(CartItem(
                                        product: product,
                                        numOfItem: numOfItemToAdd));
                                    if (loginStatus == true) {
                                      await addToCartDB(
                                          product.title, numOfItemToAdd);
                                    }
                                  }
                                  ;
                                  if (!problem) {
                                    count = count + numOfItemToAdd;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "Added to cart!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      duration: Duration(seconds: 1),
                                      backgroundColor: kPrimaryColor,
                                    ));
                                    Navigator.of(context).pop();
                                  }
                                }
                                ;
                              },
                            ),
                            SizedBox(height: 10.0),
                            DefaultButton(
                                text: "See comments",
                                press: () => SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      // add your code here.

                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => Reviews(
                                                  itemname: product.title)));
                                    })),
                          ])),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
