import '../entities/dish.dart';
import '../repositories/menu_repository.dart';

class GetAllDishes {
  final MenuRepository repository;
  const GetAllDishes(this.repository);

  List<Dish> call() => repository.getAllDishes();
}
