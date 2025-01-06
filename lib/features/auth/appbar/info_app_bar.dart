import 'package:flutter/material.dart';
import '../../../core/const/colors.dart';

class InfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InfoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications, color: Colors.white),
          const SizedBox(width: 8),
          const Text('내정보', style: TextStyle(fontSize: 20)),
        ],
      ),
      centerTitle: true,
      backgroundColor: MAIN_YELLOW,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}