import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_view_model.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';

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

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(ctx).extension<AppColors>()!.bgElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Theme.of(
                    ctx,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                "PHOTO DE PROFIL",
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          ctx,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Symbols.camera_alt,
                        color: Theme.of(ctx).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "PRENDRE UNE PHOTO",
                      style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickAndUploadAvatar(ImageSource.camera);
                    },
                  )
                  .animate(delay: 100.ms)
                  .fade(duration: 400.ms)
                  .slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              const SizedBox(height: 4),
              ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          ctx,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Symbols.photo_library,
                        color: Theme.of(ctx).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "CHOISIR UNE PHOTO",
                      style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickAndUploadAvatar(ImageSource.gallery);
                    },
                  )
                  .animate(delay: 200.ms)
                  .fade(duration: 400.ms)
                  .slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),
              if (avatarUrl != null) ...[
                const SizedBox(height: 4),
                ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            ctx,
                          ).colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Symbols.delete,
                          color: Theme.of(ctx).colorScheme.error,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        "SUPPRIMER LA PHOTO",
                        style: Theme.of(ctx).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(ctx).colorScheme.error,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {
                        Navigator.pop(ctx);
                        _handleDeleteAvatar();
                      },
                    )
                    .animate(delay: 300.ms)
                    .fade(duration: 400.ms)
                    .slideY(
                      begin: 0.15,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? get avatarUrl => _viewModel.user?.avatarUrl;

  Future<void> _pickAndUploadAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked == null) return;

    if (!mounted) return;
    final success = await _viewModel.uploadAvatar(picked.path);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Photo de profil mise à jour" : "Échec du téléchargement",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _handleDeleteAvatar() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "SUPPRIMER LA PHOTO",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        content: const Text(
          "Voulez-vous vraiment supprimer votre photo de profil ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("ANNULER"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text("SUPPRIMER"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    if (!mounted) return;
    final success = await _viewModel.deleteAvatar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Photo de profil supprimée" : "Échec de la suppression",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
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

    final verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _OtpVerificationDialog(
        identifier: identifier,
        type: type,
        onVerify: (code) => _viewModel.verifyOtp(identifier, code),
      ),
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
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          l10n.profileEditTitle.toUpperCase(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
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
          _AvatarSection(
            avatarUrl: avatarUrl,
            isUploading: _viewModel.isUploadingAvatar,
            onEditTap: _showAvatarOptions,
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
    final hasChanges = _hasChanges;

    return Container(
      padding: const EdgeInsets.all(
        24,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: appColors.bgSurface,
        border: Border(top: BorderSide(color: appColors.bgBorder)),
      ),
      child: ElevatedButton(
        onPressed: (_viewModel.isSaving || !hasChanges) ? null : _save,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: hasChanges ? theme.colorScheme.primary : null,
          foregroundColor: hasChanges ? theme.colorScheme.onPrimary : null,
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
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
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
    // Sanitize input: extract first 6 digits
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length >= 6) {
      final code = digits.substring(0, 6);
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = code[i];
      }
      _focusNodes[5].requestFocus();
    } else if (digits.isNotEmpty) {
      // Partial paste
      for (int i = 0; i < digits.length && i < 6; i++) {
        _controllers[i].text = digits[i];
      }
      if (digits.length < 6) {
        _focusNodes[digits.length].requestFocus();
      } else {
        _focusNodes[5].requestFocus();
      }
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
      width: 44,
      height: 60,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w900,
          fontFamily: AppConstants.displayFontFamily,
          color: theme.colorScheme.primary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
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
          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
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
    final appColors = theme.extension<AppColors>()!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.shield_lock,
                color: theme.colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "VERIFY ${widget.type.toUpperCase()}",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontFamily: AppConstants.displayFontFamily,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.7,
                  ),
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: "We've sent a code to\n"),
                  TextSpan(
                    text: widget.identifier,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
                "PASTE FROM CLIPBOARD",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  fontSize: 11,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isVerifying
                        ? null
                        : () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.1,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isVerifying
                        ? null
                        : () async {
                            final code = _controllers.map((c) => c.text).join();
                            if (code.length != 6) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter all 6 digits"),
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
                                const SnackBar(
                                  content: Text("Verification failed"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "VERIFY",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarSection extends StatefulWidget {
  final String? avatarUrl;
  final VoidCallback? onEditTap;
  final bool isUploading;

  const _AvatarSection({
    this.avatarUrl,
    this.onEditTap,
    this.isUploading = false,
  });

  @override
  State<_AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<_AvatarSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void didUpdateWidget(covariant _AvatarSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUploading && !oldWidget.isUploading) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isUploading && oldWidget.isUploading) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = widget.avatarUrl;
    final isUploading = widget.isUploading;
    final onEditTap = widget.onEditTap;

    return Center(
      child: SizedBox(
        width: 132,
        height: 132,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 128,
              height: 128,
              child: _buildAvatarCore(theme, avatarUrl, isUploading),
            ),
            if (isUploading) _buildUploadOverlay(theme),
            _buildEditFAB(theme, isUploading, onEditTap),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarCore(
    ThemeData theme,
    String? avatarUrl,
    bool isUploading,
  ) {
    return Hero(
      tag: 'profile_avatar',
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: avatarUrl != null && avatarUrl.isNotEmpty
              ? _buildNetworkAvatar(theme, avatarUrl)
              : _buildPlaceholderAvatar(theme),
        ),
      ),
    );
  }

  Widget _buildNetworkAvatar(ThemeData theme, String url) {
    return ClipOval(
      key: const ValueKey('avatar_network'),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildShimmer(theme);
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(
              Symbols.person,
              size: 60,
              color: theme.colorScheme.primary,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderAvatar(ThemeData theme) {
    return CircleAvatar(
      key: const ValueKey('avatar_placeholder'),
      radius: 60,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      child: Icon(Symbols.person, size: 60, color: theme.colorScheme.primary),
    );
  }

  Widget _buildShimmer(ThemeData theme) {
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.4,
      ),
      child: const CircleAvatar(radius: 60, backgroundColor: Colors.white),
    );
  }

  Widget _buildUploadOverlay(ThemeData theme) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final pulse = _pulseController.value;
        return IgnorePointer(
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.30 + 0.15 * pulse),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "UPLOAD",
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 9,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditFAB(
    ThemeData theme,
    bool isUploading,
    VoidCallback? onEditTap,
  ) {
    return Positioned(
      bottom: 0,
      right: 0,
      child:
          AnimatedScale(
                scale: isUploading ? 0.85 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: GestureDetector(
                  onTap: isUploading ? null : onEditTap,
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
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.35,
                          ),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Symbols.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .animate(
                autoPlay: true,
                onInit: (controller) =>
                    controller.repeat(reverse: true, period: 3000.ms),
              )
              .shimmer(duration: 800.ms, delay: 1500.ms),
    );
  }
}
