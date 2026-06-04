import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/auth_required_modal.dart';
import 'package:flutter/material.dart';

/// Checks if the user is authenticated.
/// If not, it shows the Auth Required Modal and returns false.
/// If authenticated, it returns true.
bool ensureAuthenticated(BuildContext context) {
  final authState = locator<AuthStateNotifier>().state;
  if (authState == AuthState.unauthenticated) {
    showAuthRequiredModal(context);
    return false;
  }
  return true;
}
