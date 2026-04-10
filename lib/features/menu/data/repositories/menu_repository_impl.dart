import '../../domain/entities/dish.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_local_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuLocalDatasource datasource;
  const MenuRepositoryImpl(this.datasource);

  @override
  List<Dish> getAllDishes() => datasource.getAllDishes();

  @override
  List<Dish> getDishesByCategory(DishCategory category) =>
      datasource.getAllDishes().where((d) => d.category == category).toList();

  @override
  List<Dish> searchDishes(String query) {
    if (query.isEmpty) return datasource.getAllDishes();
    final q = query.toLowerCase();
    return datasource.getAllDishes()
        .where((d) =>
            d.name.toLowerCase().contains(q) ||
            d.description.toLowerCase().contains(q))
        .toList();
  }
}
