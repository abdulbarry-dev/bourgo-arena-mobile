import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/book_child_session_use_case.dart';
import '../common/widgets/app_toast.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/child_selector_sheet.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/celebration_overlay.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/confirm_action_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course? course;
  final String courseId;

  const CourseDetailScreen({super.key, this.course, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late final CourseRepository _courseRepository;
  List<CourseSession> _sessions = [];
  bool _isLoading = true;
  String? _bookingSessionId;
  int _currentImageIndex = 0;
  bool _accessDenied = false;
  bool _showFamilyFeatures = false;
  String? _selectedChildId;

  Course? get _course => widget.course;

  @override
  void initState() {
    super.initState();
    _courseRepository = locator<CourseRepository>();
    _loadFamilyStatus();
    _loadSessions();
  }

  Future<void> _loadFamilyStatus() async {
    final userRepository = locator<UserRepository>();
    final result = await userRepository.getUserProfile();
    if (!mounted) return;
    result.when(
      success: (user) {
        final prefs = user.preferences ?? {};
        final familyEnabled = prefs['app']?['family_enabled'] as bool? ?? false;
        setState(() {
          _showFamilyFeatures =
              familyEnabled || user.isParentAccount || user.children.isNotEmpty;
        });
      },
      failure: (_) {},
    );
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _accessDenied = false;
    });
    final result = await _courseRepository.getCourseSessions(widget.courseId);
    result.when(
      success: (sessions) {
        if (mounted) {
          setState(() {
            _sessions = sessions;
            _isLoading = false;
          });
        }
      },
      failure: (failure) {
        if (mounted) {
          setState(() {
            _accessDenied = true;
            _isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _handleBookSession(CourseSession session) async {
    if (_bookingSessionId != null) return;

    if (_showFamilyFeatures) {
      final childId = await showChildSelectorSheet(context);
      if (!mounted) return;
      if (childId == kAddChildSentinel) {
        await context.push('/add-child');
        return;
      }
      _selectedChildId = childId;
    }

    final targetWeekday = session.dayOfWeek == 0
        ? DateTime.sunday
        : session.dayOfWeek;
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final nextDate = _findNextMatchingDate(today, targetWeekday);
    final dateStr =
        '${nextDate.year}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.day.toString().padLeft(2, '0')}';

    final confirmed = await _showBookingModal(context, session, nextDate);
    if (!confirmed || !mounted) return;

    setState(() => _bookingSessionId = session.id);

    if (_selectedChildId != null) {
      final childUseCase = locator<BookChildSessionUseCase>();
      final result = await childUseCase(
        childId: _selectedChildId!,
        sessionId: session.id,
        date: dateStr,
      );
      if (!mounted) return;
      setState(() => _bookingSessionId = null);
      result.when(
        success: (_) {
          CelebrationOverlay.show(context);
          AppToast.show(
            context,
            AppLocalizations.of(context)!.courseDetailBookedSession(
              session.title,
              dateStr,
              session.startTime,
            ),
            type: AppToastType.success,
          );
          _loadSessions();
        },
        failure: (f) {
          AppToast.show(
            context,
            f.message,
            type: AppToastType.error,
          );
        },
      );
      return;
    }

    final useCase = locator<BookCourseSessionUseCase>();
    final result = await useCase(widget.courseId, session.id, dateStr);
    if (!mounted) return;
    setState(() => _bookingSessionId = null);

    result.when(
      success: (_) {
        CelebrationOverlay.show(context);
        AppToast.show(
          context,
          AppLocalizations.of(context)!.courseDetailBookedSession(
            session.title,
            dateStr,
            session.startTime,
          ),
          type: AppToastType.success,
        );
        _loadSessions();
      },
      failure: (f) {
        AppToast.show(
          context,
          f.message,
          type: AppToastType.error,
        );
        _showSubscriptionGate();
      },
    );
  }

  void _showSubscriptionGate() {
    final theme = Theme.of(context);
    final isAuthenticated = locator<AuthStateNotifier>().isAuthenticated;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Icon(
            Symbols.lock,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.subscriptionRequiredTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        content: Text(
          isAuthenticated
              ? AppLocalizations.of(context)!.subscriptionRequiredBookMessage
              : AppLocalizations.of(context)!.subscriptionRequiredSignInMessage,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.push(isAuthenticated ? '/plans' : '/login');
              },
              child: Text(
                isAuthenticated
                    ? AppLocalizations.of(context)!.viewPlansButton
                    : AppLocalizations.of(context)!.signInButton,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showBookingModal(
    BuildContext context,
    CourseSession session,
    DateTime nextDate,
  ) async {
    final theme = Theme.of(context);
    final capitalDay = _formatDayName(session.dayOfWeek);
    final months = [
      AppLocalizations.of(context)!.monthJanuary,
      AppLocalizations.of(context)!.monthFebruary,
      AppLocalizations.of(context)!.monthMarch,
      AppLocalizations.of(context)!.monthApril,
      AppLocalizations.of(context)!.monthMay,
      AppLocalizations.of(context)!.monthJune,
      AppLocalizations.of(context)!.monthJuly,
      AppLocalizations.of(context)!.monthAugust,
      AppLocalizations.of(context)!.monthSeptember,
      AppLocalizations.of(context)!.monthOctober,
      AppLocalizations.of(context)!.monthNovember,
      AppLocalizations.of(context)!.monthDecember,
    ];
    final formattedDate =
        '$capitalDay ${nextDate.day} ${months[nextDate.month - 1]} ${nextDate.year}';

    return await ConfirmActionModal.show(
          context: context,
          icon: Symbols.event,
          title: AppLocalizations.of(context)!.reserveAction,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                session.title.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                  fontFamily: AppConstants.displayFontFamily,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                formattedDate,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${session.startTime} - ${session.endTime}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.7,
                  ),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _formatDayName(int dayOfWeek) {
    final raw = [
      AppLocalizations.of(context)!.daySunday,
      AppLocalizations.of(context)!.dayMonday,
      AppLocalizations.of(context)!.dayTuesday,
      AppLocalizations.of(context)!.dayWednesday,
      AppLocalizations.of(context)!.dayThursday,
      AppLocalizations.of(context)!.dayFriday,
      AppLocalizations.of(context)!.daySaturday,
    ];
    return raw[dayOfWeek];
  }

  DateTime _findNextMatchingDate(DateTime from, int targetWeekday) {
    var date = from;
    while (date.weekday != targetWeekday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => context.pop(),
            color: theme.colorScheme.onSurface,
          ),
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            widget.course?.name.toUpperCase() ??
                AppLocalizations.of(context)!.courseDefaultTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: _SessionSkeletonLoading(theme: theme),
      );
    }

    final images = _course?.images ?? [];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          _course?.name.toUpperCase() ??
              AppLocalizations.of(context)!.courseDefaultTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
            flexibleSpace: FlexibleSpaceBar(
              background: images.isNotEmpty
                  ? _buildImageCarousel(images, theme)
                  : _buildImagePlaceholder(theme),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_course != null) ...[
                    Text(
                      _course!.name.toUpperCase(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontFamily: AppConstants.displayFontFamily,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_course!.status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _course!.status == 'active'
                              ? theme.colorScheme.primary.withValues(alpha: 0.1)
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.1,
                                ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _course!.status!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _course!.status == 'active'
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    if (_course!.description != null &&
                        _course!.description!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        _course!.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                  if (_accessDenied)
                    _buildAccessDenied(theme)
                  else ...[
                    Text(
                      AppLocalizations.of(context)!.upcomingSessionsTitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ).animate().fade(duration: 300.ms).slideX(begin: -0.05),
                    const SizedBox(height: 12),
                    if (_sessions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.noUpcomingSessionsMessage,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    else
                      ...List.generate(_sessions.length, (i) {
                        return _SessionTile(
                              session: _sessions[i],
                              isBooking: _bookingSessionId == _sessions[i].id,
                              onBook: () => _handleBookSession(_sessions[i]),
                            )
                            .animate(delay: (i * 50).ms)
                            .fade(duration: 400.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            );
                      }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> images, ThemeData theme) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: (i) => setState(() => _currentImageIndex = i),
          itemBuilder: (_, i) => CachedNetworkImage(
            imageUrl: images[i],
            fit: BoxFit.cover,
            errorWidget: (_, _, _) =>
                Container(color: theme.colorScheme.surfaceContainerHighest),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentImageIndex == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == i
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

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Stack(
      children: [
        Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Icon(
              Symbols.school,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccessDenied(ThemeData theme) {
    final isAuthenticated = locator<AuthStateNotifier>().isAuthenticated;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Symbols.lock,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.subscriptionRequiredTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isAuthenticated
                ? AppLocalizations.of(
                    context,
                  )!.subscriptionRequiredViewBookMessage
                : AppLocalizations.of(
                    context,
                  )!.subscriptionRequiredSignInViewBookMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => isAuthenticated
                ? context.push('/plans')
                : context.push('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isAuthenticated
                  ? AppLocalizations.of(context)!.viewPlansButton
                  : AppLocalizations.of(context)!.signInButton,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final CourseSession session;
  final VoidCallback onBook;
  final bool isBooking;

  const _SessionTile({
    required this.session,
    required this.onBook,
    required this.isBooking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.bgBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(theme),
            Expanded(child: _buildContent(context, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    final hasImage = session.imageUrl != null && session.imageUrl!.isNotEmpty;

    return SizedBox(
      width: 88,
      child: hasImage
          ? PremiumNetworkImage(imageUrl: session.imageUrl!, fit: BoxFit.cover)
          : Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Symbols.school,
                size: 32,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            session.title.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: 0.5,
              color: theme.colorScheme.onSurface,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '${session.startTime} - ${session.endTime}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildCapacityBar(context, theme)),
              const SizedBox(width: 12),
              _buildActionButton(context, theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityBar(BuildContext context, ThemeData theme) {
    final ratio = session.capacity > 0
        ? session.enrolled / session.capacity
        : 0.0;
    final remaining = session.capacity - session.enrolled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 4,
            child: Row(
              children: [
                Flexible(
                  flex: (ratio * 100).round().clamp(1, 100),
                  child: Container(
                    color: session.isFull
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                ),
                Flexible(
                  flex: ((1 - ratio) * 100).round().clamp(1, 100),
                  child: Container(color: theme.colorScheme.outlineVariant),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          session.isBooked
              ? AppLocalizations.of(context)!.statusBooked
              : session.isFull
              ? AppLocalizations.of(context)!.statusFull
              : AppLocalizations.of(
                  context,
                )!.remainingPlaces(remaining.toString()),
          style: theme.textTheme.labelSmall?.copyWith(
            color: session.isBooked
                ? theme.colorScheme.primary
                : session.isFull
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            fontFamily: GoogleFonts.lexend().fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    if (session.isBooked) {
      return SizedBox(
        height: 32,
        child: OutlinedButton.icon(
          onPressed: null,
          icon: Icon(Symbols.check, size: 14),
          label: Text(AppLocalizations.of(context)!.statusBooked),
          style: OutlinedButton.styleFrom(
            disabledForegroundColor: theme.colorScheme.primary,
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              fontFamily: GoogleFonts.lexend().fontFamily,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: session.isFull || isBooking ? null : onBook,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            fontFamily: GoogleFonts.lexend().fontFamily,
          ),
        ),
        child: isBooking
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : Text(
                session.isFull
                    ? AppLocalizations.of(context)!.statusFull
                    : AppLocalizations.of(context)!.reserveAction,
              ),
      ),
    );
  }
}

class _SessionSkeletonLoading extends StatelessWidget {
  final ThemeData theme;

  const _SessionSkeletonLoading({required this.theme});

  @override
  Widget build(BuildContext context) {
    final appColors = theme.extension<AppColors>()!;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        _SkeletonShimmer(theme: theme, appColors: appColors),
        const SizedBox(height: 14),
        _SkeletonShimmer(theme: theme, appColors: appColors),
        const SizedBox(height: 14),
        _SkeletonShimmer(theme: theme, appColors: appColors),
      ],
    );
  }
}

class _SkeletonShimmer extends StatelessWidget {
  final ThemeData theme;
  final AppColors appColors;

  const _SkeletonShimmer({required this.theme, required this.appColors});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: appColors.bgBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 88, color: Colors.white),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 90,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
