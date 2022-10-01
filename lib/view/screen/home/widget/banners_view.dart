import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/product_model.dart';
import 'package:mechatronia_app/provider/banner_provider.dart';
import 'package:mechatronia_app/provider/brand_provider.dart';
import 'package:mechatronia_app/provider/category_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/provider/top_seller_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/screen/product/brand_and_category_product_screen.dart';
import 'package:mechatronia_app/view/screen/product/product_details_screen.dart';
import 'package:mechatronia_app/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BannersView extends StatelessWidget {
  _clickBannerRedirect(BuildContext context, int id, Product product, String type) {
    final cIndex =
        Provider.of<CategoryProvider>(context, listen: false).categoryList.indexWhere((element) => element.id == id);
    final bIndex =
        Provider.of<BrandProvider>(context, listen: false).brandList.indexWhere((element) => element.id == id);
    final tIndex =
        Provider.of<TopSellerProvider>(context, listen: false).topSellerList.indexWhere((element) => element.id == id);

    if (type == 'category') {
      if (Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: false,
                      id: id.toString(),
                      name: '${Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name}',
                    )));
      }
    } else if (type == 'product') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProductDetails(
                    product: product,
                  )));
    } else if (type == 'brand') {
      if (Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: true,
                      id: id.toString(),
                      name: '${Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name}',
                    )));
      }
    } else if (type == 'shop') {
      if (Provider.of<TopSellerProvider>(context, listen: false).topSellerList[tIndex].name != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TopSellerProductScreen(
                      topSellerId: id,
                      topSeller: Provider.of<TopSellerProvider>(context, listen: false).topSellerList[tIndex],
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<BannerProvider>(
          builder: (context, bannerProvider, child) {
            double _width = MediaQuery.of(context).size.width;
            return Container(
              width: _width,
              height: _width * 0.3,
              child: bannerProvider.mainBannerList != null
                  ? bannerProvider.mainBannerList.length != 0
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                viewportFraction: .95,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                disableCenter: true,
                                onPageChanged: (index, reason) {
                                  Provider.of<BannerProvider>(context, listen: false).setCurrentIndex(index);
                                },
                              ),
                              itemCount:
                                  bannerProvider.mainBannerList.length == 0 ? 1 : bannerProvider.mainBannerList.length,
                              itemBuilder: (context, index, _) {
                                return InkWell(
                                  onTap: () {
                                    Provider.of<BannerProvider>(context, listen: false).getProductDetails(
                                        context, bannerProvider.mainBannerList[index].resourceId.toString());
                                    _clickBannerRedirect(
                                        context,
                                        bannerProvider.mainBannerList[index].resourceType == 'product'
                                            ? bannerProvider.mainBannerList[index].product.id
                                            : bannerProvider.mainBannerList[index].resourceId,
                                        bannerProvider.mainBannerList[index].resourceType == 'product'
                                            ? bannerProvider.mainBannerList[index].product
                                            : null,
                                        bannerProvider.mainBannerList[index].resourceType);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder,
                                        fit: BoxFit.cover,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}'
                                            '/${bannerProvider.mainBannerList[index].photo}',
                                        imageErrorBuilder: (c, o, s) =>
                                            Image.asset(Images.placeholder, fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 5,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: bannerProvider.mainBannerList.map((banner) {
                                  int index = bannerProvider.mainBannerList.indexOf(banner);
                                  return TabPageSelectorIndicator(
                                    backgroundColor: index == bannerProvider.currentIndex
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                    borderColor: index == bannerProvider.currentIndex
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                    size: 10,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        )
                      : Center(child: Text('No banner available'))
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: bannerProvider.mainBannerList == null,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.WHITE,
                          )),
                    ),
            );
          },
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Consumer<BannerProvider>(
            builder: (context, footerBannerProvider, child) {
              return footerBannerProvider.footerBannerList != null && footerBannerProvider.footerBannerList.length != 0
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: (2 / 1),
                      ),
                      itemCount: footerBannerProvider.footerBannerList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Provider.of<BannerProvider>(context, listen: false).getProductDetails(
                                context, footerBannerProvider.mainBannerList[index].resourceId.toString());
                            _clickBannerRedirect(
                                context,
                                footerBannerProvider.mainBannerList[index].resourceType == 'product'
                                    ? footerBannerProvider.mainBannerList[index].product.id
                                    : footerBannerProvider.mainBannerList[index].resourceId,
                                footerBannerProvider.mainBannerList[index].resourceType == 'product'
                                    ? footerBannerProvider.mainBannerList[index].product
                                    : null,
                                footerBannerProvider.mainBannerList[index].resourceType);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  fit: BoxFit.cover,
                                  image:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}'
                                      '/${footerBannerProvider.footerBannerList[index].photo}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: footerBannerProvider.footerBannerList == null,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.WHITE,
                          )),
                    );
            },
          ),
        )
      ],
    );
  }
}
