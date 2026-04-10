import '../repositories/cart_repository.dart';

class ClearCart {
  final CartRepository repository;
  const ClearCart(this.repository);

  void call() => repository.clear();
}
