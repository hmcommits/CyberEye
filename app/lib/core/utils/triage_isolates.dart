import 'dart:isolate';
import 'dart:math';

class TriageIsolates {
  /// Calculates Shannon Entropy in a separate Isolate to prevent UI jank
  static Future<double> calculateShannonEntropy(String input) async {
    return await Isolate.run(() {
      if (input.isEmpty) return 0.0;
      
      final Map<String, int> frequencies = {};
      for (int i = 0; i < input.length; i++) {
        final char = input[i];
        frequencies[char] = (frequencies[char] ?? 0) + 1;
      }

      double entropy = 0.0;
      final int len = input.length;
      for (final count in frequencies.values) {
        final double p = count / len;
        entropy -= p * (log(p) / log(2));
      }
      return entropy;
    });
  }

  /// Calculates Levenshtein Distance in a separate Isolate
  static Future<int> calculateLevenshteinDistance(Map<String, String> args) async {
    return await Isolate.run(() {
      final s1 = args['s1']!;
      final s2 = args['s2']!;
      
      if (s1.isEmpty) return s2.length;
      if (s2.isEmpty) return s1.length;

      final List<List<int>> matrix = List.generate(
        s1.length + 1,
        (i) => List.generate(s2.length + 1, (j) => 0),
      );

      for (int i = 0; i <= s1.length; i++) matrix[i][0] = i;
      for (int j = 0; j <= s2.length; j++) matrix[0][j] = j;

      for (int i = 1; i <= s1.length; i++) {
        for (int j = 1; j <= s2.length; j++) {
          final int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
          matrix[i][j] = [
            matrix[i - 1][j] + 1,
            matrix[i][j - 1] + 1,
            matrix[i - 1][j - 1] + cost,
          ].reduce(min);
        }
      }

      return matrix[s1.length][s2.length];
    });
  }
}
