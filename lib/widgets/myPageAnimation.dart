import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';

class MyPageAnimation extends StatelessWidget {
  const MyPageAnimation({
    super.key,
    required Widget child,
  }) : _child = child;
  final Widget _child;
  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
          Widget _child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: _child,
        );
      },
      child: _child,
    );
  }
}