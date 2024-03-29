import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/home/components/body.dart';
import 'package:shop_app/search_results.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

List<Product> searchList = [];

class SearchField extends StatefulWidget {
  SearchField({
    Key? key,
  }) : super(key: key);
  State<StatefulWidget> createState() => _SearchFieldState();

}

class _SearchFieldState extends State<SearchField> {
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String valueToSearch;
    return Container(
      width: SizeConfig.screenWidth * 0.95,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          setState(() {

          });;
        },
        onSubmitted: (value) => {
          searchList.clear(),
          _controller.clear(),
          valueToSearch = value.toLowerCase(),
          for (var key in productListnew)
            {
              if (key.title.toLowerCase().contains(valueToSearch) ||
                  key.description.toLowerCase().contains(valueToSearch))
                {searchList.add(key)},
            },
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: SearchResults(),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          ),
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search product",
            prefixIcon: Icon(Icons.search),
            suffixIcon: _controller.text.length > 0 ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ) : null
        ),
      ),
    );
  }
}