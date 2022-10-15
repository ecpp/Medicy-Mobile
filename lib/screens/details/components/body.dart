import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/database_manager.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/comment/reviews.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/models/Cart.dart';
import '../../../main.dart';
import '../../home/home_screen.dart';
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
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenWidth(680),
          child: ListView(
            shrinkWrap: true,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10.0),
                              NumericStepButton(
                                minValue: 0,
                                maxValue: product.stock,
                                onChanged: (value) {
                                  numOfItemToAdd = value;
                                },
                              ),
                              // SizedBox(
                              //   width: getProportionateScreenWidth(100),
                              //   height: getProportionateScreenHeight(50),
                              //   child: TextButton(
                              //     style: TextButton.styleFrom(
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(20)),
                              //       backgroundColor: kPrimaryColor,
                              //     ),
                              //     onPressed: () => SchedulerBinding.instance
                              //         .addPostFrameCallback((_) {
                              //       PersistentNavBarNavigator.pushNewScreen(
                              //         context,
                              //         screen: Reviews(itemname: product.title),
                              //         withNavBar:
                              //             true, // OPTIONAL VALUE. True by default.
                              //         pageTransitionAnimation:
                              //             PageTransitionAnimation.cupertino,
                              //       );
                              //     }),
                              //     child: Text(
                              //       "Reviews",
                              //       style: TextStyle(
                              //         fontSize: getProportionateScreenWidth(18),
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          TopRoundedContainer(
                            color: Colors.white10,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * 0.15,
                                right: SizeConfig.screenWidth * 0.15,
                                bottom: getProportionateScreenWidth(40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(30)),
        SafeArea(
          top: false,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (product.oldprice == 0)
                  Row(
                    children: [
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),

                    ],
                  ),
                if (product.oldprice != 0)
                  Column(
                    children: [
                      Text(
                        "\$${product.oldprice}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: kPrimaryColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),

                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  width: getProportionateScreenWidth(150),
                  height: getProportionateScreenHeight(50),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      backgroundColor: kPrimaryColor,
                    ),
                    onPressed: () async {
                      addToCart(context);
                    },
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),


      ],
      // BottomAppBar(
      //   child: Container(
      //     height: 20,
      //     child: SafeArea(
      //       child: Column(
      //         //mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text.rich(
      //                 TextSpan(
      //                   text: "${product.oldprice}" + "\$",
      //                   style: TextStyle(fontSize: 14, color: Colors.black),
      //                   children: [
      //                     TextSpan(
      //                       text: "${product.price}" + "\$",
      //                       style:
      //                       TextStyle(fontSize: 16, color: Colors.black),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //
      //           // Text(
      //           //   "${product.price}" + "\$",
      //           //   style: TextStyle(
      //           //       fontSize: 20,
      //           //       color: Colors.black,
      //           //       fontWeight: FontWeight.bold),
      //           // ),
      //           SizedBox(
      //             width: getProportionateScreenWidth(250),
      //             child: DefaultButton(
      //                 text: "Add to Cart",
      //                 press: () {
      //                   addToCart(context);
      //                 }),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // )
    );
  }

  addToCart(BuildContext context) async {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "There is no item left in the Stock",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: kPrimaryColor,
      ));
    } else if (numOfItemToAdd == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Please increase the amount of items!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: kPrimaryColor,
      ));
    } else {
      for (int i = 0; i < currentCart.cartItems!.length; i++) {
        if (currentCart.cartItems![i].product.title == product.title) {
          if (currentCart.cartItems![i].numOfItem + numOfItemToAdd >
              product.stock) {
            if (product.stock - currentCart.cartItems![i].numOfItem < 1) {
              problem = true;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "You have all items in your cart!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: kPrimaryColor,
              ));
            } else {
              problem = true;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "You can only add " +
                      (product.stock - currentCart.cartItems![i].numOfItem)
                          .toString() +
                      " items more!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: kPrimaryColor,
              ));
            }
          } else if (!problem) {
            print('gelduk2');
            currentCart.cartItems![i].numOfItem += numOfItemToAdd;
            if (loginStatus == true) {
              await addToCartDB(
                  product.title, currentCart.cartItems![i].numOfItem);
            }

            found = true;
          }
        }
      }
      ;
      if (!found && !problem) {
        print('gelduk');
        currentCart.cartItems!
            .add(CartItem(product: product, numOfItem: numOfItemToAdd));
        if (loginStatus == true) {
          await addToCartDB(product.title, numOfItemToAdd);
        }
      }
      ;
      if (!problem) {
        cartStreamController2.add(currentCart.sumAll());
        cartStreamController.add(currentCart.sumAll());
        count = count + numOfItemToAdd;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Added to cart!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: kPrimaryColor,
        ));
      }
    }
  }
}
