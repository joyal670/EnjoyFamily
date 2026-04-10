import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/remove_from_cart.dart';
import '../../domain/usecases/update_quantity.dart';
import '../../domain/usecases/clear_cart.dart';
import '../../../menu/domain/entities/dish.dart';

class CartNotifier extends ChangeNotifier {
  final AddToCart _addToCart;
  final RemoveFromCart _removeFromCart;
  final UpdateQuantity _updateQuantity;
  final ClearCart _clearCart;
  final CartRepository _repository;

  CartNotifier({
    required AddToCart addToCart,
    required RemoveFromCart removeFromCart,
    required UpdateQuantity updateQuantity,
    required ClearCart clearCart,
    required CartRepository repository,
  })  : _addToCart = addToCart,
        _removeFromCart = removeFromCart,
        _updateQuantity = updateQuantity,
        _clearCart = clearCart,
        _repository = repository;

  List<CartItem> get items => _repository.getItems();
  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get deliveryFee => subtotal > 0 ? 5.0 : 0.0;
  double get total => subtotal + deliveryFee;
  int quantityOf(String dishId) => _repository.quantityOf(dishId);
  bool contains(String dishId) => _repository.contains(dishId);

  void add(Dish dish, {int qty = 1}) {
    _addToCart(dish, qty: qty);
    notifyListeners();
  }

  void remove(String dishId) {
    _removeFromCart(dishId);
    notifyListeners();
  }

  void setQuantity(String dishId, int qty) {
    _updateQuantity(dishId, qty);
    notifyListeners();
  }

  void clear() {
    _clearCart();
    notifyListeners();
  }
}
