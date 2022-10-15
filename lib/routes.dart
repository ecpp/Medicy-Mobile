import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/pmanagerAdmin/deliveries.dart';
import 'package:shop_app/screens/pmanagerAdmin/pmanagerAdmin.dart';
import 'package:shop_app/screens/pmanagerAdmin/products/add_remove_product.dart';
import 'package:shop_app/screens/profile/my_orders/orders_page.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/sales_manager/sales_manager_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/screens/payment/payment_screen.dart';
import 'package:shop_app/screens/comment/pending_comments.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileMain.routeName: (context) => ProfileMain(),
  PaymentScreen.routeName: (context) => PaymentScreen(),
  pendingCommentsScreen.routeName: (context) => pendingCommentsScreen(),
  ProductManagerAdminScreen.routeName: (context) => ProductManagerAdminScreen(),
  DeliveriesScreen.routeName: (context) => DeliveriesScreen(),
  AddProductScreen.routeName: (context) => AddProductScreen(),
  SalesManagerScreen.routeName: (context) => SalesManagerScreen(),
  TransactionScreen.routeName: (context) => TransactionScreen()
};
