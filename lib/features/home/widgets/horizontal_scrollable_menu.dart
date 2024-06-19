// horizontal_scrollable_menu.dart
import 'package:flutter/material.dart';

class HorizontalScrollableMenu extends StatefulWidget {
  final List<String> menuItems;
  final ValueChanged<String> onItemSelected;
  final String selectedItem;

  HorizontalScrollableMenu({
    required this.menuItems,
    required this.onItemSelected,
    required this.selectedItem,
  });

  @override
  _HorizontalScrollableMenuState createState() => _HorizontalScrollableMenuState();
}

class _HorizontalScrollableMenuState extends State<HorizontalScrollableMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.menuItems.map((item) {
            bool isSelected = item == widget.selectedItem;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.onItemSelected(item);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.white : Colors.transparent,
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
