import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 0,
        child: Column(
          children: [
            ListTile(
              title: const Text("Github"),
              mouseCursor: SystemMouseCursors.click,
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse('https://www.github.com/Eucaue/');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.light_mode),
                      Switch.adaptive(
                        activeColor: Theme.of(context).colorScheme.onSurface,
                        value: AdaptiveTheme.of(context).mode ==
                            AdaptiveThemeMode.dark,
                        onChanged: (v) {
                          final bool isDark = AdaptiveTheme.of(context).mode ==
                              AdaptiveThemeMode.dark;
                          setState(() {
                            if (isDark) {
                              AdaptiveTheme.of(context).setLight();
                            } else {
                              AdaptiveTheme.of(context).setDark();
                            }
                          });
                        },
                      ),
                      const Icon(Icons.dark_mode),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
