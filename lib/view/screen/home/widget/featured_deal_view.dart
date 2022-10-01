import 'package:flutter/material.dart';
import 'package:mechatronia_app/helper/price_converter.dart';
import 'package:mechatronia_app/provider/featured_deal_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedDealsView extends StatelessWidget {
  final bool isHomePage;
  FeaturedDealsView({this.isHomePage = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturedDealProvider>(
      builder: (context, featuredDealProvider, child) {
        return Provider.of<FeaturedDealProvider>(context).featuredDealList.length != 0
            ? ListView.builder(
                padding: EdgeInsets.all(0),
                scrollDirection: isHomePage ? Axis.horizontal : Axis.vertical,
                itemCount: featuredDealProvider.featuredDealList.length == 0
                    ? 2
                    : featuredDealProvider.featuredDealList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 1000),
                            pageBuilder: (context, anim1, anim2) =>
                                ProductDetails(product: featuredDealProvider.featuredDealProductList[index]),
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: isHomePage ? 300 : null,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).highlightColor,
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
                      child: Stack(children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                color: ColorResources.getIconBg(context),
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              ),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder,
                                fit: BoxFit.cover,
                                image:
                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}'
                                    '/${featuredDealProvider.featuredDealProductList[index].thumbnail}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    featuredDealProvider.featuredDealProductList[index].name,
                                    style: robotoRegular,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    PriceConverter.convertPrice(context,
                                        featuredDealProvider.featuredDealProductList[index].unitPrice.toDouble(),
                                        discountType: featuredDealProvider.featuredDealProductList[index].discountType,
                                        discount:
                                            featuredDealProvider.featuredDealProductList[index].discount.toDouble()),
                                    style: robotoBold.copyWith(color: ColorResources.getPrimary(context)),
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Row(children: [
                                    Expanded(
                                      child: Text(
                                        featuredDealProvider.featuredDealProductList[index].discount > 0
                                            ? PriceConverter.convertPrice(
                                                context,
                                                featuredDealProvider.featuredDealProductList[index].unitPrice
                                                    .toDouble())
                                            : '',
                                        style: robotoBold.copyWith(
                                          color: ColorResources.HINT_TEXT_COLOR,
                                          decoration: TextDecoration.lineThrough,
                                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      featuredDealProvider.featuredDealProductList[index].rating != null
                                          ? double.parse(
                                                  featuredDealProvider.featuredDealProductList[index].rating[0].average)
                                              .toStringAsFixed(1)
                                          : '0.0',
                                      style: robotoRegular.copyWith(
                                          color: Provider.of<ThemeProvider>(context).darkTheme
                                              ? Colors.white
                                              : Colors.orange,
                                          fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                    Icon(Icons.star,
                                        color: Provider.of<ThemeProvider>(context).darkTheme
                                            ? Colors.white
                                            : Colors.orange,
                                        size: 15),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ]),

                        // Off
                        featuredDealProvider.featuredDealProductList[index].discount >= 1
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 60,
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: ColorResources.getPrimary(context),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                  ),
                                  child: Text(
                                    PriceConverter.percentageCalculation(
                                      context,
                                      featuredDealProvider.featuredDealProductList[index].unitPrice.toDouble(),
                                      featuredDealProvider.featuredDealProductList[index].discount.toDouble(),
                                      featuredDealProvider.featuredDealProductList[index].discountType,
                                    ),
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).highlightColor,
                                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ]),
                    ),
                  );
                },
              )
            : MegaDealShimmer(isHomeScreen: isHomePage);
      },
    );
  }
}

class MegaDealShimmer extends StatelessWidget {
  final bool isHomeScreen;
  MegaDealShimmer({@required this.isHomeScreen});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: isHomeScreen ? Axis.horizontal : Axis.vertical,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.WHITE,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: Provider.of<FeaturedDealProvider>(context).featuredDealList.length == 0,
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  decoration: BoxDecoration(
                    color: ColorResources.ICON_BG,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20, color: ColorResources.WHITE),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Row(children: [
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Container(height: 20, width: 50, color: ColorResources.WHITE),
                            ]),
                          ),
                          Container(height: 10, width: 50, color: ColorResources.WHITE),
                          Icon(Icons.star, color: Colors.orange, size: 15),
                        ]),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
