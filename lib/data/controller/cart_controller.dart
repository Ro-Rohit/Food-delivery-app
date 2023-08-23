import 'package:get/get.dart';
import '../../Model/products_model.dart';
import '../repository/cart_repo.dart';
import 'package:yummy/Model/CartModel.dart';

class CartController extends GetxController{
  final CartRepo cartRepo;
  List<CartModel> _storageItems = [];
  Map<int, CartModel> _items = {};
  List<CartModel> _historyItems = [];
  get getHistoryData => _historyItems;

  CartController({required this.cartRepo});

  void addItem(ProductModel product, int quantity){
    if(isItemExists(product.id)){
      _updateQuantity(product, quantity);
    }
    else{
        _addProduct(product, quantity);
    }
    update();
    cartRepo.addToCartStorage(getItems);
  }

  void removeItem(CartModel cartProduct){
    _items.remove(cartProduct.id);
    update();
  }

  bool isItemExists(int? id){
    return _items.containsKey(id!);
  }

  void _updateQuantity(ProductModel product, int quantity){
    _items.update(product.id!, (value) =>
      CartModel(
        id: value.id,
        name: value.name,
        price: value.price,
        img: value.img,
        quantity: value.quantity! + quantity,
        isExist: value.isExist,
        time: value.time,
        product: product,
      )
    );
  }

  void _addProduct(ProductModel product, int quantity){
    _items.putIfAbsent(product.id!, () =>
        CartModel(
          id: product.id,
          name: product.name,
          price: product.price,
          img: product.img,
          quantity:quantity,
          isExist: true,
          time: DateTime.now().toString(),
          product: product,
        )
    );
  }

  int totalItems(){
    var total = 0;
    _items.forEach((productId, cart) { total += cart.quantity!; }) ;
    return total;
  }

  int getQuantityByProductId(int id){

    if( isItemExists(id) ){
      CartModel? product = _items.entries.firstWhere((cartProduct) => cartProduct.key ==id).value;
      return product.quantity!;
    }
    else{
      return 0;
    }


  }

  List<CartModel> get getItems {
    return _items.entries.map((cartProduct) => cartProduct.value).toList();
  }


  //--------local storage logic-----

void setStorageData(){
    setStorageItems = cartRepo.getCartStorageData();
}

set setStorageItems(List<CartModel> dataList){
    _storageItems = dataList;

    for (var element in _storageItems) {
      _items.putIfAbsent(element.id!, () => element);
    }
}


void addCartDataToHistory(){
    cartRepo.addCartDataToHistory();
    _historyItems = _storageItems;
    _storageItems = [];
    _items = {};
    update();
}

List<CartModel> getCartHistory() {
    _historyItems =  cartRepo.getCartHistoryData();
    return _historyItems;
}

void clearCartHistory(){
    _historyItems.clear();
    cartRepo.clearCartHistory();
    update();
}
}
