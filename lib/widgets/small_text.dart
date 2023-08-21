import 'package:flutter/material.dart';
import 'package:yummy/utils/dimension.dart';

class SmallText extends StatelessWidget {
  final double size;
  final String text;
  final TextOverflow overflow;
  final double lineHeight;
  final Color color;

  const SmallText({
    super.key,
     this.size =12 ,
    required this.text,
    this.overflow = TextOverflow.ellipsis,
    this.color = const Color(0xffccc7c5),
     this.lineHeight = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // maxLines: 1,
      style: TextStyle(
          color: color,
          fontSize: size ==12 ? Dimension.font26/2 : size,
          overflow: overflow,
          height: lineHeight
      ),
    );
  }
}
