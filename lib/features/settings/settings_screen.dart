import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/services/output_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _engine = 0;
  String _outputDir = '';

  final _engines = ['Lightweight', 'Powerful', 'Manual'];
  final _engineSubs = [
    'Dart-only libs, ~50MB',
    'Bundled ffmpeg + tools, ~200MB',
    'Use system-installed tools',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final dir = await OutputService.getOutputDir();
    setState(() {
      _engine = prefs.getInt('engine') ?? 0;
      _outputDir = dir;
    });
  }

  Future<void> _setEngine(int val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('engine', val);
    setState(() => _engine = val);
  }

  Future<void> _pickOutputDir() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result == null) return;
    await OutputService.setOutputDir(result);
    setState(() => _outputDir = result);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bg = isDark ? AppColors.darkBgSecondary : AppColors.lightBgSecondary;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final textTertiary = isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary)),
          const SizedBox(height: 24),
          _SectionHeader(label: 'CONVERSION ENGINE', textTertiary: textTertiary),
          const SizedBox(height: 10),
          ...List.generate(_engines.length, (i) {
            final isSelected = _engine == i;
            return GestureDetector(
              onTap: () => _setEngine(i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? (isDark ? AppColors.darkBgTertiary : AppColors.lightBgTertiary) : bg,
                  border: Border.all(color: isSelected ? AppColors.teal : border, width: isSelected ? 1 : 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_engines[i], style: AppTypography.label.copyWith(color: textPrimary)),
                          const SizedBox(height: 2),
                          Text(_engineSubs[i], style: AppTypography.caption.copyWith(color: textTertiary)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.teal),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          _SectionHeader(label: 'OUTPUT FOLDER', textTertiary: textTertiary),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickOutputDir,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: border, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.folder_outlined, size: 14, color: textTertiary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(_outputDir, style: AppTypography.caption.copyWith(color: textSecondary), overflow: TextOverflow.ellipsis),
                  ),
                  Text('change', style: AppTypography.caption.copyWith(color: AppColors.teal)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(label: 'ABOUT', textTertiary: textTertiary),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: border, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FileConverter', style: AppTypography.label.copyWith(color: textPrimary)),
                const SizedBox(height: 4),
                Text('Free, offline, open source. No ads. No watermarks. No sign-in.', style: AppTypography.caption.copyWith(color: textTertiary)),
                const SizedBox(height: 8),
                Text('v1.0.0', style: AppTypography.caption.copyWith(color: textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color textTertiary;
  const _SectionHeader({required this.label, required this.textTertiary});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTypography.sectionHeader.copyWith(color: textTertiary));
  }
}