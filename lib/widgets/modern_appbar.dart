import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showBackButton;
  final double elevation;

  const ModernAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.showBackButton = true,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 1,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: const Color.fromARGB(255, 9, 57, 81),
      elevation: elevation,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
