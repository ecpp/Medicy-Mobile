import 'package:flutter/material.dart';
import '../../components/default_button.dart';
import '../../models/Product.dart';
import '../../size_config.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";
  final Product itemToDetail;
  const DetailsScreen({Key? key, required this.itemToDetail})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: Body(product: itemToDetail),


    );
  }

}
