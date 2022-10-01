import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/order_details.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:provider/provider.dart';

class OrderProductWidget extends StatelessWidget {
  final OrderDetailsModel orderDetailsModel;
  OrderProductWidget({@required this.orderDetailsModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(color: ColorResources.WHITE),
      child: Row(children: [
        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: FadeInImage.assetNetwork(
            placeholder: Images.placeholder,
            height: 50,
            width: 50,
            image:
                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${orderDetailsModel.productDetails}',
            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 50, width: 50),
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('abc',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: titilliumRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    color: ColorResources.HINT_TEXT_COLOR,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    //PriceConverter.convertPrice(context, cartModel.price),
                    '200',
                    style: titilliumSemiBold.copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Container(
                    width: 50,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: Text('${100}% OFF',
                        textAlign: TextAlign.center,
                        style: titilliumRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                          color: ColorResources.HINT_TEXT_COLOR,
                        )),
                  ),
                  Container(
                    width: 50,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(getTranslated('review', context),
                        textAlign: TextAlign.center,
                        style: titilliumRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                          color: ColorResources.WHITE,
                        )),
                  ),
                ],
              ),
            ],
          ),
        )),
      ]),
    );
  }
}
