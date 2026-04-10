import '../repositories/cart_repository.dart';

class UpdateQuantity {
  final CartRepository repository;
  const UpdateQuantity(this.repository);

  void call(String dishId, int qty) => repository.setQuantity(dishId, qty);
}
