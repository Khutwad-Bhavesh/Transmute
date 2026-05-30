import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;

class DocumentConverter {
  static Future<String> txtToPdf({
    required String sourcePath,
    required String outputDir,
  }) async {
    final content = await File(sourcePath).readAsString();
    final pdf = pw.Document();
    final lines = content.split('\n');
    final chunks = <List<String>>[];

    for (var i = 0; i < lines.length; i += 40) {
      chunks.add(lines.sublist(i, i + 40 > lines.length ? lines.length : i + 40));
    }

    for (final chunk in chunks) {
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: chunk
              .map((line) => pw.Text(line, style: const pw.TextStyle(fontSize: 11)))
              .toList(),
        ),
      ));
    }

    final baseName = p.basenameWithoutExtension(sourcePath);
    final outPath = p.join(outputDir, '$baseName.pdf');
    await File(outPath).writeAsBytes(await pdf.save());
    return outPath;
  }

  static Future<String> docxToPdf({
    required String sourcePath,
    required String outputDir,
  }) async {
    final result = await Process.run('/usr/lib/libreoffice/program/soffice', [
      '--headless',
      '--convert-to', 'pdf',
      '--outdir', outputDir,
      sourcePath,
    ]);

    if (result.exitCode != 0) {
      throw Exception('LibreOffice error: ${result.stderr}');
    }

    final baseName = p.basenameWithoutExtension(sourcePath);
    return p.join(outputDir, '$baseName.pdf');
  }

  static Future<String> pdfToDocx({
    required String sourcePath,
    required String outputDir,
  }) async {
    final bytes = await File(sourcePath).readAsBytes();
    final text = _extractTextFromPdf(bytes);
    final baseName = p.basenameWithoutExtension(sourcePath);
    final outPath = p.join(outputDir, '$baseName.docx');
    await File(outPath).writeAsString(text);
    return outPath;
  }

  static String _extractTextFromPdf(List<int> bytes) {
    try {
      final raw = String.fromCharCodes(bytes);
      final matches = RegExp(r'BT(.*?)ET', dotAll: true)
          .allMatches(raw)
          .map((m) => m.group(1) ?? '')
          .join('\n');
      final cleaned = matches
          .replaceAll(RegExp(r'\(([^)]*)\)\s*Tj'), r'$1')
          .replaceAll(RegExp(r'[^\x20-\x7E\n]'), '')
          .trim();
      return cleaned.isEmpty ? 'Could not extract text from this PDF.' : cleaned;
    } catch (_) {
      return 'Could not extract text from this PDF.';
    }
  }
}