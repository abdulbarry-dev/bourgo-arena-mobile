import 'package:flutter/material.dart';

/// Type of offering
enum OfferingType { service, course, event, activity }

/// Unified model for the Discover Feed in the Home screen
class UnifiedOffering {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final OfferingType type;
  final dynamic sourceEntity;
  final List<String> tags;
  final String? timeInfo;
  final bool isPremium;
  final String? statusBadge;
  final Color? statusColor;

  const UnifiedOffering({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.type,
    required this.sourceEntity,
    this.tags = const [],
    this.timeInfo,
    this.isPremium = false,
    this.statusBadge,
    this.statusColor,
  });

  /// Name to display for the type badge
  String get typeName {
    switch (type) {
      case OfferingType.service:
        return 'SERVICE';
      case OfferingType.course:
        return 'COURSE';
      case OfferingType.event:
        return 'EVENT';
      case OfferingType.activity:
        return 'ACTIVITY';
    }
  }

  /// Default color for the type badge
  Color getTypeColor(ThemeData theme) {
    switch (type) {
      case OfferingType.service:
        return theme.colorScheme.primary;
      case OfferingType.course:
        return Colors.orange.shade600;
      case OfferingType.event:
        return Colors.purple.shade600;
      case OfferingType.activity:
        return Colors.teal.shade600;
    }
  }
}
