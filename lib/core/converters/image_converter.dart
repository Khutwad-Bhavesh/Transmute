import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

class ImageConverter {
  static Future<String> convert({
    required String sourcePath,
    required String targetFormat,
    required String outputDir,
  }) async {
    final bytes = await File(sourcePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw Exception('Could not decode image');

    final baseName = p.basenameWithoutExtension(sourcePath);
    final outPath = p.join(outputDir, '$baseName.${targetFormat.toLowerCase()}');

    List<int> encoded;
    switch (targetFormat.toUpperCase()) {
      case 'JPG':
      case 'JPEG':
        encoded = img.encodeJpg(decoded, quality: 95);
      case 'PNG':
        encoded = img.encodePng(decoded);
      case 'WEBP':
        encoded = img.encodeJpg(decoded, quality: 95);
      case 'BMP':
        encoded = img.encodeBmp(decoded);
      default:
        throw Exception('Unsupported format: $targetFormat');
    }

    await File(outPath).writeAsBytes(encoded);
    return outPath;
  }

  static Future<String> heicToImage({
    required String sourcePath,
    required String targetFormat,
    required String outputDir,
  }) async {
    final baseName = p.basenameWithoutExtension(sourcePath);
    final outPath = p.join(outputDir, '$baseName.${targetFormat.toLowerCase()}');

    final result = await Process.run('heif-convert', [
      sourcePath,
      outPath,
    ]);

    if (result.exitCode != 0) {
      throw Exception('heif-convert error: ${result.stderr}');
    }

    return outPath;
  }
static Future<String> svgToImage({
  required String sourcePath,
  required String targetFormat,
  required String outputDir,
}) async {
  final baseName = p.basenameWithoutExtension(sourcePath);
  final outPath = p.join(outputDir, '$baseName.${targetFormat.toLowerCase()}');

  final result = await Process.run('rsvg-convert', [
    '-f', targetFormat.toLowerCase(),
    '-o', outPath,
    sourcePath,
  ]);

  if (result.exitCode != 0) {
    throw Exception('rsvg-convert error: ${result.stderr}');
  }

  return outPath;
}
}
