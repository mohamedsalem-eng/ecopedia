import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/base/api_response.dart';
import 'package:mechatronia_app/data/model/response/product_model.dart';
import 'package:mechatronia_app/data/repository/product_repo.dart';
import 'package:mechatronia_app/helper/api_checker.dart';
import 'package:mechatronia_app/helper/product_type.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;
  ProductProvider({@required this.productRepo});

  // Latest products
  List<Product> _latestProductList = [];
  List<Product> _lProductList = [];
  List<Product> get lProductList => _lProductList;
  List<Product> _featuredProductList = [];
  List<Product> _featuredServiceList = [];
  List<Product> _serviceList = [];

  ProductType _productType = ProductType.NEW_ARRIVAL;
  String _title = 'xyz';

  bool _filterIsLoading = false;
  bool _filterFirstLoading = true;

  bool _isLoading = false;
  bool _isServiceFeaturedLoading = false;
  bool get isServiceFeaturedLoading => _isServiceFeaturedLoading;
  bool _isFeaturedLoading = false;
  bool get isFeaturedLoading => _isFeaturedLoading;
  bool _firstFeaturedLoading = true;
  bool _firstServiceFeaturedLoading = true;
  bool _isServiceLoading = false;
  bool get isServiceLoading => _isServiceLoading;
  bool _firstServiceLoading = true;
  bool _firstLoading = true;
  int _latestPageSize;
  int _lOffset = 1;
  int _sellerOffset = 1;
  int _lPageSize;
  int get lPageSize => _lPageSize;
  int _featuredPageSize;
  int _featuredServicePageSize;
  int _servicePageSize;

  ProductType get productType => _productType;
  String get title => _title;
  int get lOffset => _lOffset;
  int get sellerOffset => _sellerOffset;

  List<int> _offsetList = [];
  List<String> _lOffsetList = [];
  List<String> get lOffsetList => _lOffsetList;
  List<String> _featuredOffsetList = [];
  List<String> _featuredServiceOffsetList = [];
  List<String> _serviceOffsetList = [];

  List<Product> get latestProductList => _latestProductList;
  List<Product> get featuredProductList => _featuredProductList;
  List<Product> get featuredServiceList => _featuredServiceList;
  List<Product> get serviceList => _serviceList;

  bool get filterIsLoading => _filterIsLoading;
  bool get filterFirstLoading => _filterFirstLoading;
  bool get isLoading => _isLoading;
  bool get firstFeaturedLoading => _firstFeaturedLoading;
  bool get firstServiceFeaturedLoading => _firstServiceFeaturedLoading;
  bool get firstServiceLoading => _firstServiceLoading;
  bool get firstLoading => _firstLoading;
  int get latestPageSize => _latestPageSize;
  int get featuredPageSize => _featuredPageSize;
  int get featuredServicePageSize => _featuredServicePageSize;
  int get servicePageSize => _servicePageSize;

  Future<void> getServiceProduct(String offset, BuildContext context, {bool reload = false}) async {
    if (reload) {
      _serviceOffsetList = [];
      _serviceList = [];
    }
    if (!_serviceOffsetList.contains(offset)) {
      _serviceOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getServiceList(offset);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _serviceList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _servicePageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstServiceLoading = false;
        _isServiceLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    } else {
      if (_isServiceLoading) {
        _isServiceLoading = false;
        notifyListeners();
      }
    }
  }

  //latest product
  Future<void> getLatestProductList(int offset, BuildContext context, {bool reload = false}) async {
    if (reload) {
      _offsetList = [];
      _latestProductList = [];
    }
    _lOffset = offset;
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getLatestProductList(context, offset.toString(), productType, title);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _latestProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _latestPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _filterFirstLoading = false;
        _filterIsLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    } else {
      if (_filterIsLoading) {
        _filterIsLoading = false;
        notifyListeners();
      }
    }
  }

  //latest product
  Future<void> getLProductList(String offset, BuildContext context, {bool reload = false}) async {
    if (reload) {
      _lOffsetList = [];
      _lProductList = [];
    }
    if (!_lOffsetList.contains(offset)) {
      _lOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getLProductList(offset);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _lProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _lPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    } else {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<int> getLatestOffset(BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getLatestProductList(context, '1', productType, title);
    return ProductModel.fromJson(apiResponse.response.data).totalSize;
  }

  void changeTypeOfProduct(ProductType type, String title) {
    _productType = type;
    _title = title;
    _latestProductList = null;
    _latestPageSize = 0;
    _filterFirstLoading = true;
    _filterIsLoading = true;
    notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;
    _filterIsLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }

  // Seller products
  List<Product> _sellerAllProductList = [];
  List<Product> _sellerProductList = [];
  int _sellerPageSize;
  List<Product> get sellerProductList => _sellerProductList;
  int get sellerPageSize => _sellerPageSize;

  void initSellerProductList(String sellerId, int offset, BuildContext context, {bool reload = false}) async {
    _firstLoading = true;
    if (reload) {
      _offsetList = [];
      _sellerProductList = [];
    }
    _sellerOffset = offset;

    ApiResponse apiResponse = await productRepo.getSellerProductList(sellerId, offset.toString());
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _sellerProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
      _sellerAllProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
      _sellerPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
      _firstLoading = false;
      _filterIsLoading = false;
      _isLoading = false;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void filterData(String newText) {
    _sellerProductList.clear();
    if (newText.isNotEmpty) {
      _sellerAllProductList.forEach((product) {
        if (product.name.toLowerCase().contains(newText.toLowerCase())) {
          _sellerProductList.add(product);
        }
      });
    } else {
      _sellerProductList.clear();
      _sellerProductList.addAll(_sellerAllProductList);
    }
    notifyListeners();
  }

  void clearSellerData() {
    _sellerProductList = [];
    //notifyListeners();
  }

  // Brand and category products
  List<Product> _brandOrCategoryProductList = [];
  bool _hasData;

  List<Product> get brandOrCategoryProductList => _brandOrCategoryProductList;
  bool get hasData => _hasData;

  void initBrandOrCategoryProductList(bool isBrand, String id, BuildContext context) async {
    _brandOrCategoryProductList.clear();
    _hasData = true;
    ApiResponse apiResponse = await productRepo.getBrandOrCategoryProductList(isBrand, id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      apiResponse.response.data.forEach((product) => _brandOrCategoryProductList.add(Product.fromJson(product)));
      _hasData = _brandOrCategoryProductList.length > 1;
      List<Product> _products = [];
      _products.addAll(_brandOrCategoryProductList);
      _brandOrCategoryProductList.clear();
      _brandOrCategoryProductList.addAll(_products.reversed);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  // Related products
  List<Product> _relatedProductList;
  List<Product> get relatedProductList => _relatedProductList;

  void initRelatedProductList(String id, BuildContext context) async {
    ApiResponse apiResponse = await productRepo.getRelatedProductList(id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _relatedProductList = [];
      apiResponse.response.data.forEach((product) => _relatedProductList.add(Product.fromJson(product)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void removePrevRelatedProduct() {
    _relatedProductList = null;
  }

  //featured product
  Future<void> getFeaturedProductList(String offset, BuildContext context, {bool reload = false}) async {
    if (reload) {
      _featuredOffsetList = [];
      _featuredProductList = [];
    }
    if (!_featuredOffsetList.contains(offset)) {
      _featuredOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getFeaturedProductList(offset);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _featuredProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _featuredPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstFeaturedLoading = false;
        _isFeaturedLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    } else {
      if (_isFeaturedLoading) {
        _isFeaturedLoading = false;
        notifyListeners();
      }
    }
  }

  //featured Service
  Future<void> getFeaturedServiceList(String offset, BuildContext context, {bool reload = false}) async {
    if (reload) {
      _featuredServiceOffsetList = [];
      _featuredServiceList = [];
    }
    if (!_featuredServiceOffsetList.contains(offset)) {
      _featuredServiceOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getFeaturedServiceList(offset);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _featuredServiceList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _featuredServicePageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _firstServiceFeaturedLoading = false;
        _isServiceFeaturedLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    } else {
      if (_isServiceFeaturedLoading) {
        _isServiceFeaturedLoading = false;
        notifyListeners();
      }
    }
  }
}
