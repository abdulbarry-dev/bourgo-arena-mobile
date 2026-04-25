import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Profile screen.
class ProfileViewModel extends ChangeNotifier {
  final DataService _dataService;

  UserProfile? _profile;
  bool _isLoading = false;

  /// The user's profile data.
  UserProfile? get profile => _profile;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Creates a new [ProfileViewModel] instance.
  ProfileViewModel({required DataService dataService})
    : _dataService = dataService {
    loadProfile();
  }

  /// Loads the user profile from the data service.
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _dataService.getUserProfile();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
