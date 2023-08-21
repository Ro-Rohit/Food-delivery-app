import 'package:flutter/material.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/utils/dimension.dart';
import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/small_text.dart';

import '../../data/controller/popular_product_controller.dart';
import '../../data/controller/recommended_product_controller.dart';
import './home_page_body.dart';
import 'package:get/get.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            pageHeader(),
            const HomePageBody(),
          ],
        )
      ),
    );
  }

  Widget pageHeader(){
    return Container(
      height: 70,
      width: double.maxFinite,
      padding:  EdgeInsets.all(Dimension.width10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BigText(text: "India"),
              Row(
                children:  [
                  const SmallText(text: "Raipur", color: Colors.black54,),
                  SizedBox(width:Dimension.width10/2,),
                  const Icon(Icons.arrow_drop_down, color: Colors.black, )
                ],
              )
            ],
          ),
          searchButton(),
        ],
      ),
    );
  }

  Widget searchButton(){
    return Container(
      width: Dimension.iconSize24 *2,
      height:Dimension.iconSize24 *2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimension.radius15),
          color: AppColors.mainColor
      ),
      child: Center(
          child:IconButton(
              icon: const Icon(Icons.search, color:Colors.white),
              onPressed: (){}
          )
      ),
    );
  }
}
