import 'package:get/get.dart';
import 'package:yummy/data/controller/cart_controller.dart';

import '../../Model/CartModel.dart';
import '../../Model/products_model.dart';
import '../repository/popular_product_repo.dart';
import '../../widgets/custom_snackbar.dart';

class PopularProductController extends GetxController{
  late PopularProductRepo popularProductRepo;
  late CartController _cartController;

  List<dynamic> _popularProductList = [];
  List<dynamic> get popularProductList => _popularProductList;

  PopularProductController({required this.popularProductRepo});

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _quantity = 0;
  int _totalItemsInCart = 0;
  int _itemQuantityInCart = 0;
  int get  quantity => _quantity;
  int get totalItemsInCart => _totalItemsInCart;
  int get itemQuantityInCart => _itemQuantityInCart;




  Future<void> getPopularProductList() async{

     Response res =await popularProductRepo.getPopularProductList();
     print(res.statusText);
     if(res.statusCode ==200){
       _popularProductList = [];
       _popularProductList.addAll(Product.fromJson(res.body).products);
       _isLoaded = true;
       update();
     }
     else{
        print("error on Product on Controller: data not fetched");
     }
  }

  void setQuantity(bool isIncrement){
    if(isIncrement){
      _quantity = checkQuantity(++_quantity);
    }
    else{
      _quantity = checkQuantity(--_quantity);
    }
    update();
  }

  int checkQuantity(int quantity){
    if(_itemQuantityInCart + quantity < 0){
      showCustomSnackBar("You can't reduce more!", title: "Item Count", isError: false);
      return 0;
    }
    else if(_itemQuantityInCart + quantity > 20){
      showCustomSnackBar("You can't add more!", title: "Item Count", isError: false);
      return 20;
    }
    else{ return quantity; }
  }

  void initProduct(CartController cart, int productId,){
      _quantity= 0;
      _cartController = cart;

      _totalItemsInCart = _cartController.totalItems();
    _itemQuantityInCart = _cartController.getQuantityByProductId(productId);
  }

  void updateTotalItemsInCart(){
    _totalItemsInCart = _cartController.totalItems();
    update();
  }

  void updateQuantity(){
    _quantity = 0;
    update();
  }

  void addToCart(ProductModel product){
    if(_quantity + _itemQuantityInCart >0){
      _cartController.addItem(product, quantity);
      _quantity = 0;
      _totalItemsInCart = _cartController.totalItems();
      _itemQuantityInCart = _cartController.getQuantityByProductId(product.id!);
      update();
    }
    else{
      showCustomSnackBar("Item can't be null", title: "Item Count",);
    }
  }


  void removeToCart(CartModel cartProduct){
    _cartController.removeItem(cartProduct);
    _totalItemsInCart = _cartController.totalItems();
    update();
  }


  List<CartModel> get getItems {
    return _cartController.getItems;
  }


  int calTotalCartAmount(){
    int total = 0;
    for (var element in getItems) {
      total += element.quantity! * element.price!;
    }
    return total;
  }

}