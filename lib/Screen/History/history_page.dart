import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:yummy/Model/CartModel.dart';
import 'package:yummy/Screen/NoDataPage/no_data_page.dart';
import 'package:yummy/data/controller/cart_controller.dart';
import 'package:yummy/utils/colors.dart';
import 'package:yummy/utils/dimension.dart';
import 'package:yummy/widgets/Big_text.dart';
import 'package:yummy/widgets/small_text.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CartModel> historyData = Get.find<CartController>().getCartHistory().reversed.toList();
    Map<String, int> _cartItemsPerOrder = {};
    int perOrderIndex = 0;


    if(historyData.isNotEmpty){
      historyData.forEach((element) {

        if(_cartItemsPerOrder.containsKey(element.time))
        {
          _cartItemsPerOrder.update(element.time!, (value) => ++value);
        }else{
          _cartItemsPerOrder.putIfAbsent(element.time!, () => 1);
        }

      });
    }

    List<int> getPerOrderList(){
      return _cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<int> cartItemsPerOrderList =  getPerOrderList();


    String getFormattedDate(String unformattedDate){
      final DateFormat formatter = DateFormat('yyyy/MM/dd hh:mm a');
      return formatter.format(DateTime.parse(unformattedDate)).toString();
    }

    return Scaffold(
      body: GetBuilder<CartController>(builder: (cartController){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                height: Dimension.height20*5,
                width: Dimension.screenWidth,
                color: AppColors.mainColor,
                padding: EdgeInsets.symmetric(horizontal: Dimension.width45, vertical: Dimension.height20),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const BigText(text: "Cart History", color: Colors.white,),

                    //clear history
                    Padding(
                      padding:  EdgeInsets.only(top:Dimension.height20*1.5),
                      child: IconButton(
                          onPressed: (){
                            cartController.clearCartHistory();
                          },
                          icon: const Icon(Icons.delete, color: Colors.white,)),
                    )
                  ],
                ),
              ),

              cartController.getHistoryData.isEmpty
                  ? const Expanded(child: NoDataPage(text: "No History Found!", imgUrl: "images/empty-cart.png",))
                  :Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for(int i = 0; i<historyData.length; i+= cartItemsPerOrderList[perOrderIndex], perOrderIndex++, )
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: Dimension.height20, ),
                          margin: EdgeInsets.only(bottom: Dimension.height20, ),
                          child: Column(
                            children: [
                              //date
                              Align(
                                alignment: Alignment.topLeft,
                                  child: BigText(text: getFormattedDate(historyData[i].time!), color: AppColors.mainBlackColor,)),

                              SizedBox(height: Dimension.height10,),

                              //img
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Expanded(
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing:Dimension.height10/2,
                                      runSpacing: Dimension.height10/2,
                                      children: List.generate(cartItemsPerOrderList[perOrderIndex], (index) {
                                        CartModel product = historyData[i + index];

                                        return ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(Dimension.radius15)),
                                          child: Image.network(
                                            dotenv.env['BASE_URL']! + product.img!,
                                            height: Dimension.height45*1.8,
                                            width: Dimension.height45*1.8,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),


                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SmallText(text: "total", color: AppColors.mainBlackColor,),
                                      BigText(text: "${cartItemsPerOrderList[perOrderIndex]} items", size: 15,),
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.mainColor,
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: (){},
                                          child: const SmallText( text:"one more", color: AppColors.mainColor,))
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )

                    ],
                  ))
            ],
          ),
        );
      },),
    );
  }


}
