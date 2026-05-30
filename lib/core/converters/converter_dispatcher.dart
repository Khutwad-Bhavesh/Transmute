import 'package:file_converter/core/services/output_service.dart';
import 'package:file_converter/core/services/history_service.dart';
import 'image_converter.dart';
import 'pdf_converter.dart';
import 'data_converter.dart';
import 'document_converter.dart';
import 'video_converter.dart';
import '../models/conversion_job.dart';

class ConverterDispatcher {
  static Future<String> run(ConversionJob job) async {
    final outputDir = await OutputService.getOutputDir();
    final ext = job.extension.toLowerCase();
    final target = (job.targetFormat ?? '').toUpperCase();

    String outPath;

    if (['jpg', 'jpeg', 'png', 'webp', 'bmp'].contains(ext)) {
      if (target == 'PDF') {
        outPath = await PdfConverter.imageToPdf(
          imagePaths: [job.sourcePath],
          outputDir: outputDir,
          baseName: job.fileName.split('.').first,
        );
      } else {
        outPath = await ImageConverter.convert(
          sourcePath: job.sourcePath,
          targetFormat: target,
          outputDir: outputDir,
        );
      }
    } else if (ext == 'csv') {
      outPath = await DataConverter.csvToXlsx(sourcePath: job.sourcePath, outputDir: outputDir);
    } else if (ext == 'xlsx') {
      outPath = await DataConverter.xlsxToCsv(sourcePath: job.sourcePath, outputDir: outputDir);
    } else if (ext == 'txt') {
      outPath = await DocumentConverter.txtToPdf(sourcePath: job.sourcePath, outputDir: outputDir);
    } else if (ext == 'docx' && target == 'PDF') {
      outPath = await DocumentConverter.docxToPdf(sourcePath: job.sourcePath, outputDir: outputDir);
    } else if (ext == 'pdf' && target == 'DOCX') {
      outPath = await DocumentConverter.pdfToDocx(sourcePath: job.sourcePath, outputDir: outputDir);
    } else if (['mp4', 'avi', 'mkv', 'mov'].contains(ext)) {
      outPath = await VideoConverter.convert(
        sourcePath: job.sourcePath,
        targetFormat: target,
        outputDir: outputDir,
      );
    } else {
      throw Exception('Unsupported conversion: $ext → $target');
    }

    await HistoryService.addEntry(HistoryEntry(
      fileName: job.fileName,
      fromFormat: ext.toUpperCase(),
      toFormat: target,
      outputPath: outPath,
      convertedAt: DateTime.now(),
      success: true,
    ));

    return outPath;
  }
}