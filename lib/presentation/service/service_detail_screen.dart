import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Service? service;
  final String serviceId;

  const ServiceDetailScreen({super.key, this.service, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = AppSpacing.standard;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(service?.name ?? 'Service Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (service?.imageUrl != null)
              CachedNetworkImage(
                imageUrl: service!.imageUrl!,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 250,
                color: appColors.bgElevated,
                child: const Icon(Icons.image, size: 64),
              ),
            Padding(
              padding: spacing.screenPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service?.name ?? 'Loading...',
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    service?.description ?? 'No description available.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
