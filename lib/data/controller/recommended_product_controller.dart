import 'package:get/get.dart';
import '../../Model/products_model.dart';
import '../repository/recommended_product_repo.dart';

class RecommendedProductController extends GetxController{
  late RecommendedProductRepo recommendedProductRepo;
  List<dynamic> _recommendedProductList = [];
  List<dynamic> get recommendedProductList => _recommendedProductList;

  RecommendedProductController({required this.recommendedProductRepo});

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;


  Future<void> getRecommendedProductList() async{

    Response res =await recommendedProductRepo.getRecommendedProductList();
    if(res.statusCode ==200){
      _recommendedProductList = [];
      _recommendedProductList.addAll(Product.fromJson(res.body).products);
      _isLoaded = true;
      update();
    }
    else{

    }
  }

}