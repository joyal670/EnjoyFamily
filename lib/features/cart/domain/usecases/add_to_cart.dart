import '../repositories/cart_repository.dart';
import '../../../menu/domain/entities/dish.dart';

class AddToCart {
  final CartRepository repository;
  const AddToCart(this.repository);

  void call(Dish dish, {int qty = 1}) => repository.add(dish, qty: qty);
}
