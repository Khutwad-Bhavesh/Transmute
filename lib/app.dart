
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_colors.dart';
import 'shared/widgets/app_sidebar.dart';
import 'features/converter/converter_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/pdf_tools/pdf_tools_screen.dart';
import 'features/history/history_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/compression/compression_screen.dart';

class FileConverterApp extends StatelessWidget {
  const FileConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FileConverter',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _buildLight(),
      darkTheme: _buildDark(),
      home: const MainShell(),
    );
  }

  ThemeData _buildLight() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.teal,
          surface: AppColors.lightBgSecondary,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        dividerColor: AppColors.lightBorder,
      );

  ThemeData _buildDark() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.teal,
          surface: AppColors.darkBgSecondary,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        dividerColor: AppColors.darkBorder,
      );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  SidebarItem _selected = SidebarItem.converter;
  bool _onboarded = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboarded();
  }

  Future<void> _checkOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboarded = prefs.getBool('onboarded') ?? false;
      _loading = false;
    });
  }

  Widget _buildScreen() {
    return switch (_selected) {
      SidebarItem.converter => const ConverterScreen(),
      SidebarItem.batch => const ConverterScreen(),
      SidebarItem.pdfMerge => const PdfToolsScreen(),
      SidebarItem.pdfSplit => const PdfToolsScreen(),
      SidebarItem.history => const HistoryScreen(),
      SidebarItem.settings => const SettingsScreen(),
      SidebarItem.compression => const CompressionScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: SizedBox());

    if (!_onboarded) {
      return OnboardingScreen(
        onDone: () => setState(() => _onboarded = true),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            selected: _selected,
            onSelect: (item) => setState(() => _selected = item),
          ),
          Expanded(child: _buildScreen()),
        ],
      ),
    );
  }
}