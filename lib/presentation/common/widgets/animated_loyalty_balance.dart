import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_loyalty_balance_use_case.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class AnimatedLoyaltyBalance extends StatefulWidget {
  final bool isVisible;

  const AnimatedLoyaltyBalance({super.key, required this.isVisible});

  @override
  State<AnimatedLoyaltyBalance> createState() => _AnimatedLoyaltyBalanceState();
}

class _AnimatedLoyaltyBalanceState extends State<AnimatedLoyaltyBalance> {
  Future<Result<LoyaltyBalance, Failure>>? _balanceFuture;

  @override
  void didUpdateWidget(covariant AnimatedLoyaltyBalance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible && _balanceFuture == null) {
      _fetchBalance();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isVisible) {
      _fetchBalance();
    }
  }

  void _fetchBalance() {
    _balanceFuture = locator<GetLoyaltyBalanceUseCase>().call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: widget.isVisible
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FutureBuilder<Result<LoyaltyBalance, Failure>>(
                future: _balanceFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }

                  if (snapshot.hasData) {
                    return snapshot.data!.fold(
                      onSuccess: (balance) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.stars,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Balance: ${balance.totalPoints} pts',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onFailure: (failure) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.error,
                            size: 16,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Could not load balance',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
