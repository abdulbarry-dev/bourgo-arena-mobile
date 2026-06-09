import 'package:flutter/widgets.dart';

class AppScrollPhysics extends BouncingScrollPhysics {
  const AppScrollPhysics({super.parent});

  @override
  AppScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return AppScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
    mass: 0.5,
    stiffness: 100.0,
    ratio: 1.1,
  );
}
