import 'package:flutter/material.dart';

const double listWidth = 250;

Widget myVerticalDivider = VerticalDivider(
  width: 2,
  thickness: 1.5,
);

Widget myTabletContainer({Widget child}) {
  return Container(
    width: 500,
    child: child,
  );
}

class MyLayoutBuilder extends StatelessWidget {
  const MyLayoutBuilder({
    Key key,
    @required Widget mobileLayout,
    @required Widget tabletLayout,
  })  : _mobileLayout = mobileLayout,
        _tabletLayout = tabletLayout,
        super(key: key);

  final Widget _mobileLayout;
  final Widget _tabletLayout;

  static bool useMobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              if (constraints.maxWidth < 600) {
                useMobile = true;
                return _mobileLayout;
              } else {
                useMobile = false;
                return _tabletLayout;
              }
            } else {
              if (constraints.maxWidth < 800) {
                useMobile = true;
                return _mobileLayout;
              } else {
                useMobile = false;
                return _tabletLayout;
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
    Key key,
    @required Widget mobileLayout,
    @required Widget tabletLayout,
  })  : _mobileLayout = mobileLayout,
        _tabletLayout = tabletLayout,
        super(key: key);

  final Widget _mobileLayout;
  final Widget _tabletLayout;

  @override
  Widget build(BuildContext context) {
    if (MyLayoutBuilder.useMobile) {
      return _mobileLayout;
    } else {
      return _tabletLayout;
    }
  }
}
