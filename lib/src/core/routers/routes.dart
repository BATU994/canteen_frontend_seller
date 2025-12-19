class Routes {
  Routes._();
  static const String orders = '/orders';
  static const String shop = '/shop';
  static const String cart = 'cart';
  static const String nestedCart = '/shop/cart';
  static const String login = '/login';
  static const String register = '/register';
  static const String createProd = '/postprod';
  static const String nestedCreateProd = '/shop/postprod';
  // Order related routes
  static const String orderDetails = 'details';
  static const String orderDetailsPath = '$orders/$orderDetails';
}
