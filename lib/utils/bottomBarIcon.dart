import 'package:flutter/material.dart';

class BottomBarIcon extends StatelessWidget {
  const BottomBarIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.labelName,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final String labelName;

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: Colors.grey,
      ),
      label: labelName,
      selectedIcon: Icon(
        icon,
        color: color,
      ),
    );
  }
}
