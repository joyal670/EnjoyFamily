import '../../../menu/domain/entities/dish.dart';

class CartItem {
  final Dish dish;
  final int quantity;

  const CartItem({required this.dish, required this.quantity});

  CartItem copyWith({int? quantity}) =>
      CartItem(dish: dish, quantity: quantity ?? this.quantity);

  double get subtotal => dish.price * quantity;
}
