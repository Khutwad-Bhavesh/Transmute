import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class OutputService {
  static const _key = 'output_dir';

  static Future<String> getOutputDir() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) return saved;
    final downloads = await getDownloadsDirectory();
    return downloads?.path ?? (await getTemporaryDirectory()).path;
  }

  static Future<void> setOutputDir(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, path);
  }
}