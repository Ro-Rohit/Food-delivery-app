import 'package:flutter/material.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/utils/dimension.dart';
import 'package:yummy/widgets/Big_text.dart';


class AccountTile extends StatelessWidget {
  final Color iconBgColor;
  final IconData icon;
  final String text;
  const AccountTile({Key? key, required this.iconBgColor, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimension.screenWidth,
      margin: EdgeInsets.symmetric(horizontal: Dimension.width10, vertical: Dimension.height10),
      padding: EdgeInsets.symmetric(horizontal: Dimension.width10, vertical: Dimension.height15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle
            ),
            child: Center(child: Icon(icon, color: Colors.white,),),
          ),
          SizedBox(width: Dimension.width30,),
          Expanded(child: BigText(text: text, color: AppColors.mainBlackColor, overflow: TextOverflow.ellipsis,))
        ],
      ),
    );
  }
}
