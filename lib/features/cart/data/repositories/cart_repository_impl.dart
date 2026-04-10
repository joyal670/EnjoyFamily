import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../../menu/domain/entities/dish.dart';

class CartRepositoryImpl implements CartRepository {
  final Map<String, CartItem> _items = {};

  @override
  List<CartItem> getItems() => _items.values.toList();

  @override
  int quantityOf(String dishId) => _items[dishId]?.quantity ?? 0;

  @override
  bool contains(String dishId) => _items.containsKey(dishId);

  @override
  void add(Dish dish, {int qty = 1}) {
    if (_items.containsKey(dish.id)) {
      _items[dish.id] = _items[dish.id]!
          .copyWith(quantity: _items[dish.id]!.quantity + qty);
    } else {
      _items[dish.id] = CartItem(dish: dish, quantity: qty);
    }
  }

  @override
  void remove(String dishId) => _items.remove(dishId);

  @override
  void setQuantity(String dishId, int qty) {
    if (qty <= 0) {
      remove(dishId);
      return;
    }
    if (_items.containsKey(dishId)) {
      _items[dishId] = _items[dishId]!.copyWith(quantity: qty);
    }
  }

  @override
  void clear() => _items.clear();
}
