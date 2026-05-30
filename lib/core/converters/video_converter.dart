import 'dart:io';
import 'package:path/path.dart' as p;

class VideoConverter {
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
      throw Exception('ffmpeg error: ${result.stderr}');
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
      case 'MP4':
        return [...base, '-c:v', 'libx264', '-c:a', 'aac', outPath];
      case 'AVI':
        return [...base, '-c:v', 'libxvid', '-c:a', 'mp3', outPath];
      case 'MKV':
        return [...base, '-c:v', 'libx264', '-c:a', 'aac', outPath];
      case 'GIF':
        return [
          '-i', sourcePath, '-y',
          '-vf', 'fps=10,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse',
          '-loop', '0',
          outPath,
        ];
      default:
        return [...base, outPath];
    }
  }
}