import 'package:flutter/material.dart';
import 'package:tube_downloader/screens/home.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(ProviderScope(child: MyApp(savedThemeMode: savedThemeMode)));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});

  static const appTitle = 'Tube Downloader';

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          brightness: Brightness.light,
          background: Color(0xFFf9f9f9),
          surface: Color(0xFFd9d9d9),
          primary: Color(0xFF1161cb),
          secondary: Color(0xFF8ff0a4),
          onSurface: Color(0xFF101010),
          onBackground: Color(0xFF202020),
          onPrimary: Color(0xFF000000),
          onSecondary: Color(0xFF000000),
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          background: Color(0xFF101010),
          surface: Color(0xFF1e1e1e),
          primary: Color(0xFF1161cb),
          secondary: Color(0xFF8ff0a4),
          onSurface: Color(0xFFf8f8f8),
          onBackground: Color(0xFFf2f2f2),
          onPrimary: Color(0xFF000000),
          onSecondary: Color(0xFF000000),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, dark) {
        return MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: dark,
          home: const HomePage(),
        );
      },
    );
  }
}
