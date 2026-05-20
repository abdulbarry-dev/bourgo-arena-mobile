/// Represents a paginated list of items with metadata.
class PaginatedResult<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasMore;

  const PaginatedResult({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.hasMore,
  });
}
