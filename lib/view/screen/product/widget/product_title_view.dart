import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/product_model.dart';
import 'package:mechatronia_app/helper/price_converter.dart';
import 'package:mechatronia_app/provider/product_details_provider.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/basewidget/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProductTitleView extends StatelessWidget {
  final Product productModel;
  ProductTitleView({@required this.productModel});

  @override
  Widget build(BuildContext context) {
    double _startingPrice = 0;
    double _endingPrice;
    if (productModel.variation != null && productModel.variation.length != 0) {
      List<double> _priceList = [];
      productModel.variation.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = productModel.unitPrice;
    }

    return productModel != null
        ? Container(
            color: Theme.of(context).highlightColor,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Consumer<ProductDetailsProvider>(
              builder: (context, details, child) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    if (productModel.productType != "service")
                      // Text(
                      //   '${_startingPrice != null ? PriceConverter.convertPrice(context, _startingPrice, discount: productModel.discount, discountType: productModel.discountType) : ''}'
                      //   '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: productModel.discount, discountType: productModel.discountType)}' : ''}',
                      //   style: titilliumBold.copyWith(
                      //       color: ColorResources.getPrimary(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                      // ),
                    SizedBox(width: 20),
                    if (productModel.productType != "service")
                      productModel.unitPrice != null && productModel.discount != 0
                          ? Container(
                              width: 50,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: ColorResources.getPrimary(context)),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                PriceConverter.percentageCalculation(
                                    context, productModel.unitPrice, productModel.discount, productModel.discountType),
                                style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: 8),
                              ),
                            )
                          : SizedBox.shrink(),
                    Expanded(child: SizedBox.shrink()),
                    InkWell(
                      onTap: () {
                        if (Provider.of<ProductDetailsProvider>(context, listen: false).sharableLink != null) {
                          Share.share(Provider.of<ProductDetailsProvider>(context, listen: false).sharableLink);
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200],
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.share,
                            color: ColorResources.getPrimary(context), size: Dimensions.ICON_SIZE_SMALL),
                      ),
                    ),
                  ]),
                  if (productModel.productType != "service")
                    productModel.discount != null && productModel.discount > 0
                        ? Text(
                            '${PriceConverter.convertPrice(context, _startingPrice)}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                            style: titilliumRegular.copyWith(
                                color: Theme.of(context).hintColor, decoration: TextDecoration.lineThrough),
                          )
                        : SizedBox(),
                  Text(productModel.name ?? '',
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE), maxLines: 2),
                  Row(children: [
                    Text(
                        productModel.rating != null
                            ? productModel.rating.length > 0
                                ? double.parse(productModel.rating[0].average).toStringAsFixed(1)
                                : '0.0'
                            : '0.0',
                        style: titilliumSemiBold.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                        )),
                    SizedBox(width: 5),
                    RatingBar(
                        rating: productModel.rating != null
                            ? productModel.rating.length > 0
                                ? double.parse(productModel.rating[0].average)
                                : 0.0
                            : 0.0),
                    Expanded(child: SizedBox.shrink()),
                    Text('${details.reviewList != null ? details.reviewList.length : 0} reviews | ',
                        style: titilliumRegular.copyWith(
                          color: Theme.of(context).hintColor,
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        )),

                  ]),
                ]);
              },
            ),
          )
        : SizedBox();
  }
}
