import '../entities/dish.dart';
import '../repositories/menu_repository.dart';

class SearchDishes {
  final MenuRepository repository;
  const SearchDishes(this.repository);

  List<Dish> call(String query) => repository.searchDishes(query);
}
