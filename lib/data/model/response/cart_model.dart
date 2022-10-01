import 'package:mechatronia_app/data/model/response/product_model.dart';

class CartModel {
  int _id;
  String _image;
  String _name;
  String _thumbnail;
  int _sellerId;
  String _sellerIs;
  String _seller;
  double _price;
  double _discountedPrice;
  int _quantity;
  int _maxQuantity;
  String _variant;
  String _color;
  Variation _variation;
  double _discount;
  String _discountType;
  double _tax;
  String _taxType;
  int shippingMethodId;
  String _cartGroupId;
  String _shopInfo;
  List<ChoiceOptions> _choiceOptions;
  List<int> _variationIndexes;

  CartModel(
      this._id,
      this._image,
      this._name,
      this._seller,
      this._price,
      this._discountedPrice,
      this._quantity,
      this._maxQuantity,
      this._variant,
      this._color,
      this._variation,
      this._discount,
      this._discountType,
      this._tax,
      this._taxType,
      this.shippingMethodId,
      this._cartGroupId,
      this._sellerId,
      this._sellerIs,
      this._thumbnail,
      this._shopInfo,
      this._choiceOptions,
      this._variationIndexes);

  String get variant => _variant;
  String get color => _color;
  Variation get variation => _variation;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int value) {
    _quantity = value;
  }

  int get maxQuantity => _maxQuantity;
  double get price => _price;
  double get discountedPrice => _discountedPrice;
  String get name => _name;
  String get seller => _seller;
  String get image => _image;
  int get id => _id;
  double get discount => _discount;
  String get discountType => _discountType;
  double get tax => _tax;
  String get taxType => _taxType;
  String get cartGroupId => _cartGroupId;
  String get sellerIs => _sellerIs;
  int get sellerId => _sellerId;
  String get thumbnail => _thumbnail;
  String get shopInfo => _shopInfo;
  List<ChoiceOptions> get choiceOptions => _choiceOptions;
  List<int> get variationIndexes => _variationIndexes;

  CartModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _seller = json['seller'];
    _thumbnail = json['thumbnail'];
    _sellerId = int.parse(json['seller_id'].toString());
    _sellerIs = json['seller_is'];
    _image = json['image'];
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price'];
    _quantity = int.parse(json['quantity'].toString());
    _maxQuantity = json['max_quantity'];
    _variant = json['variant'];
    _color = json['color'];
    _variation = json['variation'] != null ? Variation.fromJson(json['variation']) : null;
    _discount = json['discount'].toDouble();
    _discountType = json['discount_type'];
    _tax = json['tax'].toDouble();
    _taxType = json['tax_type'];
    shippingMethodId = json['shipping_method_id'];
    _cartGroupId = json['cart_group_id'];
    _shopInfo = json['shop_info'];
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions.add(new ChoiceOptions.fromJson(v));
      });
    }
    _variationIndexes = json['variation_indexes'] != null ? json['variation_indexes'].cast<int>() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['seller'] = this._seller;
    data['image'] = this._image;
    data['price'] = this._price;
    data['discounted_price'] = this._discountedPrice;
    data['quantity'] = this._quantity;
    data['max_quantity'] = this._maxQuantity;
    data['variant'] = this._variant;
    data['color'] = this._color;
    data['variation'] = this._variation;
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['tax'] = this._tax;
    data['tax_type'] = this._taxType;
    data['shipping_method_id'] = this.shippingMethodId;
    data['cart_group_id'] = this._cartGroupId;
    data['thumbnail'] = this._thumbnail;
    data['seller_id'] = this._sellerId;
    data['seller_is'] = this._sellerIs;
    data['shop_info'] = this._shopInfo;
    if (this._choiceOptions != null) {
      data['choice_options'] = this._choiceOptions.map((v) => v.toJson()).toList();
    }
    data['variation_indexes'] = this._variationIndexes;
    return data;
  }
}

//
// import 'package:mechatronia_app/data/model/response/product_model.dart';
// class CartModel {
//   int id;
//   int customerId;
//   String cartGroupId;
//   int productId;
//   String color;
//   String choices;
//   String variations;
//   String variant;
//   int quantity;
//   double price;
//   double tax;
//   double discount;
//   String discountType;
//   String slug;
//   String name;
//   String thumbnail;
//   int sellerId;
//   String sellerIs;
//   String createdAt;
//   String updatedAt;
//
//   CartModel(
//       {this.id,
//         this.customerId,
//         this.cartGroupId,
//         this.productId,
//         this.color,
//         this.choices,
//         this.variations,
//         this.variant,
//         this.quantity,
//         this.price,
//         this.tax,
//         this.discount,
//         this.discountType,
//         this.slug,
//         this.name,
//         this.thumbnail,
//         this.sellerId,
//         this.sellerIs,
//         this.createdAt,
//         this.updatedAt});
//
//   CartModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     customerId = json['customer_id'];
//     cartGroupId = json['cart_group_id'];
//     productId = json['product_id'];
//     color = json['color'];
//     choices = json['choices'];
//     variations = json['variations'].toString();
//     variant = json['variant'];
//     quantity = json['quantity'];
//     price = json['price'].toDouble();
//     tax = json['tax'].toDouble();
//     discount = json['discount'].toDouble();
//     discountType = json['discount_type'];
//     slug = json['slug'];
//     name = json['name'];
//     thumbnail = json['thumbnail'];
//     sellerId = json['seller_id'];
//     sellerIs = json['seller_is'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['customer_id'] = this.customerId;
//     data['cart_group_id'] = this.cartGroupId;
//     data['product_id'] = this.productId;
//     data['color'] = this.color;
//     data['choices'] = this.choices;
//     data['variations'] = this.variations;
//     data['variant'] = this.variant;
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     data['tax'] = this.tax;
//     data['discount'] = this.discount;
//     data['discount_type'] = this.discountType;
//     data['slug'] = this.slug;
//     data['name'] = this.name;
//     data['thumbnail'] = this.thumbnail;
//     data['seller_id'] = this.sellerId;
//     data['seller_is'] = this.sellerIs;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
