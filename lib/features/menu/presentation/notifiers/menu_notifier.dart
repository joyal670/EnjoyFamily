import 'package:flutter/material.dart';
import '../../domain/entities/dish.dart';
import '../../domain/usecases/get_all_dishes.dart';
import '../../domain/usecases/get_dishes_by_category.dart';
import '../../domain/usecases/search_dishes.dart';

class MenuNotifier extends ChangeNotifier {
  final GetAllDishes _getAllDishes;
  final GetDishesByCategory _getDishesByCategory;
  final SearchDishes _searchDishes;

  DishCategory? selectedCategory;
  String searchQuery = '';

  MenuNotifier({
    required GetAllDishes getAllDishes,
    required GetDishesByCategory getDishesByCategory,
    required SearchDishes searchDishes,
  })  : _getAllDishes = getAllDishes,
        _getDishesByCategory = getDishesByCategory,
        _searchDishes = searchDishes;

  List<Dish> get dishes {
    if (searchQuery.isNotEmpty) return _searchDishes(searchQuery);
    if (selectedCategory != null) return _getDishesByCategory(selectedCategory!);
    return _getAllDishes();
  }

  void selectCategory(DishCategory? category) {
    selectedCategory = category;
    searchQuery = '';
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    searchQuery = '';
    notifyListeners();
  }
}
