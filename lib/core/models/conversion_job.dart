import 'package:path/path.dart' as p;

enum JobStatus { waiting, converting, done, failed }

class ConversionJob {
  final String sourcePath;
  final String fileName;
  final String extension;
  final String fileSize;
  final String? targetFormat;
  final JobStatus status;

  const ConversionJob({
    required this.sourcePath,
    required this.fileName,
    required this.extension,
    required this.fileSize,
    this.targetFormat,
    this.status = JobStatus.waiting,
  });

  factory ConversionJob.fromFile(String path) {
    final name = p.basename(path);
    final ext = p.extension(path).replaceAll('.', '').toUpperCase();
    final job = ConversionJob(
      sourcePath: path,
      fileName: name,
      extension: ext,
      fileSize: '',
    );
    return job.copyWith(targetFormat: job.availableFormats.isNotEmpty ? job.availableFormats.first : null);
  }

  ConversionJob copyWith({String? targetFormat, JobStatus? status}) {
    return ConversionJob(
      sourcePath: sourcePath,
      fileName: fileName,
      extension: extension,
      fileSize: fileSize,
      targetFormat: targetFormat ?? this.targetFormat,
      status: status ?? this.status,
    );
  }

List<String> get availableFormats {
  switch (extension.toLowerCase()) {
    case 'jpg':
    case 'jpeg': return ['PNG', 'WEBP', 'BMP', 'PDF'];
    case 'png': return ['JPG', 'WEBP', 'BMP', 'PDF'];
    case 'webp': return ['JPG', 'PNG', 'BMP'];
    case 'bmp': return ['JPG', 'PNG', 'WEBP'];
    case 'pdf': return ['DOCX', 'PNG', 'JPG'];
    case 'docx': case 'doc': return ['PDF'];
    case 'txt': return ['PDF'];
    case 'csv': return ['XLSX'];
    case 'xlsx': return ['CSV'];
    case 'mp4': return ['AVI', 'MKV', 'GIF'];
    case 'avi': return ['MP4', 'MKV', 'GIF'];
    case 'mkv': return ['MP4', 'AVI', 'GIF'];
    case 'mov': return ['MP4', 'AVI', 'MKV', 'GIF'];
    default: return [];
  }
}
}