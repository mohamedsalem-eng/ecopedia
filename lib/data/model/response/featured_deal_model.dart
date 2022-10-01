import 'package:mechatronia_app/data/model/response/product_model.dart';

class FeaturedDealModel {
  int id;
  int flashDealId;
  int productId;
  int discount;
  dynamic discountType;
  String createdAt;
  String updatedAt;
  Product product;

  FeaturedDealModel(
      {this.id,
      this.flashDealId,
      this.productId,
      this.discount,
      this.discountType,
      this.createdAt,
      this.updatedAt,
      this.product});

  FeaturedDealModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flashDealId = json['flash_deal_id'];
    productId = json['product_id'];
    discount = json['discount'];
    discountType = json['discount_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['flash_deal_id'] = this.flashDealId;
    data['product_id'] = this.productId;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}
