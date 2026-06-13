import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member.dart';
import 'package:bourgo_arena_mobile/domain/repositories/user_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/event_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import '../common/widgets/app_toast.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/celebration_overlay.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/child_selector_sheet.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_error_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/confirm_action_modal.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  final Event? event;

  const EventDetailScreen({super.key, required this.eventId, this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event? _event;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isActionLoading = false;
  bool _isRegistered = false;
  bool _isCheckedIn = false;
  int _currentImageIndex = 0;
  bool _showFamilyFeatures = false;
  List<FamilyMember> _familyMembers = [];
  FamilyMember? _selectedMember;
  List<EventParticipant> _allRegistrations = [];

  @override
  void initState() {
    super.initState();
    _loadFamilyStatus();
    if (widget.event != null) {
      _event = widget.event;
      _isRegistered = widget.event!.isRegistered;
      _isLoading = false;
    } else {
      _loadEvent();
    }
  }

  Future<void> _loadFamilyStatus() async {
    final userRepository = locator<UserRepository>();
    final userResult = await userRepository.getUserProfile();
    if (!mounted) return;

    bool familyEnabled = false;
    userResult.when(
      success: (user) {
        final prefs = user.preferences ?? {};
        final familyEnabledVal =
            prefs['app']?['family_enabled'] as bool? ?? false;
        familyEnabled =
            familyEnabledVal ||
            user.isParentAccount ||
            user.children.isNotEmpty;
      },
      failure: (_) {},
    );

    if (familyEnabled) {
      final membersResult = await locator<GetFamilyMembersUseCase>()();
      final regsResult = await locator<EventRepository>()
          .getAccountRegistrations();
      if (!mounted) return;

      List<FamilyMember> members = [];
      membersResult.when(success: (m) => members = m, failure: (_) {});

      List<EventParticipant> regs = [];
      regsResult.when(success: (r) => regs = r, failure: (_) {});

      setState(() {
        _showFamilyFeatures = true;
        _familyMembers = members;
        _allRegistrations = regs;
        if (members.isNotEmpty) {
          _selectedMember = members.firstWhere(
            (m) => m.isPrimary,
            orElse: () => members.first,
          );
        }
        _updateSelectedMemberStatus();
      });
    } else {
      final regsResult = await locator<EventRepository>()
          .getAccountRegistrations();
      if (!mounted) return;
      regsResult.when(
        success: (r) {
          setState(() {
            _allRegistrations = r;
            _updateSelectedMemberStatus();
          });
        },
        failure: (_) {},
      );
    }
  }

  void _updateSelectedMemberStatus() {
    if (_event == null) return;
    final member = _selectedMember;

    if (!_showFamilyFeatures || member == null) {
      _isRegistered = _event!.isRegistered;
      _isCheckedIn = false;
    }

    final matchId = member?.id ?? '';
    final reg = _allRegistrations.firstWhere(
      (r) =>
          r.eventId == _event!.id &&
          ((member == null && r.user != null) ||
              (member != null && r.user?.id.toString() == matchId.toString())),
      orElse: () => const EventParticipant(id: -1, eventId: ''),
    );

    if (reg.id != -1) {
      _isRegistered = true;
      _isCheckedIn = reg.hasCheckedIn;
    } else if (_showFamilyFeatures && member != null) {
      if (member.isPrimary) {
        _isRegistered = _event!.isRegistered;
        _isCheckedIn = false;
      } else {
        _isRegistered = false;
        _isCheckedIn = false;
      }
    }
  }

  void _onEventLoaded(Event event) {
    _event = event;
    _isRegistered = event.isRegistered;
    _updateSelectedMemberStatus();
  }

  Future<void> _loadEvent() async {
    final useCase = locator<GetEventByIdUseCase>();
    final result = await useCase(widget.eventId);
    result.when(
      success: (event) => setState(() {
        _onEventLoaded(event);
        _isLoading = false;
      }),
      failure: (f) => setState(() {
        _errorMessage = f.message;
        _isLoading = false;
      }),
    );
  }

  Future<void> _register() async {
    if (_event == null || _isActionLoading) return;

    final theme = Theme.of(context);
    final memberName =
        _selectedMember?.name ?? AppLocalizations.of(context)!.planDetailMyself;
    final confirmed = await ConfirmActionModal.show(
      context: context,
      icon: Symbols.emoji_events,
      title:
          '${AppLocalizations.of(context)!.eventsDetailRegisterTitle} for $memberName',
      content: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _event!.name?.toUpperCase() ??
                  AppLocalizations.of(context)!.eventsDetailEventFallback,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                fontFamily: AppConstants.displayFontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _infoRow(theme, Symbols.calendar_month, _formatDateRange(context)),
            const SizedBox(height: 8),
            _infoRow(
              theme,
              Symbols.group,
              '${_event!.participantsCount ?? 0} / ${_event!.maxParticipants ?? 0} ${AppLocalizations.of(context)!.eventsDetailParticipantsText}',
            ),
          ],
        ),
      ),
    );
    if (confirmed != true) return;
    setState(() => _isActionLoading = true);

    final childId = _selectedMember?.isPrimary == true
        ? null
        : _selectedMember?.id;
    final result = await locator<RegisterForEventUseCase>()(
      _event!.id,
      childId: childId,
    );
    if (!mounted) return;
    setState(() => _isActionLoading = false);
    result.when(
      success: (reg) async {
        final regsResult = await locator<EventRepository>()
            .getAccountRegistrations();
        if (!mounted) return;

        regsResult.when(
          success: (r) {
            setState(() {
              _allRegistrations = r;
              _updateSelectedMemberStatus();
            });
          },
          failure: (_) {},
        );

        if (reg.isWaitlisted) {
          AppToast.show(
            context,
            AppLocalizations.of(context)!.eventsDetailWaitlistSuccess,
            type: AppToastType.info,
          );
        } else {
          CelebrationOverlay.show(context);
          AppToast.show(
            context,
            AppLocalizations.of(context)!.eventsDetailRegisterSuccess,
            type: AppToastType.success,
          );
        }
      },
      failure: (f) {
        if (f.message.contains('Already registered')) {
          setState(() {
            _isRegistered = true;
          });
          AppToast.show(
            context,
            AppLocalizations.of(context)!.eventsDetailRegisterSuccess,
            type: AppToastType.success,
          );
          _loadEvent();
          return;
        }

        AppToast.show(
          context,
          f.message,
          type: AppToastType.error,
        );
      },
    );
  }

  Future<void> _withdraw() async {
    if (_event == null || _isActionLoading) return;

    final memberName =
        _selectedMember?.name ?? AppLocalizations.of(context)!.planDetailMyself;
    final confirmed = await ConfirmActionModal.show(
      context: context,
      icon: Symbols.cancel,
      title: AppLocalizations.of(context)!.eventsDetailWithdrawTitle,
      message:
          '${AppLocalizations.of(context)!.eventsDetailWithdrawPromptPrefix} $memberName from ${_event!.name ?? AppLocalizations.of(context)!.eventsDetailThisEvent} ?',
      isDestructive: true,
    );

    if (confirmed != true) return;
    setState(() => _isActionLoading = true);

    final childId = _selectedMember?.isPrimary == true
        ? null
        : _selectedMember?.id;
    final result = await locator<WithdrawFromEventUseCase>()(
      _event!.id,
      childId: childId,
    );
    if (!mounted) return;
    setState(() => _isActionLoading = false);
    result.when(
      success: (_) async {
        final regsResult = await locator<EventRepository>()
            .getAccountRegistrations();
        if (!mounted) return;

        regsResult.when(
          success: (r) {
            setState(() {
              _allRegistrations = r;
              _updateSelectedMemberStatus();
            });
          },
          failure: (_) {},
        );
        AppToast.show(
          context,
          AppLocalizations.of(context)!.eventsDetailWithdrawSuccess,
          type: AppToastType.success,
        );
      },
      failure: (f) {
        AppToast.show(
          context,
          f.message,
          type: AppToastType.error,
        );
      },
    );
  }

  Future<void> _checkIn() async {
    if (_event == null || _isActionLoading) return;
    setState(() => _isActionLoading = true);

    final childId = _selectedMember?.isPrimary == true
        ? null
        : _selectedMember?.id;
    final result = await locator<CheckInToEventUseCase>()(
      _event!.id,
      childId: childId,
    );
    if (!mounted) return;
    setState(() => _isActionLoading = false);
    result.when(
      success: (_) async {
        final regsResult = await locator<EventRepository>()
            .getAccountRegistrations();
        if (!mounted) return;

        regsResult.when(
          success: (r) {
            setState(() {
              _allRegistrations = r;
              _updateSelectedMemberStatus();
            });
          },
          failure: (_) {},
        );
        AppToast.show(
          context,
          AppLocalizations.of(context)!.eventsDetailCheckInSuccess,
          type: AppToastType.success,
        );
      },
      failure: (f) {
        AppToast.show(
          context,
          f.message,
          type: AppToastType.error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(),
        body: PremiumErrorState(
          title: AppLocalizations.of(context)!.eventsDetailErrorTitle,
          message: _errorMessage!,
          actionLabel: AppLocalizations.of(context)!.eventsDetailRetryButton,
          onRetry: () {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
            _loadEvent();
          },
        ),
      );
    }
    if (_event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(AppLocalizations.of(context)!.eventsDetailNotFound),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageCarousel(theme),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildContent(theme, appColors),
                ),
              ),
            ],
          ),
          Positioned(left: 24, right: 24, bottom: 32, child: _buildCTA(theme)),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(ThemeData theme) {
    final images = _event!.images;
    if (images.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Symbols.emoji_events,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      );
    }
    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: (i) => setState(() => _currentImageIndex = i),
          itemBuilder: (_, i) => Image.network(
            images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
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
        Positioned(
          left: 16,
          bottom: 16,
          child: Row(
            children: [
              if (_event!.format != null)
                _chip(theme, _event!.format!, theme.colorScheme.primary),
              const SizedBox(width: 8),
              _chip(
                theme,
                (_event!.status ?? 'unknown').toUpperCase(),
                _statusColor(theme),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(ThemeData theme, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _statusColor(ThemeData theme) {
    switch (_event!.status) {
      case 'open':
        return theme.colorScheme.primary;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return theme.colorScheme.onSurfaceVariant;
      case 'canceled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  Widget _buildForWhom(ThemeData theme, AppColors appColors) {
    final memberName =
        _selectedMember?.name ?? AppLocalizations.of(context)!.planDetailMyself;
    final isPrimary = _selectedMember?.isPrimary ?? true;

    return Container(
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final childId = await showChildSelectorSheet(context);
          if (!mounted) return;
          if (childId == kAddChildSentinel) {
            await context.push('/add-child');
            return;
          }
          final member = _familyMembers.firstWhere(
            (m) =>
                (childId == null && m.isPrimary) ||
                (childId != null && m.id == childId),
            orElse: () => _familyMembers.first,
          );
          setState(() {
            _selectedMember = member;
            _updateSelectedMemberStatus();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                child: Icon(
                  isPrimary ? Symbols.person : Symbols.child_care,
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
                      AppLocalizations.of(
                        context,
                      )!.planDetailSubscribeFor.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      memberName,
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
      ),
    );
  }

  Widget _buildContent(ThemeData theme, AppColors appColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _event!.name?.toUpperCase() ??
              AppLocalizations.of(context)!.eventsDetailEventFallback,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _infoRow(theme, Symbols.calendar_month, _formatDateRange(context)),
        if (_event!.registrationDeadline != null) ...[
          const SizedBox(height: 10),
          _infoRow(
            theme,
            Symbols.edit_calendar,
            '${AppLocalizations.of(context)!.eventsDetailRegisterBy} ${_formatDate(_event!.registrationDeadline!)}',
          ),
        ],
        if (_event!.format != null) ...[
          const SizedBox(height: 10),
          _infoRow(
            theme,
            Symbols.sports_esports,
            '${_event!.format!} ${AppLocalizations.of(context)!.eventsDetailFormat}',
          ),
        ],
        if (_event!.requiresCheckIn) ...[
          const SizedBox(height: 10),
          _infoRow(
            theme,
            Symbols.how_to_reg,
            AppLocalizations.of(context)!.eventsDetailCheckInRequired,
          ),
        ],
        const SizedBox(height: 20),
        _participantsProgress(theme),
        const SizedBox(height: 20),
        if (_showFamilyFeatures && _familyMembers.isNotEmpty) ...[
          _buildForWhom(theme, appColors),
          const SizedBox(height: 20),
        ],
        if (_event!.description != null && _event!.description!.isNotEmpty)
          Text(
            _event!.description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () =>
              context.push('/events/${_event!.id}/bracket', extra: _event),
          icon: const Icon(Symbols.emoji_events, size: 18),
          label: Text(
            AppLocalizations.of(context)!.eventsDetailViewBracketButton,
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _infoRow(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateRange(BuildContext context) {
    final start = _event!.startDate;
    final end = _event!.endDate;
    if (start == null && end == null) {
      return AppLocalizations.of(context)!.eventsDetailDateTBD;
    }
    final s = start != null
        ? _formatDate(start)
        : AppLocalizations.of(context)!.eventsDetailTBD;
    final e = end != null
        ? _formatDate(end)
        : AppLocalizations.of(context)!.eventsDetailTBD;
    return s == e ? s : '$s – $e';
  }

  String _formatDate(String iso) {
    try {
      return DateFormat('MMM d, yyyy').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  Widget _participantsProgress(ThemeData theme) {
    final count = _event!.participantsCount ?? 0;
    final max = _event!.maxParticipants ?? 0;
    final ratio = max > 0 ? count / max : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Symbols.group,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              '$count / $max ${AppLocalizations.of(context)!.eventsDetailParticipantsText}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${(ratio * 100).round()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              ratio >= 1 ? theme.colorScheme.error : theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  bool _isEventDay() {
    final start = _event!.startDate;
    if (start == null) return false;
    try {
      final now = DateTime.now();
      final eventDay = DateTime.parse(start);
      return now.year == eventDay.year &&
          now.month == eventDay.month &&
          now.day == eventDay.day;
    } catch (_) {
      return false;
    }
  }

  Widget _buildCTA(ThemeData theme) {
    final appColors = theme.extension<AppColors>()!;
    final (String label, VoidCallback? action) = switch ((
      _isActionLoading,
      _isCheckedIn,
      _isRegistered,
      _event!,
    )) {
      (true, _, _, _) => ('', null),
      (_, true, _, _) => (
        AppLocalizations.of(context)!.eventsDetailCheckedInStatus,
        null,
      ),
      (_, _, true, final e) when e.requiresCheckIn && _isEventDay() => (
        AppLocalizations.of(context)!.eventsDetailCheckInAction,
        _checkIn,
      ),
      (_, _, true, final e) when e.status == 'open' => (
        AppLocalizations.of(context)!.eventsDetailRegisteredStatus,
        _withdraw,
      ),
      (_, _, false, final e) when e.isRegistrationOpen => (
        AppLocalizations.of(context)!.eventsDetailRegisterAction,
        _register,
      ),
      _ => (AppLocalizations.of(context)!.eventsDetailRegistrationClosed, null),
    };

    final isRegisteredOpen = _isRegistered && _event?.status == 'open';

    return ElevatedButton(
      onPressed: _isActionLoading ? null : action,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isCheckedIn || isRegisteredOpen
            ? appColors.statusSuccess.withValues(alpha: 0.1)
            : theme.colorScheme.primary,
        foregroundColor: _isCheckedIn || isRegisteredOpen
            ? appColors.statusSuccess
            : theme.colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: _isCheckedIn || isRegisteredOpen
              ? BorderSide(color: appColors.statusSuccess)
              : BorderSide.none,
        ),
        disabledBackgroundColor: theme.colorScheme.primary.withValues(
          alpha: 0.4,
        ),
      ),
      child: _isActionLoading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
    );
  }
}
