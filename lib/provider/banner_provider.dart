import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/banner_model.dart';
import 'package:mechatronia_app/data/model/response/base/api_response.dart';
import 'package:mechatronia_app/data/model/response/product_model.dart';
import 'package:mechatronia_app/data/repository/banner_repo.dart';
import 'package:mechatronia_app/helper/api_checker.dart';
import 'package:mechatronia_app/view/basewidget/show_custom_snakbar.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;

  BannerProvider({@required this.bannerRepo});

  List<BannerModel> _mainBannerList;
  List<BannerModel> _footerBannerList;
  Product _product;
  int _currentIndex;

  List<BannerModel> get mainBannerList => _mainBannerList;
  List<BannerModel> get footerBannerList => _footerBannerList;
  Product get product => _product;
  int get currentIndex => _currentIndex;

  Future<void> getBannerList(bool reload, BuildContext context) async {
    if (_mainBannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo.getBannerList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _mainBannerList = [];
        apiResponse.response.data.forEach((bannerModel) => _mainBannerList.add(BannerModel.fromJson(bannerModel)));
        _currentIndex = 0;
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> getFooterBannerList(BuildContext context) async {
    ApiResponse apiResponse = await bannerRepo.getFooterBannerList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _footerBannerList = [];
      apiResponse.response.data.forEach((bannerModel) => _footerBannerList.add(BannerModel.fromJson(bannerModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  void getProductDetails(BuildContext context, String productId) async {
    ApiResponse apiResponse = await bannerRepo.getProductDetails(productId);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _product = (Product.fromJson(apiResponse.response.data));
    } else {
      showCustomSnackBar(apiResponse.error.toString(), context);
    }
  }
}
