import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/data/models/food_item.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:flutter/material.dart';

/// ViewModel managing the food menu state.
class FoodViewModel extends ChangeNotifier {
  final DataService _dataService;
  List<FoodItem> _items = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = AppConstants.foodCategoryAll;
  final List<FoodItem> _cart = [];

  FoodViewModel({required DataService dataService})
    : _dataService = dataService;

  List<FoodItem> get cart => List.unmodifiable(_cart);
  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.price);

  List<FoodItem> get items {
    if (_selectedCategory == AppConstants.foodCategoryAll) return _items;
    return _items.where((i) => i.category == _selectedCategory).toList();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  List<String> get categories => [
    AppConstants.foodCategoryAll,
    AppConstants.foodCategoryHealthy,
    AppConstants.foodCategoryDrinks,
    AppConstants.foodCategoryDishes,
    AppConstants.foodCategorySnacks,
  ];

  Future<void> loadMenu() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _dataService.getFoodMenu();
      _isLoading = false;
    } catch (e) {
      _error = AppConstants.foodLoadError;
      _isLoading = false;
    }
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addToCart(FoodItem item) {
    _cart.add(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
