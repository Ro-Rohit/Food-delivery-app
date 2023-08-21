import 'package:flutter/material.dart';
import 'package:yummy/utils/dimension.dart';

class BigText extends StatelessWidget {
  final double size;
  final String text;
  final TextOverflow overflow;
  final Color color;

  const BigText({
    super.key,
     this.size =20,
    required this.text,
    this.overflow = TextOverflow.ellipsis,
    this.color = const Color(0xff89dad0),
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size == 20 ? Dimension.font20 : size,
          overflow: overflow,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500),
    );
  }
}
