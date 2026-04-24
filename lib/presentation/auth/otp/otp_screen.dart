import 'package:bourgo_arena_mobile/core/theme.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_header.dart';
import 'package:flutter/material.dart';

/// The OTP verification screen for Bourgo Arena.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final OtpViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OtpViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    title: 'Vérification',
                    subtitle:
                        'Entrez le code de vérification envoyé à votre numéro.',
                  ),
                  const SizedBox(height: 48),

                  // OTP Input Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: 64,
                        height: 72,
                        decoration: BoxDecoration(
                          color: appColors.bgElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: appColors.bgBorder,
                            width: 1.5,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '-',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Real input hidden or using a specialized package
                  // For now, I'll add a simple TextField below for demonstration
                  const SizedBox(height: 24),
                  TextField(
                    controller: _viewModel.otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 8,
                    ),
                    decoration: InputDecoration(
                      hintText: 'CODE OTP',
                      counterText: '',
                      filled: true,
                      fillColor: appColors.bgElevated,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : () => _viewModel.verify(context),
                    child: _viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text('VALIDER'),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vous n\'avez pas reçu le code ? ',
                        style: TextStyle(
                          color: Colors.white.withAlpha((0.65 * 255).round()),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle resend
                        },
                        child: Text(
                          'Renvoyer',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
