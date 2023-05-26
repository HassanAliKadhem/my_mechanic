import 'package:flutter/material.dart';

const double listWidth = 250;

Widget myVerticalDivider = VerticalDivider(
  width: 2,
  thickness: 1.5,
);

Widget myTabletContainer({Widget? child}) {
  return Container(
    width: 500,
    child: child,
  );
}

class MyLayoutBuilder extends StatelessWidget {
  const MyLayoutBuilder({
    super.key,
    required this.mobileLayout,
    required this.tabletLayout,
  });

  final Widget mobileLayout;
  final Widget tabletLayout;

  static bool useMobile = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              if (constraints.maxWidth < 600) {
                useMobile = true;
                return mobileLayout;
              } else {
                useMobile = false;
                return tabletLayout;
              }
            } else {
              if (constraints.maxWidth < 800) {
                useMobile = true;
                return mobileLayout;
              } else {
                useMobile = false;
                return tabletLayout;
              }
            }
          },
        );
      },
    );
  }
}

class MyLayoutBuilderPages extends StatelessWidget {
  const MyLayoutBuilderPages({
    super.key,
    required this.mobileLayout,
    required this.tabletLayout,
  });

  final Widget mobileLayout;
  final Widget tabletLayout;

  @override
  Widget build(BuildContext context) {
    if (MyLayoutBuilder.useMobile) {
      return mobileLayout;
    } else {
      return tabletLayout;
    }
  }
}
