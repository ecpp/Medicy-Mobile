import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import '../../helper/database_manager.dart';
import '../../main.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  void _waitForData() async {
    await fetchAllUserDataOnLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (loginStatus == true){
      _waitForData();
    };
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
