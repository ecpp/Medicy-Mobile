import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/constants.dart';


class WidgetCustomNavBar extends StatelessWidget {
  final int? selectedIndex;
  final List<PersistentBottomNavBarItem>? items;
  final ValueChanged<int>? onItemSelected;

  const WidgetCustomNavBar({
    Key? key,
    this.selectedIndex,
    @required this.items,
    this.onItemSelected,
  }) : super(key: key);

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      alignment: Alignment.center,
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isSelected
              ? Container(
                  constraints: const BoxConstraints(minWidth: 100),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/Profile Image.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 5),
                      IconTheme(
                        data: const IconThemeData(
                          size: 24.0,
                          color: Colors.white,
                        ),
                        child: item.icon,
                      ),
                      const SizedBox(width: 5),
                      Material(
                        type: MaterialType.transparency,
                        child: FittedBox(
                          child: Text(
                            item.title!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: IconTheme(
                    data: const IconThemeData(size: 26.0),
                    child: item.icon,
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      elevation: 10.0,
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items!.map((item) {
            int index = items!.indexOf(item);
            return InkWell(
              onTap: () {
                onItemSelected!(index);
              },
              child: _buildItem(item, selectedIndex == index),
            );
          }).toList(),
        ),
      ),
    );
  }
}
