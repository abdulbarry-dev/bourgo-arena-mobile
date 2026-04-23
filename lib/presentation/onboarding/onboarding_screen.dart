import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The initial splash and onboarding screen for Bourgo Arena.
class OnboardingScreen extends StatelessWidget {
  /// Creates an [OnboardingScreen].
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Background - In a real app, use an Image.asset with BoxFit.cover
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F1A00), // Tinted dark green
                  BourgoTheme.bgBase,
                ],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 3),
                  
                  // Brand Logotype
                  _BrandLogotype(),
                  
                  const SizedBox(height: 12),
                  
                  // Tagline
                  Text(
                    AppConstants.tagline.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                    ),
                  ),
                  
                  const Spacer(flex: 5),
                  
                  // Action Button
                  ElevatedButton(
                    onPressed: () => context.push('/login'),
                    child: const Text('COMMENCER'),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandLogotype extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BOURGO',
          style: theme.textTheme.displayLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        Text(
          'ARENA',
          style: theme.textTheme.displayLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
