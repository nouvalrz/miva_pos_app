import 'package:flutter/material.dart';

class MivaCard extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color backgroundColor;

  const MivaCard.outline(
      {super.key,
      this.child,
      this.borderRadius = 4,
      this.borderColor = const Color.fromARGB(255, 232, 232, 232),
      this.padding = EdgeInsets.zero,
      this.backgroundColor = Colors.transparent,
      this.borderWidth = 1,
      this.margin = const EdgeInsets.all(4)});

  const MivaCard.filled(
      {super.key,
      this.child,
      this.borderRadius = 4,
      this.borderColor = Colors.transparent,
      this.padding = EdgeInsets.zero,
      this.backgroundColor = const Color(0xffF3F1FF),
      this.borderWidth = 0,
      this.margin = const EdgeInsets.all(4)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}
