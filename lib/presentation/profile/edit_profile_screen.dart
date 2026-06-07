import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_view_model.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for editing the user's profile information.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late final EditProfileViewModel _viewModel;
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _selectedBirthDate;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _viewModel = EditProfileViewModel(
      updateUserProfileUseCase: locator<UpdateUserProfileUseCase>(),
      authRepository: locator<AuthRepository>(),
      authStateNotifier: locator<AuthStateNotifier>(),
    );
    _viewModel.addListener(_onViewModelChange);

    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);

    _onViewModelChange();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _viewModel.removeListener(_onViewModelChange);
    _firstNameController.removeListener(_onFieldChanged);
    _lastNameController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    if (!_viewModel.isLoading &&
        _viewModel.user != null &&
        _firstNameController.text.isEmpty) {
      _firstNameController.text = _viewModel.user!.firstName;
      _lastNameController.text = _viewModel.user!.lastName;
      _emailController.text = _viewModel.user!.email;
      _phoneController.text = _viewModel.user!.phone ?? '';
      _selectedGender = _viewModel.user!.gender;
      if (_viewModel.user!.birthDate != null) {
        _selectedBirthDate = _viewModel.user!.birthDate;
        _birthDateController.text = DateFormat.yMMMd().format(
          _selectedBirthDate!,
        );
      }
    }
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = DateFormat.yMMMd().format(picked);
      });
    }
  }

  bool get _hasChanges {
    final user = _viewModel.user;
    if (user == null) return false;

    return _firstNameController.text.trim() != user.firstName ||
        _lastNameController.text.trim() != user.lastName ||
        _selectedBirthDate != user.birthDate ||
        _selectedGender != user.gender;
  }

  Future<bool> _verifyWithOtp(String identifier, String type) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final sent = await _viewModel.sendOtp(identifier);
    if (!mounted) return false;
    Navigator.of(context, rootNavigator: true).pop();

    if (!sent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send OTP to $identifier"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    final otpController = TextEditingController();
    bool isVerifying = false;
    bool? verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                "Verify $type",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter the OTP sent to $identifier",
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: otpController,
                    decoration: InputDecoration(
                      hintText: "OTP Code",
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isVerifying
                      ? null
                      : () => Navigator.pop(ctx, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isVerifying
                      ? null
                      : () async {
                          setState(() => isVerifying = true);
                          final success = await _viewModel.verifyOtp(
                            identifier,
                            otpController.text.trim(),
                          );
                          if (success && mounted) {
                            Navigator.pop(ctx, true);
                          } else {
                            setState(() => isVerifying = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Invalid OTP"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: isVerifying
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Verify"),
                ),
              ],
            );
          },
        );
      },
    );
    return verified ?? false;
  }

  Future<void> _verifyAndSave(String identifier, String type) async {
    final success = await _verifyWithOtp(identifier, type);
    if (!mounted) return;
    if (success) {
      final user = _viewModel.user!;
      final newEmail = type == "Email" ? identifier : user.email;
      final newPhone = type == "Phone" ? identifier : user.phone ?? '';

      final saved = await _viewModel.saveProfile(
        firstName: user.firstName,
        lastName: user.lastName,
        email: newEmail,
        phone: newPhone,
        birthDate: user.birthDate,
        gender: user.gender,
      );
      if (saved && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$type verified and updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update $type. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = _viewModel.user;
      if (user == null) return;

      final success = await _viewModel.saveProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: user.email,
        phone: user.phone ?? '',
        birthDate: _selectedBirthDate,
        gender: _selectedGender,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.profileUpdateSuccess),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.errorUpdatingProfile),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.profileEditTitle.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.5,
          ),
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          tabs: const [
            Tab(text: "PERSONAL"),
            Tab(text: "SECURITY"),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = _viewModel.user!;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPersonalInfoTab(
                        context,
                        appColors,
                        user.avatarUrl,
                        l10n,
                      ),
                      _buildSecurityInfoTab(context, appColors, l10n),
                    ],
                  ),
                ),
                _buildBottomBar(context, appColors, l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoTab(
    BuildContext context,
    AppColors appColors,
    String? avatarUrl,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AvatarSection(avatarUrl: avatarUrl),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: appColors.bgElevated,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: appColors.bgBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AuthTextField(
                        label: l10n.authFirstNameLabel,
                        hint: l10n.authFirstNameHint,
                        leadingIcon: Symbols.person,
                        controller: _firstNameController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AuthTextField(
                        label: l10n.authLastNameLabel,
                        hint: l10n.authLastNameHint,
                        leadingIcon: Symbols.person,
                        controller: _lastNameController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  label: l10n.authBirthDateLabel,
                  hint: l10n.authBirthDateHint,
                  leadingIcon: Symbols.calendar_today,
                  controller: _birthDateController,
                  readOnly: true,
                  onTap: _selectBirthDate,
                ),
                const SizedBox(height: 20),
                _buildGenderDropdown(context, appColors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown(BuildContext context, AppColors appColors) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "GENDER",
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: _selectedGender,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Symbols.wc,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          hint: const Text("Select Gender"),
          items: const [
            DropdownMenuItem(value: 'male', child: Text("Male")),
            DropdownMenuItem(value: 'female', child: Text("Female")),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildVerifyButton(String identifier, String type) {
    if (identifier.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: TextButton(
        onPressed: () => _verifyAndSave(identifier, type),
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          minimumSize: const Size(0, 36),
        ),
        child: const Text(
          "VERIFY",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityInfoTab(
    BuildContext context,
    AppColors appColors,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final user = _viewModel.user;
    if (user == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Symbols.security,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Changes to your email or phone number require OTP verification. Enter a new value and click VERIFY.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: appColors.bgElevated,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: appColors.bgBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  label: l10n.authEmailLabel,
                  hint: "Enter your email",
                  leadingIcon: Symbols.mail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: _emailController.text.trim() != user.email
                      ? _buildVerifyButton(
                          _emailController.text.trim(),
                          "Email",
                        )
                      : null,
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  label: l10n.authPhoneLabel,
                  hint: "Enter your phone number",
                  leadingIcon: Symbols.phone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  suffixIcon: _phoneController.text.trim() != (user.phone ?? '')
                      ? _buildVerifyButton(
                          _phoneController.text.trim(),
                          "Phone",
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    AppColors appColors,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(
        24,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: appColors.bgSurface,
        border: Border(top: BorderSide(color: appColors.bgBorder)),
      ),
      child: ElevatedButton(
        onPressed: _viewModel.isSaving ? null : _save,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _viewModel.isSaving
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.surface,
                ),
              )
            : Text(
                l10n.profileSave.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

class _OtpVerificationDialog extends StatefulWidget {
  final String identifier;
  final String type;
  final Future<bool> Function(String) onVerify;

  const _OtpVerificationDialog({
    required this.identifier,
    required this.type,
    required this.onVerify,
  });

  @override
  State<_OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<_OtpVerificationDialog> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _handlePaste(String text) {
    if (text.length == 6 && RegExp(r'^\d{6}$').hasMatch(text)) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = text[i];
      }
      _focusNodes[5].requestFocus();
    } else {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = '';
      }
      _focusNodes[0].requestFocus();
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid format. Please paste a 6-digit code.'),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text?.trim() ?? '';
    _handlePaste(text);
  }

  Widget _buildOTPField(int index) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 42,
      height: 56,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainer,
        ),
        onChanged: (value) {
          if (value.length > 1) {
            _handlePaste(value);
            return;
          }
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.mark_email_read,
              color: theme.colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Verify ${widget.type}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enter the 6-digit OTP sent to\n${widget.identifier}",
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) => _buildOTPField(index)),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _pasteFromClipboard,
            icon: const Icon(Symbols.content_paste, size: 18),
            label: const Text(
              "Paste Code",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isVerifying
                    ? null
                    : () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isVerifying
                    ? null
                    : () async {
                        final code = _controllers.map((c) => c.text).join();
                        if (code.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Please enter a valid 6-digit OTP",
                              ),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                          return;
                        }
                        setState(() => _isVerifying = true);
                        final success = await widget.onVerify(code);
                        if (!context.mounted) return;
                        if (success) {
                          Navigator.pop(context, true);
                        } else {
                          setState(() => _isVerifying = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Invalid OTP"),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Verify"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OtpVerificationDialog extends StatefulWidget {
  final String identifier;
  final String type;
  final Future<bool> Function(String) onVerify;

  const _OtpVerificationDialog({
    required this.identifier,
    required this.type,
    required this.onVerify,
  });

  @override
  State<_OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<_OtpVerificationDialog> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _handlePaste(String text) {
    if (text.length == 6 && RegExp(r'^\d{6}$').hasMatch(text)) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = text[i];
      }
      _focusNodes[5].requestFocus();
    } else {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = '';
      }
      _focusNodes[0].requestFocus();
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid format. Please paste a 6-digit code.'),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text?.trim() ?? '';
    _handlePaste(text);
  }

  Widget _buildOTPField(int index) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 42,
      height: 56,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainer,
        ),
        onChanged: (value) {
          if (value.length > 1) {
            _handlePaste(value);
            return;
          }
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.mark_email_read,
              color: theme.colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Verify ${widget.type}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enter the 6-digit OTP sent to\n${widget.identifier}",
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) => _buildOTPField(index)),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _pasteFromClipboard,
            icon: const Icon(Symbols.content_paste, size: 18),
            label: const Text(
              "Paste Code",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isVerifying
                    ? null
                    : () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isVerifying
                    ? null
                    : () async {
                        final code = _controllers.map((c) => c.text).join();
                        if (code.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Please enter a valid 6-digit OTP",
                              ),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                          return;
                        }
                        setState(() => _isVerifying = true);
                        final success = await widget.onVerify(code);
                        if (!mounted) return;
                        if (success) {
                          Navigator.pop(context, true);
                        } else {
                          setState(() => _isVerifying = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Invalid OTP"),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Verify"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String? avatarUrl;

  const _AvatarSection({this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: avatarUrl == null
                  ? Icon(
                      Symbols.person,
                      size: 60,
                      color: theme.colorScheme.primary,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Symbols.edit,
                size: 18,
                color: theme.colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
