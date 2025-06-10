import 'package:flutter/material.dart';

class LinearBackground extends StatelessWidget {
  final Widget? child;
  const LinearBackground({super.key, this.child});

  List<Color> get _colors =>
      [Colors.blue.shade200, Colors.blue.shade400, Colors.blue.shade600];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constants) {
      final double width = constants.maxWidth;
      final double height = constants.maxHeight;
      return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: _colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: child);
    });
  }
}
