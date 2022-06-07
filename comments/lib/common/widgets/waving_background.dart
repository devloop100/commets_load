import 'dart:math';
import 'package:flutter/material.dart';

import 'wave.dart';

class WavingBackground extends StatefulWidget {
  const WavingBackground(
      {required this.child,
      this.opacity,
      this.gradient = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.2, 0.4, 0.6, 0.8],
        colors: [
          Color(0xFF5ea9e8),
          Color(0xFF5288eb),
          Color(0xFF5036D5),
          Color(0xFF5B16D0),
        ],
      ),
      Key? key})
      : super(key: key);

  final Widget child;
  final double? opacity;
  final Gradient gradient;

  @override
  State<WavingBackground> createState() => _WavingBackgroundState();
}

class _WavingBackgroundState extends State<WavingBackground>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 6), vsync: this);
    final Animation<double> curve =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCirc);
    animation = Tween<double>(begin: 0.0, end: 1.5 * pi).animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          controller.reset();
          controller.duration = const Duration(hours: 50);
          animation =
              Tween<double>(begin: 1.5 * pi, end: 10000).animate(controller);
          controller.forward();
        });
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topCenter, children: [
      Opacity(
        opacity: widget.opacity ?? 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 550),
          decoration: BoxDecoration(
            gradient: widget.gradient,
          ),
        ),
      ),
      _wave(760, offset: 0, pageOffset: 0),
      _wave(120, offset: pi, pageOffset: 0),
      _wave(870, offset: pi / 2, pageOffset: 0),
      Positioned.fill(
        // top: kTopSafePadding * 2,
        // bottom: kTopSafePadding * 3.3,
        child: widget.child,
      ),
    ]);
  }

  _wave(double height, {double offset = 0.0, double? pageOffset}) =>
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedWave(
            animation: animation,
            height: height,
            offset: offset,
            pageOffset: pageOffset,
          ),
        ),
      );
}
