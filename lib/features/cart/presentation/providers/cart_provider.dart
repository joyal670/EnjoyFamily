import 'package:flutter/material.dart';
import '../notifiers/cart_notifier.dart';

class CartProvider extends InheritedNotifier<CartNotifier> {
  CartProvider({
    super.key,
    required CartNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static CartNotifier of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CartProvider>()!.notifier!;
}
