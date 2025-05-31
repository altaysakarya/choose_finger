import 'package:flutter/material.dart';

enum TapState { initial, waiting, completed, success }

class Tap extends StatefulWidget {
  final TapState state;
  const Tap({super.key, this.state = TapState.initial});

  @override
  State<Tap> createState() => _TapState();
}

class _TapState extends State<Tap> with SingleTickerProviderStateMixin {
  late TapState state = widget.state;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant Tap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      setState(() {
        state = widget.state;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get color => switch (state) {
        TapState.success => Colors.amber,
        _ => Colors.white,
      };

  double get size => switch (state) {
        TapState.initial => 100.0,
        TapState.waiting => 100.0,
        TapState.completed => 100.0,
        TapState.success => 150.0
      };

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: 150.0,
        height: 150.0,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.bounceOut,
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
