import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yummy/Model/products_model.dart';
import 'package:yummy/Routes/app_routes.dart';
import 'package:yummy/Screen/food/expandable_text.dart';
import 'package:yummy/data/controller/recommended_product_controller.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/utils/dimension.dart';
import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/app_icon.dart';
import 'package:get/get.dart';
import '../../data/controller/cart_controller.dart';
import '../../data/controller/popular_product_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../widgets/small_text.dart';

class RecommendedFoodDetail extends StatelessWidget {
  final int pageId;
  const RecommendedFoodDetail({Key? key, required this.pageId, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductModel product = Get.find<RecommendedProductController>().recommendedProductList[pageId];
    Get.find<PopularProductController>().initProduct(Get.find<CartController>(), product.id!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.yellowColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(
                    onTap: (){Get.back();},
                    icon: Icons.clear,
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
                                  onTap: () {
                                    Get.toNamed(AppRoutes.getCartPage());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(Dimension.height10),
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
                                ))
                            : Container(),
                      ],
                  );
                })


              ],
            ),
            flexibleSpace:  FlexibleSpaceBar(
              background: Image.network( dotenv.env["BASE_URL"]! + product.img!,
                fit: BoxFit.cover,
                width: double.maxFinite,
              ),

            ),
            bottom: PreferredSize(
              preferredSize:  Size.fromHeight(Dimension.height30),
            child: Container(
              width: double.maxFinite,
              padding:  EdgeInsets.only(top: Dimension.height10/2, bottom: Dimension.height10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimension.radius15),
                    topRight: Radius.circular(Dimension.radius15)),
                color: Colors.white,
              ),
              child:  Center(child: BigText(size: Dimension.font20, text: product.name!)),
            ),),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin:  EdgeInsets.only(left: Dimension.width20, right: Dimension.width20),
                  child:  ExpandableText(text: product.description!),
                )
              ],
            ),
          ),
        ],
      ),
        bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: Dimension.height10,
                  bottom: Dimension.height10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon(
                        onTap: (){ controller.setQuantity(false); },
                        icon: Icons.remove,
                        fgColor:Colors.white,
                        bgColor: AppColors.mainColor,
                        size: Dimension.iconSize16),

                    SizedBox(width: Dimension.width15,),

                    BigText(text: "\$${product.price} X ${controller.quantity + controller.itemQuantityInCart}", color: AppColors.mainBlackColor,
                      size: Dimension.font26,),

                    SizedBox(width: Dimension.width15,),


                    AppIcon(onTap: (){ controller.setQuantity(true); },
                        icon: Icons.add,
                        fgColor:Colors.white,
                        bgColor: AppColors.mainColor,
                        size: Dimension.iconSize16),
                  ],
                ),
              ),
              Container(
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
                        height:Dimension.height45 *1.2,
                        width: Dimension.width45 * 1.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Dimension.radius15),
                          boxShadow:  [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(2,2),
                              blurRadius: 5,
                            )
                          ]
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: (){},
                            icon: Icon(CupertinoIcons.heart_fill,
                              color: AppColors.mainColor,
                              size: Dimension.iconSize24,),
                          )
                        )
                    ),
                    InkWell(
                      onTap: (){ controller.addToCart(product); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimension.radius15),
                          color: AppColors.mainColor,
                        ),
                        child:  Center(child: BigText(text: "\$${product.price!} | Add to cart ", size: 15, color: Colors.white,)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        })

    );
  }
}
