import '../entities/dish.dart';

abstract class MenuRepository {
  List<Dish> getAllDishes();
  List<Dish> getDishesByCategory(DishCategory category);
  List<Dish> searchDishes(String query);
}
