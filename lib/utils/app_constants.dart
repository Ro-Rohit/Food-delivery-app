class AppConstants{
  static const String APP_NAME = 'Yummy';
  static const int APP_VERSION = 1;

  static const String POPULAR_PRODUCT_URI = '/api/prods?populate=*&filters[categories][\$eq]=popularProduct';
  static const String RECOMMENDED_PRODUCT_URI = '/api/prods?populate=*&filters[categories][\$eq]=RecommendedProduct';

  static const String CART_DATA = 'Cart_List';
  static const String CART_HISTORY_DATA = 'CART_HISTORY_DATA';

  //address
  static const String USER_ADDRESS = 'USER_ADDRESS';

  static const String REGISTRATION_URI = '/api/v1/auth/registration';
  static const String PHONE = '';
  static const String PASSWORD = '';

}