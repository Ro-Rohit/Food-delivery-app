import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yummy/Routes/app_routes.dart';
import 'package:yummy/Screen/food/expandable_text.dart';
import 'package:yummy/data/controller/cart_controller.dart';
import 'package:yummy/utils/app_constants.dart';
import 'package:yummy/utils/dimension.dart';
import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/app_icon.dart';
import 'package:get/get.dart';
import '../../Model/products_model.dart';
import '../../utils/colors.dart';
import '../../widgets/small_text.dart';
import '../../widgets/text_icon.dart';
import 'package:yummy/data/controller/popular_product_controller.dart';
import 'package:get/get.dart';

class PopularFoodDetail extends StatelessWidget {
  final int pageId;
  const PopularFoodDetail({Key? key, required this.pageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductModel product = Get.find<PopularProductController>().popularProductList[pageId];
      Get.find<PopularProductController>().initProduct(Get.find<CartController>(), product.id!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          //image
          Positioned(
            left: 0,
              right: 0,
              top: 0,
              child: Container(
                height: Dimension.popularFoodSize,
                decoration:  BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(dotenv.env["BASE_URL"]! + product.img!),
                    fit: BoxFit.fill
                  )
                ),
              )),

          //icon
          Positioned(
              left: Dimension.width20,
              right: Dimension.width20,
              top: Dimension.height30 *2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIcon(
                      onTap: (){ Get.back();},
                      icon: Icons.arrow_back_ios,
                      fgColor: AppColors.mainBlackColor,
                      bgColor: Colors.white.withOpacity(0.8),
                      size: Dimension.iconSize24),

                  GetBuilder<PopularProductController>(builder: (controller){
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          child: AppIcon(
                              onTap: (){Get.toNamed(AppRoutes.getCartPage());},
                              icon: Icons.shopping_cart_outlined,
                              fgColor: AppColors.mainBlackColor,
                              bgColor: Colors.white.withOpacity(0.8),
                              size: Dimension.iconSize24),
                        ),
                          controller.totalItemsInCart != 0
                              ? Positioned(
                                top: -10,
                                right: -2,
                                child: GestureDetector(
                                  onTap: (){Get.toNamed(AppRoutes.getCartPage());},
                                  child: Container(
                                        padding:
                                            EdgeInsets.all(Dimension.height10),
                                        decoration: const BoxDecoration(
                                          color: AppColors.yellowColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SmallText(
                                          text: controller.totalItemsInCart
                                              .toString(),
                                          color: AppColors.mainBlackColor,
                                          size: 12,
                                        ),
                                      ),
                                ),
                              )
                              : Container(),
                        ],
                    );
                  })


                ],)),


          Positioned(
              left: 0,
              right: 0,
              top: Dimension.popularFoodSize -30,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimension.height20,
                    left: Dimension.width20,
                    right:Dimension.width20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimension.radius20),
                      topRight: Radius.circular(Dimension.radius20),)
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    BigText(text: product.name!, size: Dimension.font26, color: AppColors.mainBlackColor,),
                    SizedBox(height: Dimension.height10,),

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
                    SizedBox(height: Dimension.height20,),

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
                    SizedBox(height: Dimension.height15,),

                    const BigText(text: "Introduce", color: AppColors.mainBlackColor, ),
                    SizedBox(height: Dimension.height30,),

                     Expanded(
                      child: SingleChildScrollView(
                        child: ExpandableText(text: product.description!),
                      ),
                    )

                  ],
                ),
              ))

        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (popularProducts){
        return Container(
          height: Dimension.bottomHeight120,
          padding: EdgeInsets.symmetric(horizontal: Dimension.width20, vertical: Dimension.height30),
          decoration: BoxDecoration(
            color: AppColors.buttonBgColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimension.radius20 *2),
              topLeft: Radius.circular(Dimension.radius20 *2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: Dimension.height45 *2,
                padding:  EdgeInsets.symmetric(horizontal: Dimension.height15 ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimension.radius20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        popularProducts.setQuantity(false);
                        },
                      icon: const Icon(Icons.remove), color: AppColors.textColor,),

                    SizedBox(width: Dimension.width10/2,),
                     BigText(text: "${popularProducts.quantity + popularProducts.itemQuantityInCart}"),

                    SizedBox(width: Dimension.width10/2,),
                    IconButton(
                      onPressed: (){
                        popularProducts.setQuantity(true);
                        },
                      icon: const Icon(Icons.add), color: AppColors.textColor,)
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  popularProducts.addToCart(product);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  width: Dimension.screenWidth/2.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimension.radius15),
                    color: AppColors.mainColor,
                  ),
                  child:  Center(
                      child: SmallText(
                        text: "\$${product.price!} | Add to cart ",
                        size: 15, color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      )
                  ),
                ),
              )
            ],
          ),
        );
      })
    );
  }
}
