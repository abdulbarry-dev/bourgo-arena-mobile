/// Formats a loyalty point total into a compact, fixed-width-friendly string.
///
/// Scales through K (thousand), M (million), B (billion), T (trillion) and
/// Q (quadrillion) so even very large balances stay readable inside stat
/// tiles. Values below 100 in their unit keep one decimal (e.g. `1.5K`), larger
/// ones drop it (e.g. `123K`), and trailing `.0` is always stripped.
String compactPoints(int points) {
  if (points < 0) return '0';
  if (points < 1000) return points.toString();

  const units = ['K', 'M', 'B', 'T', 'Q'];
  var value = points.toDouble();
  var unitIndex = -1;

  while (unitIndex < units.length - 1) {
    value /= 1000;
    unitIndex++;

    final rounded = value < 100
        ? (value * 10).round() / 10
        : value.roundToDouble();
    if (rounded < 1000 || unitIndex == units.length - 1) {
      value = rounded;
      break;
    }
  }

  final String formatted;
  if (value < 100) {
    final s = value.toStringAsFixed(1);
    formatted = s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  } else {
    formatted = value.round().toString();
  }
  return '$formatted${units[unitIndex]}';
}
