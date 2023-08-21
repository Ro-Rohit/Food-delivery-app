import 'package:flutter/material.dart';
import 'package:yummy/Model/products_model.dart';
import 'package:yummy/Routes/app_routes.dart';
import 'package:yummy/data/controller/popular_product_controller.dart';
import 'package:yummy/utils/app_constants.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/utils/dimension.dart';

import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/small_text.dart';
import 'package:yummy/widgets/text_icon.dart';
import 'package:get/get.dart';

import 'package:dots_indicator/dots_indicator.dart';

import '../../data/controller/recommended_product_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  PageController bannerController = PageController(viewportFraction: 0.88);
  var _currentPageValue = 0.0;
  double scaleFactor = 0.8;
  double bannerHeight = Dimension.pageViewContainer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bannerController.addListener(() {
      setState(() {
        _currentPageValue = bannerController.page!;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children:[
            //popular food Slider
            SizedBox(
              height: Dimension.pageView,
                child: popularFoodBanner()),

            //Dots
            dotIndicator(),

            //Recommended text
            Container(
              height: Dimension.height30,
              width: double.maxFinite,
              padding:  EdgeInsets.only(left: Dimension.width15),
              margin:  EdgeInsets.only(top:Dimension.height30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:  [
                  const BigText(size: 22, text: "Recommended", color: AppColors.mainBlackColor,),
                  SizedBox(width: Dimension.width10/2),
                  const SmallText( text: "."),
                  SizedBox(width: Dimension.width10/2,),
                  const SmallText( text: "food pairing",)
                ],
              ),
            ),

            SizedBox(height: Dimension.height20,),

            //Recommended Food
            GetBuilder<RecommendedProductController>(builder: (recommendedProducts){
              return recommendedProducts.isLoaded
                  ?  ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recommendedProducts.recommendedProductList.length,
                  itemBuilder: (context, index){
                    ProductModel product = recommendedProducts.recommendedProductList[index];

                    return recommendedFoodItem(product, index);
                  })
                  :  const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),);

            })

          ]
        ),
      ),
    );
  }

  Widget popularFoodBanner(){
    return GetBuilder<PopularProductController>(builder: (popularProducts) {
      return popularProducts.isLoaded
          ?  PageView.builder(
          itemCount: popularProducts.popularProductList.length,
          controller: bannerController,
          itemBuilder: (context, index){
            Matrix4 matrix = matrixCalc(index);
            ProductModel product = popularProducts.popularProductList[index];

            return GestureDetector(
              onTap: (){ Get.toNamed(AppRoutes.getPopularFood(index)); },
              child: Transform(
                transform: matrix,
                child: Stack(
                  children: [
                    Container(
                      height:Dimension.pageViewContainer,
                      width: double.maxFinite,
                      margin:  EdgeInsets.only(left: Dimension.width10, right: Dimension.width10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimension.radius30),
                          color: Colors.yellow,
                          image:  DecorationImage(
                              image:  NetworkImage(dotenv.env["BASE_URL"]! + product.img!,),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: popularFoodItemDetails(index, product)
                    ),
                  ],
                ),
              ),
            );
          })
          : const Center(child: CircularProgressIndicator(color: AppColors.mainColor),);
    });

  }

  Widget popularFoodItemDetails(int index, ProductModel product){
    return Container(
      height:Dimension.pageViewTextContainer,
      width: double.maxFinite,
      margin:  EdgeInsets.only(
          left: Dimension.width15 * 1.5,
          right: Dimension.width15 * 1.5,
          bottom: Dimension.height10,
      ),
      padding:  EdgeInsets.only(
          left: Dimension.width15,
          right: Dimension.width15,
          bottom: Dimension.height10,
          top: Dimension.height10/5
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimension.radius30),
          color:Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0,2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ]
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
             BigText(text: product.name!, color: AppColors.mainBlackColor,),
             SizedBox(height: Dimension.height10),

            Row(
            children: [
              Wrap(
                children:List.generate(product.stars!, (index) =>  Icon(Icons.star,
                  color: AppColors.mainColor,
                  size: Dimension.iconSize16,),
                ),
              ),
              SizedBox(width: Dimension.width10),
              const SmallText( text: "4.5"),
              SizedBox(width: Dimension.width10),
              const SmallText(text: "1287"),
              SizedBox(width: Dimension.width10),
              const SmallText(text: "comments")

            ],
          ),
             SizedBox(height: Dimension.height20),

            const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              TextIcon(
                  icon: Icons.circle_sharp,
                  iconColor: AppColors.yellowColor,
                  text: "Normal"),
              TextIcon(
                  icon: Icons.location_on,
                  iconColor: AppColors.mainColor,
                  text: "1.7 km"),
              TextIcon(
                  icon: Icons.alarm_outlined,
                  iconColor: AppColors.iconColor2,
                  text: "32 min"),
            ],
          ),
        ],
      )

    );
  }

  Matrix4 matrixCalc(int index){
    Matrix4 matrix = Matrix4.identity();

    if(index == _currentPageValue.floor()){
      var currScale = 1- (_currentPageValue - index) * (1-scaleFactor);
      var currTrans = bannerHeight * (1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }

    else if(index == _currentPageValue.floor()+1){
      var currScale = scaleFactor + (_currentPageValue - index +1) * (1-scaleFactor);
      var currTrans = bannerHeight * (1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }

    else if(index == _currentPageValue.floor() -1){
      var currScale = 1- (_currentPageValue - index) * (1-scaleFactor);
      var currTrans = bannerHeight * (1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }

    else{
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, bannerHeight*(1-scaleFactor), 0);
    }

    return matrix;
  }

  Widget dotIndicator(){
    return GetBuilder<PopularProductController>(builder: (popularProducts){

      return popularProducts.isLoaded
          ? SizedBox(
        height: Dimension.height20,
        width: double.maxFinite,
        child: Center(
          child: DotsIndicator(
            dotsCount: popularProducts.popularProductList.isEmpty
                ? 1
                : popularProducts.popularProductList.length,
            position: _currentPageValue,

            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeColor: AppColors.mainColor,
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimension.radius15/3)),
            ),
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),);
    });
  }


  Widget recommendedFoodItem(ProductModel product, int index){
    return GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.getRecommendedFood(index));
      },
      child: Container(
        margin:  EdgeInsets.only(left:Dimension.width10, right: Dimension.width10, bottom: Dimension.height10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // food Image
            Container(
              height: Dimension.listViewImg,
              width: Dimension.listViewImg,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimension.radius20),
                  color: Colors.white38,
                  image:  DecorationImage(
                    image: NetworkImage(dotenv.env["BASE_URL"]! + product.img!),
                    fit: BoxFit.contain,
                  )

              ),
            ),
            recommendedFoodItemDetails(product),
          ],
        ),
      ),
    );

  }

  Widget recommendedFoodItemDetails(ProductModel product){
    return Expanded(
      child: Container(
        height: Dimension.listViewTextConSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimension.radius20),
              bottomLeft: Radius.circular(Dimension.radius20)
          ),
        ),
        padding:  EdgeInsets.only(left: Dimension.width10, right: Dimension.width10),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

          children:  [
             BigText(text: product.name!, color: AppColors.mainBlackColor,),
            SizedBox(height: Dimension.height10,),
            const SmallText(text: "with chinese characteristics"),
            SizedBox(height: Dimension.height10,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                TextIcon(
                    icon: Icons.circle_sharp,
                    iconColor: AppColors.yellowColor,
                    text: "Normal"),
                TextIcon(
                    icon: Icons.location_on,
                    iconColor: AppColors.mainColor,
                    text: "1.7 km"),
                TextIcon(
                    icon: Icons.alarm_outlined,
                    iconColor: AppColors.iconColor2,
                    text: "32 min"),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
