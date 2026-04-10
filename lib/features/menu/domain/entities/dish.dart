import 'package:flutter/material.dart';

enum DishCategory {
  breakfast,
  tandooriFusion,
  biryaniRice,
  chinese,
  beverages;

  String get label {
    switch (this) {
      case DishCategory.breakfast: return 'Breakfast';
      case DishCategory.tandooriFusion: return 'Tandoori Fusion';
      case DishCategory.biryaniRice: return 'Biryani & Rice';
      case DishCategory.chinese: return 'Chinese';
      case DishCategory.beverages: return 'Beverages';
    }
  }

  IconData get tabIcon {
    switch (this) {
      case DishCategory.breakfast: return Icons.breakfast_dining_rounded;
      case DishCategory.tandooriFusion: return Icons.local_fire_department_rounded;
      case DishCategory.biryaniRice: return Icons.rice_bowl_rounded;
      case DishCategory.chinese: return Icons.ramen_dining_rounded;
      case DishCategory.beverages: return Icons.local_drink_rounded;
    }
  }
}

class Dish {
  final String id;
  final String name;
  final String description;
  final String longDescription;
  final double price;
  final DishCategory category;
  final int spiceLevel;
  final bool isVeg;
  final IconData icon;
  final List<Color> gradientColors;
  final String prepTime;
  final List<String> highlights;

  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.longDescription,
    required this.price,
    required this.category,
    required this.spiceLevel,
    required this.isVeg,
    required this.icon,
    required this.gradientColors,
    required this.prepTime,
    required this.highlights,
  });

  String get priceLabel => 'AED ${price.toStringAsFixed(0)}';
}
