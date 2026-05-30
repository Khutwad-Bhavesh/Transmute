import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

class DataConverter {
  static Future<String> csvToXlsx({
    required String sourcePath,
    required String outputDir,
  }) async {
    final content = await File(sourcePath).readAsString();
    final lines = const LineSplitter().convert(content);
    final rows = lines.map((l) => l.split(',')).toList();

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    for (final row in rows) {
      sheet.appendRow(row.map((e) => TextCellValue(e)).toList());
    }

    final baseName = p.basenameWithoutExtension(sourcePath);
    final outPath = p.join(outputDir, '$baseName.xlsx');
    final fileBytes = excel.save();
    if (fileBytes == null) throw Exception('Failed to encode xlsx');
    await File(outPath).writeAsBytes(fileBytes);
    return outPath;
  }

  static Future<String> xlsxToCsv({
    required String sourcePath,
    required String outputDir,
  }) async {
    final bytes = await File(sourcePath).readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.first;

    final rows = sheet.rows
        .map((row) => row.map((cell) => cell?.value?.toString() ?? '').join(','))
        .join('\n');

    final baseName = p.basenameWithoutExtension(sourcePath);
    final outPath = p.join(outputDir, '$baseName.csv');
    await File(outPath).writeAsString(rows);
    return outPath;
  }
}