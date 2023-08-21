import 'package:flutter/material.dart';
import 'package:yummy/Model/CartModel.dart';
import 'package:yummy/data/controller/auth_controller.dart';
import 'package:yummy/data/controller/cart_controller.dart';
import 'package:yummy/data/controller/lock_controller.dart';

import 'package:yummy/data/controller/popular_product_controller.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/utils/dimension.dart';
import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/app_icon.dart';
import 'package:get/get.dart';
import 'package:yummy/widgets/small_text.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../Routes/app_routes.dart';
import '../../data/controller/recommended_product_controller.dart';
import '../NoDataPage/no_data_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCartEmpty = Get.find<CartController>().getItems.isEmpty;
    return Scaffold(
            body: Stack(
              children: [

                isCartEmpty
                    ? const NoDataPage(
                  text: "Your cart is Empty.Try something!",
                  imgUrl: 'images/empty-cart.png',
                )
                    :Positioned(
                    top: Dimension.height20 * 5,
                    left: Dimension.width20,
                    right: Dimension.width20,
                    child:
                        GetBuilder<CartController>(builder: (cartController) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: cartController.getItems.length,
                          itemBuilder: (_, index) {
                            CartModel products = cartController.getItems[index];
                            return cartItem(products, cartController);
                          });
                    })),

                //icon buttons
                Positioned(
                    top: Dimension.height20 * 3,
                    left: Dimension.width20,
                    right: Dimension.width20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppIcon(
                          onTap: () {
                            Get.find<PopularProductController>().updateTotalItemsInCart();
                            // Get.find<PopularProductController>().updateQuantity();
                            Get.back();
                          },
                          icon: Icons.arrow_back_ios,
                          fgColor: Colors.white,
                          bgColor: AppColors.mainColor,
                          size: Dimension.iconSize24,
                        ),
                        SizedBox(
                          width: Dimension.width20 * 5,
                        ),
                        AppIcon(
                          onTap: () {
                            Get.offNamed(AppRoutes.getInitial());
                          },
                          icon: Icons.home_outlined,
                          fgColor: Colors.white,
                          bgColor: AppColors.mainColor,
                          size: Dimension.iconSize24,
                        ),
                        AppIcon(
                          onTap: () {},
                          icon: Icons.shopping_cart_outlined,
                          fgColor: Colors.white,
                          bgColor: AppColors.mainColor,
                          size: Dimension.iconSize24,
                        ),
                      ],
                    )),
              ],
            ),
            bottomNavigationBar: GetBuilder<PopularProductController>(
                builder: (popularProducts) {
              return Container(
                height: Dimension.bottomHeight120,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimension.width20,
                    vertical: Dimension.height30),
                decoration: BoxDecoration(
                  color: AppColors.buttonBgColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimension.radius20 * 2),
                    topLeft: Radius.circular(Dimension.radius20 * 2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !isCartEmpty,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimension.width20,
                            vertical: Dimension.height15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(Dimension.radius20),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(.1),
                              )
                            ]),
                        child: Center(
                            child: BigText(
                                text:
                                    "\$${popularProducts.calTotalCartAmount()}")),
                      ),
                    ),

                    //checkout btn
                    Visibility(
                      visible: !isCartEmpty,
                      child: InkWell(
                        onTap: () {
                          if(Get.find<AuthController>().isUserExists())
                          {
                            if(Get.find<LockController>().userAddressModel !=null)
                            {
                              Get.toNamed(AppRoutes.getAddAddressPage());
                            }else{
                              Get.find<CartController>().addCartDataToHistory();
                            }
                          }else{
                            Get.toNamed(AppRoutes.getLoginPage());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          width: Dimension.screenWidth / 2.2,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimension.radius15),
                            color: AppColors.mainColor,
                          ),
                          child: const Center(
                              child: SmallText(
                            text: "Checkout",
                            size: 15,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          );
  }

  Widget cartItem(CartModel cartProduct, CartController cartController){
    return GetBuilder<PopularProductController>(builder: (controller){
      return Container(
        width: double.maxFinite,
        height: Dimension.height20*6,
        margin: EdgeInsets.only(bottom: Dimension.height10),
        child: Row(
          children: [

            //image
            GestureDetector(
              onTap: (){
                var idx = controller.popularProductList.indexOf(cartProduct.product);
                if(idx.isNegative){
                    idx = Get.find<RecommendedProductController>().recommendedProductList.indexOf(cartProduct.product);
                    Get.toNamed(AppRoutes.getRecommendedFood(idx));
                }else{
                  Get.toNamed(AppRoutes.getPopularFood(idx));
                }
              },
              child: Container(
                height: Dimension.height20*5,
                width: Dimension.width20*5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimension.radius15),
                  image:  DecorationImage(
                    image: NetworkImage(dotenv.env['BASE_URL']! + cartProduct.img!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SizedBox(width: Dimension.width10,),

            //details
            Expanded(
                child: SizedBox(
                  height: Dimension.height20*6,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Row(
                        children: [
                          Expanded(child: BigText(text: cartProduct.name!, overflow: TextOverflow.ellipsis,)),
                          IconButton(
                              onPressed: (){controller.removeToCart(cartProduct);},
                              icon:  const Icon(Icons.close, color: AppColors.textColor,))

                        ],
                      ),

                      const SmallText(text: "Spicy"),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BigText(text: "\$${cartProduct.price! * cartProduct.quantity!}", size: 18, color: AppColors.mainColor,),

                          Container(
                            height: Dimension.height45,
                            padding:  EdgeInsets.symmetric(horizontal: Dimension.height10 ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(Dimension.radius20),
                              boxShadow: const [
                                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(1,1), blurRadius: 2, spreadRadius: 1),
                              ]
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    cartProduct.quantity! > 1
                                        ?cartController.addItem(cartProduct.product!, -1)
                                        :controller.removeToCart(cartProduct);

                                    controller.updateTotalItemsInCart();
                                  },
                                  icon: const Icon(Icons.remove), color: AppColors.textColor,),

                                BigText(text: "${cartProduct.quantity!}"),

                                IconButton(
                                  onPressed: (){
                                    cartProduct.quantity! <20
                                        ?cartController.addItem(cartProduct.product!, 1)
                                        :Get.snackbar("Item Count", "You can't add more");

                                    controller.updateTotalItemsInCart();
                                  },
                                  icon: const Icon(Icons.add), color: AppColors.textColor,)
                              ],
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      );
    });
  }
}
