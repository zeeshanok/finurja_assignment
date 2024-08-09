import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColoredTile extends StatelessWidget {
  const ColoredTile({
    super.key,
    this.margin,
    required this.color,
    required this.child,
  });

  final EdgeInsetsGeometry? margin;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: child,
    );
  }
}
