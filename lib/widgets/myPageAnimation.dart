import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';

class MyPageAnimation extends StatelessWidget {
  const MyPageAnimation({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      // key: key,
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          // key: key,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: child,
    );
  }
}
