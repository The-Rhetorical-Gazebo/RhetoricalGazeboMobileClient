import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius,
    this.alignment,
    this.elevation,
  }) : super(key: key);
  final Widget child;
  final double? width;
  final double? height;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final AlignmentGeometry? alignment;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        height: height,
        width: width,
        padding: padding,

        child: ClipRRect(child: child, borderRadius: BorderRadius.circular(15.0)),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
    );
  }
}
