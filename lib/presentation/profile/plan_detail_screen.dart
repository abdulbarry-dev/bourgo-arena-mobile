import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_plan_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/buy_child_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/subscribe_to_plan_use_case.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/child_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';

class PlanDetailScreen extends StatefulWidget {
  final String planId;
  final Plan? plan;
  final String? childId;

  const PlanDetailScreen({
    super.key,
    required this.planId,
    this.plan,
    this.childId,
  });

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  Plan? _plan;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isSubscribing = false;
  int _currentImageIndex = 0;
  String? _selectedChildId;
  bool _showFamilyFeatures = false;
  bool _isLoadingUser = true;
  List<Subscription> _activeSubscriptions = [];
  Map<String, Subscription> _childSubscriptions = {};

  @override
  void initState() {
    super.initState();
    _selectedChildId = widget.childId;
    _loadUser();
    _loadActiveSubscriptions();
    if (widget.plan != null) {
      _plan = widget.plan;
      _isLoading = false;
    } else {
      _loadPlan();
    }
  }

  Future<void> _loadActiveSubscriptions() async {
    final useCase = locator<GetActiveSubscriptionsUseCase>();
    final result = await useCase.execute();
    if (!mounted) return;
    result.when(
      success: (subs) {
        setState(() {
          _activeSubscriptions = subs;
        });
      },
      failure: (_) {},
    );
  }

  Future<void> _loadUser() async {
    final userRepository = locator<UserRepository>();
    final result = await userRepository.getUserProfile();
    if (!mounted) return;
    result.when(
      success: (user) {
        final prefs = user.preferences ?? {};
        final familyEnabled = prefs['app']?['family_enabled'] as bool? ?? false;
        final childSubs = <String, Subscription>{};
        for (final child in user.children) {
          if (child.hasActiveSubscription && child.activeSubscription != null) {
            childSubs[child.id] = child.activeSubscription!;
          }
        }
        setState(() {
          _showFamilyFeatures =
              familyEnabled || user.isParentAccount || user.children.isNotEmpty;
          _childSubscriptions = childSubs;
          _isLoadingUser = false;
        });
      },
      failure: (_) {
        setState(() {
          _showFamilyFeatures = false;
          _isLoadingUser = false;
        });
      },
    );
  }

  Future<void> _loadPlan() async {
    final repository = locator<ApiPlanRepository>();
    final result = await repository.getPlanDetails(widget.planId);
    result.when(
      success: (plan) {
        setState(() {
          _plan = plan;
          _isLoading = false;
        });
      },
      failure: (failure) {
        setState(() {
          _errorMessage = failure.message;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _subscribe() async {
    if (_plan == null || _isSubscribing) return;

    setState(() => _isSubscribing = true);

    if (_selectedChildId != null) {
      final buyChildUseCase = locator<BuyChildSubscriptionUseCase>();
      final result = await buyChildUseCase(
        childId: _selectedChildId!,
        planId: _plan!.id,
      );

      if (!mounted) return;

      result.when(
        success: (subscription) {
          setState(() => _isSubscribing = false);
          context.push(
            '/payment-selection',
            extra: {
              'plan': _plan,
              'subscription': subscription,
              'childId': _selectedChildId,
            },
          );
        },
        failure: (failure) {
          setState(() => _isSubscribing = false);
          _showErrorSnackBar(failure.message);
        },
      );
      return;
    }

    final subscribeUseCase = locator<SubscribeToPlanUseCase>();
    final result = await subscribeUseCase(_plan!.id);

    if (!mounted) return;

    result.when(
      success: (subscription) {
        setState(() => _isSubscribing = false);
        context.push(
          '/payment-selection',
          extra: {'plan': _plan, 'subscription': subscription},
        );
      },
      failure: (failure) {
        setState(() => _isSubscribing = false);
        if (_isChildOnlyPlanError(failure)) {
          _showChildOnlyPlanDialog();
        } else {
          _showErrorSnackBar(failure.message);
        }
      },
    );
  }

  bool _isChildOnlyPlanError(Failure failure) {
    if (failure is! ValidationFailure) return false;
    final msg = failure.message.toLowerCase();
    return msg.contains('children only') || msg.contains('child only');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _showChildOnlyPlanDialog() async {
    final theme = Theme.of(context);

    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Symbols.child_care,
              size: 24,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Child-Only Plan',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        content: Text(
          'This plan is designed for children only. '
          'Select a child to purchase this plan for them.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'select_child'),
            child: const Text('SELECT A CHILD'),
          ),
        ],
      ),
    );

    if (action != 'select_child' || !mounted) return;

    final childId = await showChildSelectorSheet(context);
    if (!mounted || childId == null) return;

    if (childId == kAddChildSentinel) {
      await context.push('/add-child');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Child added. Please select them to continue.'),
        ),
      );
      return;
    }

    _retrySubscribeForChild(childId);
  }

