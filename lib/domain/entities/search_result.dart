import 'package:flutter/material.dart';

/// Types of search results available in the application.
enum SearchResultType { activity, course, setting, navigation }

/// A unified entity representing a search result from any source.
class SearchResult {
  final String title;
  final String subtitle;
  final SearchResultType type;
  final IconData icon;
  final String route;
  final Object? extra;

  const SearchResult({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
    required this.route,
    this.extra,
  });
}
