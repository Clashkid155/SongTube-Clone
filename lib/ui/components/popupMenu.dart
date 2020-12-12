import 'package:flutter/material.dart';

class FlexiblePopupMenu extends StatelessWidget {
  final Widget child;
  final List<String> items;
  final Function(String) onItemTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  FlexiblePopupMenu({
    @required this.child,
    @required this.items,
    @required this.onItemTap,
    this.borderRadius,
    this.padding
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        showMenu<String>(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius == null
              ? BorderRadius.zero
              : borderRadius,
          ),
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            0, 0
          ),
          items: items.map((e) {
            if (e != "") {
              return PopupMenuItem<String>(
                child: Text(
                  e, style: TextStyle(
                    color: Theme.of(context)
                      .textTheme.bodyText1.color
                  ),
                ),
                value: "$e",
              );
            }
          }).toList()
        ).then((value) {
          onItemTap(value);
        });
      },
      child: Padding(
        padding: padding == null ? EdgeInsets.zero : padding,
        child: child
      ),
    );
  }
}