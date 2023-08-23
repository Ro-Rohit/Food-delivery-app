import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final Color fgColor;
  final Color bgColor;
  final double size;
  const AppIcon({Key? key, required this.onTap, required this.icon, required this.fgColor, required this.bgColor, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
        ),
        child: Center(
          child: Icon(icon, size: size, color: fgColor,),
        ),
      ),
    );
  }
}
