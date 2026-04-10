import '../entities/dish.dart';
import '../repositories/menu_repository.dart';

class GetDishesByCategory {
  final MenuRepository repository;
  const GetDishesByCategory(this.repository);

  List<Dish> call(DishCategory category) =>
      repository.getDishesByCategory(category);
}
