import 'package:flutter/material.dart';
import 'package:yummy/utils/dimension.dart';
import './small_text.dart';

class TextIcon extends StatelessWidget {
  final IconData icon;
  final  Color iconColor;
  final String text;
  const TextIcon({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
         SizedBox(width: Dimension.width10/2,),
        SmallText(text: text),
      ],
    );
  }
}
