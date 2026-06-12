/// Formats a loyalty point total into a compact, fixed-width-friendly string
/// using K (thousand), M (million), B (billion) abbreviations.
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

/// Formats a loyalty point total with space-separated thousands for
/// clear, human-readable display (e.g. `1 500 000` instead of `1.5M`).
String formatPoints(int points) {
  if (points < 0) return '0';
  final str = points.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(str[i]);
  }
  return buffer.toString();
}
