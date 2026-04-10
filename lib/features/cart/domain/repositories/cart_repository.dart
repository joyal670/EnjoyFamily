import '../../domain/entities/cart_item.dart';
import '../../../menu/domain/entities/dish.dart';

abstract class CartRepository {
  List<CartItem> getItems();
  int quantityOf(String dishId);
  bool contains(String dishId);
  void add(Dish dish, {int qty = 1});
  void remove(String dishId);
  void setQuantity(String dishId, int qty);
  void clear();
}
