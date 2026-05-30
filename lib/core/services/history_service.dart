import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryEntry {
  final String fileName;
  final String fromFormat;
  final String toFormat;
  final String outputPath;
  final DateTime convertedAt;
  final bool success;

  HistoryEntry({
    required this.fileName,
    required this.fromFormat,
    required this.toFormat,
    required this.outputPath,
    required this.convertedAt,
    required this.success,
  });

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'fromFormat': fromFormat,
        'toFormat': toFormat,
        'outputPath': outputPath,
        'convertedAt': convertedAt.toIso8601String(),
        'success': success,
      };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        fileName: json['fileName'],
        fromFormat: json['fromFormat'],
        toFormat: json['toFormat'],
        outputPath: json['outputPath'],
        convertedAt: DateTime.parse(json['convertedAt']),
        success: json['success'],
      );
}

class HistoryService {
  static const _key = 'conversion_history';

  static Future<List<HistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((e) => HistoryEntry.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> addEntry(HistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(entry.toJson()));
    if (raw.length > 100) raw.removeAt(0);
    await prefs.setStringList(_key, raw);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}