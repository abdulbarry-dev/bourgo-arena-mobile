import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The initial splash and onboarding screen for Bourgo Arena.
class OnboardingScreen extends StatelessWidget {
  /// Creates an [OnboardingScreen].
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: spacing.screenPadding(context),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: spacing.xxxl),
                          const Center(
                            child: BrandLogo(
                              size: 160,
                              useVertical: true,
                              isPremium: true,
                              heroTag: 'app_logo',
                            ),
                          ),
                          SizedBox(height: spacing.xxl),
                          Text(
                            AppLocalizations.of(context)!.tagline.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4.0,
                            ),
                          ),
                          SizedBox(height: spacing.md),
                          Text(
                            AppLocalizations.of(context)!.onboardingTitle,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: spacing.lg),
                          Text(
                            AppLocalizations.of(context)!.onboardingSubtitle,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: spacing.xxl),
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.push('/register'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: spacing.lg,
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.commonStart,
                                  ),
                                ),
                              ),
                              SizedBox(height: spacing.md),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => context.push('/login'),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: spacing.lg,
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.authLogin,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
