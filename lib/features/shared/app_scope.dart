import 'package:flutter/material.dart';

class YallaScope extends InheritedWidget {
  const YallaScope({
    required this.cartCount,
    required this.updateCart,
    required super.child,
    super.key,
  });

  final int cartCount;
  final ValueChanged<int> updateCart;

  static YallaScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<YallaScope>()!;

  @override
  bool updateShouldNotify(YallaScope oldWidget) =>
      cartCount != oldWidget.cartCount;
}
