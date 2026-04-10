import '../repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;
  const RemoveFromCart(this.repository);

  void call(String dishId) => repository.remove(dishId);
}
