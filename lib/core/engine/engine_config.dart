import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

enum EngineType { lightweight, powerful, manual }

class EngineConfig {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  static Future<EngineType> getEngine() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getInt('engine') ?? 0;
    // On Android, manual falls back to lightweight (no shell tools)
    final engine = EngineType.values[val];
    if (isAndroid && engine == EngineType.manual) return EngineType.lightweight;
    return engine;
  }

  // ── Feature support matrix ──────────────────────────────────────

  // Images, CSV/XLSX, TXT/MD/HTML → PDF: pure Dart, always works
  static bool supportsImages(EngineType e) => true;
  static bool supportsData(EngineType e) => true;
  static bool supportsPdf(EngineType e) => true;

  // Video: desktop needs ffmpeg in PATH; Android uses ffmpeg_kit (powerful only)
  static bool supportsVideo(EngineType e) {
    if (isAndroid) return e == EngineType.powerful;
    return e == EngineType.powerful || e == EngineType.manual;
  }

  // Audio: same as video
  static bool supportsAudio(EngineType e) => supportsVideo(e);

  // DOCX/PPTX/EPUB → PDF: needs LibreOffice/ebook-convert — desktop only
  static bool supportsDesktopDocs(EngineType e) {
    if (isAndroid) return false; // never on Android
    return e == EngineType.powerful || e == EngineType.manual;
  }
}