  Future<void> _retrySubscribeForChild(String childId) async {
    setState(() {
      _isSubscribing = true;
      _selectedChildId = childId;
    });

    final buyChildUseCase = locator<BuyChildSubscriptionUseCase>();
    final result = await buyChildUseCase(childId: childId, planId: _plan!.id);

    if (!mounted) return;

    result.when(
      success: (subscription) {
        setState(() => _isSubscribing = false);
        context.push(
          '/payment-selection',
          extra: {
            'plan': _plan,
            'subscription': subscription,
            'childId': childId,
          },
        );
      },
      failure: (failure) {
        setState(() => _isSubscribing = false);
        _showErrorSnackBar(failure.message);
      },
    );
  }

  List<String> get _images {
    final images = _plan?.service?.images;
    if (images != null && images.isNotEmpty) return images;
    final imageUrl = _plan?.service?.imageUrl;
    if (imageUrl != null) return [imageUrl];
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    if (_isLoading || _isLoadingUser) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const SubScreenAppBar(title: 'PLAN DETAILS'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SubScreenAppBar(title: (_plan?.name ?? '').toUpperCase()),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildError(theme)
          : _plan == null
          ? _buildNotFound(theme)
          : _buildContent(theme, appColors),
    );
  }

  Widget _buildContent(ThemeData theme, AppColors appColors) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 300, child: _buildImageCarousel(theme)),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_plan!.service != null)
                        _buildServiceBadge(theme, appColors)
                            .animate(delay: 50.ms)
                            .fade(duration: 400.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            ),
                      const SizedBox(height: 16),
                      Text(
                            _plan!.name.toUpperCase(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: AppConstants.displayFontFamily,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.onSurface,
                            ),
                          )
                          .animate(delay: 100.ms)
                          .fade(duration: 400.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 12),
                      Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${_plan!.price.toStringAsFixed(0)} TND',
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              if (_plan!.durationDays != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '/ ${_plan!.durationDays} DAYS',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ],
                          )
                          .animate(delay: 150.ms)
                          .fade(duration: 400.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 32),
                      Text(
                            'INCLUDES',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          )
                          .animate(delay: 200.ms)
                          .fade(duration: 400.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 16),
                      if (_plan!.service != null)
                        _buildFeatureRow(
                              theme,
                              Symbols.category,
                              'Service: ${_plan!.service!.name}',
                            )
                            .animate(delay: 250.ms)
                            .fade(duration: 400.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            ),
                      if (_plan!.hasAllCourses)
                        _buildFeatureRow(
                              theme,
                              Symbols.all_inclusive,
                              'Access to ALL courses',
                            )
                            .animate(delay: 300.ms)
                            .fade(duration: 400.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            ),
                      if (_plan!.service?.description != null &&
                          _plan!.service!.description!.isNotEmpty)
                        _buildFeatureRow(
                              theme,
                              Symbols.info,
                              _plan!.service!.description!,
                            )
                            .animate(delay: 350.ms)
                            .fade(duration: 400.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            ),
                      const SizedBox(height: 40),
                      if (_showFamilyFeatures) ...[
                        _buildForWhom(theme, appColors),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: _buildCTA(theme)
              .animate(delay: 400.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(ThemeData theme) {
    if (_images.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Symbols.workspace_premium,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: _images.length,
          onPageChanged: (index) {
            setState(() => _currentImageIndex = index);
          },
          itemBuilder: (context, index) {
            return Image.network(
              _images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentImageIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? theme.colorScheme.primary
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildServiceBadge(ThemeData theme, AppColors appColors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.bolt, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            _plan!.service!.name?.toUpperCase() ?? 'SERVICE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForWhom(ThemeData theme, AppColors appColors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final childId = await showChildSelectorSheet(context);
          if (childId != _selectedChildId) {
            setState(() => _selectedChildId = childId);
          }
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                _selectedChildId == null ? Symbols.person : Symbols.child_care,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SUBSCRIBE FOR',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedChildId == null ? 'Myself' : 'Child',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Symbols.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA(ThemeData theme) {
    final appColors = theme.extension<AppColors>()!;
    bool isAlreadySubscribed = false;
    if (_plan != null) {
      if (_selectedChildId != null) {
        final childSub = _childSubscriptions[_selectedChildId];
        isAlreadySubscribed =
            childSub != null && childSub.plan?.id == _plan!.id;
      } else {
        isAlreadySubscribed = _activeSubscriptions.any(
          (sub) => sub.plan?.id == _plan!.id,
        );
      }
    }

    if (isAlreadySubscribed) {
      return Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: appColors.statusSuccess.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.statusSuccess),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.check_circle, color: appColors.statusSuccess),
              const SizedBox(width: 8),
              Text(
                'ACTIVE PLAN',
                style: TextStyle(
                  color: appColors.statusSuccess,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: _isSubscribing ? null : _subscribe,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        disabledBackgroundColor: theme.colorScheme.primary.withValues(
          alpha: 0.4,
        ),
      ),
      child: _isSubscribing
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : Text(
              'SUBSCRIBE  —  ${_plan!.price.toStringAsFixed(0)} TND',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.error, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Something went wrong',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _loadPlan();
              },
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFound(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.search_off,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Plan not found',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontFamily: AppConstants.displayFontFamily,
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This plan may have been archived or removed.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('GO BACK'),
            ),
          ],
        ),
      ),
    );
  }
}
