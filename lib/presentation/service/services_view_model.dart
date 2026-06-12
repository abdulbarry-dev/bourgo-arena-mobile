import 'dart:developer' as developer;

import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:flutter/material.dart';

enum ServicesLoadState { idle, loading, loaded, error, loadingMore }

enum ServiceFilterType { all, plans, courses, events }

class ServicesViewModel extends ChangeNotifier {
  final GetServicesUseCase _getServicesUseCase;

  List<Service> _allServices = [];
  ServicesLoadState _state = ServicesLoadState.idle;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  String _searchQuery = '';
  ServiceFilterType _filterType = ServiceFilterType.all;

  ServicesViewModel({required GetServicesUseCase getServicesUseCase})
    : _getServicesUseCase = getServicesUseCase {
    loadServices();
  }

  List<Service> get services => _getFilteredServices();
  ServicesLoadState get state => _state;
  bool get isLoading => _state == ServicesLoadState.loading;
  bool get isLoadingMore => _state == ServicesLoadState.loadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;
  ServiceFilterType get filterType => _filterType;

  List<Service> _getFilteredServices() {
    var result = _allServices.toList();

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where((s) => s.name.toLowerCase().contains(query))
          .toList();
    }

    switch (_filterType) {
      case ServiceFilterType.all:
        break;
      case ServiceFilterType.plans:
        result = result.where((s) => s.plansCount > 0).toList();
        break;
      case ServiceFilterType.courses:
        result = result.where((s) => s.coursesCount > 0).toList();
        break;
      case ServiceFilterType.events:
        result = result.where((s) => s.eventsCount > 0).toList();
        break;
    }

    return result;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterType(ServiceFilterType type) {
    _filterType = type;
    notifyListeners();
  }

  Future<void> loadServices() async {
    _state = ServicesLoadState.loading;
    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    final result = await _getServicesUseCase(page: _currentPage);
    result.when(
      success: (services) {
        _allServices = services;
        _hasMore = services.length >= 15;
        _state = ServicesLoadState.loaded;
      },
      failure: (failure) {
        developer.log('ServicesViewModel: ${failure.message}');
        _errorMessage = failure.message;
        _state = ServicesLoadState.error;
      },
    );
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !_hasMore) return;
    _state = ServicesLoadState.loadingMore;
    notifyListeners();

    final nextPage = _currentPage + 1;
    final result = await _getServicesUseCase(page: nextPage);
    result.when(
      success: (services) {
        _allServices.addAll(services);
        _currentPage = nextPage;
        _hasMore = services.length >= 15;
        _state = ServicesLoadState.loaded;
      },
      failure: (failure) {
        developer.log('ServicesViewModel loadMore: ${failure.message}');
        _state = ServicesLoadState.loaded;
      },
    );
    notifyListeners();
  }
}
