class Product{
  late List<ProductModel> _products;
  List<ProductModel> get products => _products;

  Product({required products}){
    _products = products;
  }

  Product.fromJson(Map<String, dynamic>json){
    if(json["data"] !=null){
      _products = <ProductModel> [];
      json["data"].forEach((json){

        _products.add(
            ProductModel(
                id : json['id'],
                name :json["attributes"]['name'],
                description : json["attributes"]['description'],
                price : int.parse(json["attributes"]['price']),
                stars : json["attributes"]['stars'],
                img : json["attributes"]['image']["data"]["attributes"]["url"],
                location : json["attributes"]['location'],
                createdAt : json["attributes"]['createdAt'],
                updatedAt :  json["attributes"]['updatedAt'],
                typeId : int.parse(json["attributes"]['typeid']),
            )
        );
      });
    }
  }

}


class ProductModel{
  int? id;
  String? name;
  String? description;
  int? price;
  int? stars;
  String? img;
  String? location;
  String? createdAt;
  String? updatedAt;
  int? typeId;


  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stars,
    this.img,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.typeId,
});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stars = json['stars'];
    img = json["img"];
    location = json['location'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    typeId = json['typeId'];
  }



  Map<String, dynamic> toJson(){
    return {
      "id" : id,
      "name" : name,
      "description" : description,
      "price" : price,
      "stars" : stars,
      "img" : img,
      "location" : location,
      "createdAt" : createdAt,
      "updatedAt" : updatedAt,
      "typeId": typeId
    };
  }
}