import 'package:shared_preferences/shared_preferences.dart';

enum EngineType { lightweight, powerful, manual }

class EngineConfig {
  static Future<EngineType> getEngine() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getInt('engine') ?? 0;
    return EngineType.values[val];
  }

  // What each engine supports
  static bool supportsVideo(EngineType engine) {
    return engine == EngineType.powerful || engine == EngineType.manual;
  }

  static bool supportsDocx(EngineType engine) {
    return engine == EngineType.powerful || engine == EngineType.manual;
  }

  static bool supportsImages(EngineType engine) => true; // all engines
  static bool supportsData(EngineType engine) => true;   // all engines
  static bool supportsPdf(EngineType engine) => true;    // all engines
}