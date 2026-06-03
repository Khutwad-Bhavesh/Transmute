import 'dart:io';
import 'package:path/path.dart' as p;

class AudioConverter {
  static Future<String> convert({
    required String sourcePath,
    required String targetFormat,
    required String outputDir,
  }) async {
    final baseName = p.basenameWithoutExtension(sourcePath);
    final outPath = p.join(outputDir, '$baseName.${targetFormat.toLowerCase()}');

    final args = _buildArgs(
      sourcePath: sourcePath,
      outPath: outPath,
      targetFormat: targetFormat.toUpperCase(),
    );

    final result = await Process.run('ffmpeg', args);

    if (result.exitCode != 0) {
      throw Exception('ffmpeg audio error: ${result.stderr}');
    }

    return outPath;
  }

  static List<String> _buildArgs({
    required String sourcePath,
    required String outPath,
    required String targetFormat,
  }) {
    final base = ['-i', sourcePath, '-y'];

    switch (targetFormat) {
      case 'MP3':
        return [...base, '-codec:a', 'libmp3lame', '-q:a', '2', outPath];
      case 'WAV':
        return [...base, '-codec:a', 'pcm_s16le', outPath];
      case 'OGG':
        return [...base, '-codec:a', 'libvorbis', '-q:a', '4', outPath];
      default:
        return [...base, outPath];
    }
  }
}