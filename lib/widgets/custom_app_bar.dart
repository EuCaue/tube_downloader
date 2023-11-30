import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  const CustomAppBar(
      {super.key, required this.scaffoldKey, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 32,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onBackground,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () =>scaffoldKey.currentState?.openDrawer(),
        child: Container(
          margin: const EdgeInsets.all(5),
          child: const Icon(Icons.menu, size: 42),
        ),
      ),
    );
  }
}
