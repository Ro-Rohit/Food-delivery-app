import 'package:flutter/material.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/utils/dimension.dart';

import '../../widgets/Big_text.dart';

class NoDataPage extends StatelessWidget {
  final String text;
  final String imgUrl;
  const NoDataPage({Key? key, required this.text, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: Dimension.height45),
              child: Image.asset(imgUrl,),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimension.width15),
                child: BigText(text:text, color: AppColors.textColor, size: 15,)),
          ],
        ),
      ),
    );
  }
}
