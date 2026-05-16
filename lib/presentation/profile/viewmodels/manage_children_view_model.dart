import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_child_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for managing children profiles.
class ManageChildrenViewModel extends ChangeNotifier {
  final GetChildrenUseCase _getChildrenUseCase;
  final RemoveChildUseCase _removeChildUseCase;

  List<ChildProfile> _children = [];
  bool _isLoading = false;
  String? _errorMessage;

  ManageChildrenViewModel({
    required GetChildrenUseCase getChildrenUseCase,
    required RemoveChildUseCase removeChildUseCase,
  }) : _getChildrenUseCase = getChildrenUseCase,
       _removeChildUseCase = removeChildUseCase {
    _loadChildren();
  }

  List<ChildProfile> get children => _children;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Public method to reload children list from external triggers
  Future<void> reloadChildren() async {
    await _loadChildren();
  }

  Future<void> _loadChildren() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getChildrenUseCase.execute();
      result.when(
        success: (children) {
          _children = children;
          _errorMessage = null;
        },
        failure: (failure) {
          _errorMessage = failure.message;
          developer.log('Failed to load children: ${failure.message}');
        },
      );
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      developer.log('Error loading children: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeChild(String childId) async {
    try {
      final result = await _removeChildUseCase.execute(childId);
      bool success = false;
      result.when(
        success: (_) {
          _children.removeWhere((child) => child.id == childId);
          success = true;
          _errorMessage = null;
          notifyListeners();
        },
        failure: (failure) {
          _errorMessage = failure.message;
          developer.log('Failed to remove child: ${failure.message}');
        },
      );
      return success;
    } catch (e) {
      _errorMessage = 'Failed to remove child';
      developer.log('Error removing child: $e');
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
