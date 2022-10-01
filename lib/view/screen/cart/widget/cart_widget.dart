import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/cart_model.dart';
import 'package:mechatronia_app/helper/price_converter.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/cart_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  final CartModel cartModel;
  final int index;
  final bool fromCheckout;
  const CartWidget({Key key, this.cartModel, @required this.index, @required this.fromCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor),
      child: Row(children: [
        /*

        !fromCheckout ? InkWell(
          onTap: () => Provider.of<CartProvider>(context, listen: false).toggleSelected(index),
          child: Container(
            width: 15,
            height: 15,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColorResources.getPrimary(context), width: 1),
            ),
            // child: Provider.of<CartProvider>(context).isSelectedList[index]
            //     ? Icon(Icons.done, color: ColorResources.getPrimary(context), size: Dimensions.ICON_SIZE_EXTRA_SMALL)
            //     : SizedBox.shrink(),
          ),
        ) : SizedBox.shrink(),*/

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: FadeInImage.assetNetwork(
            placeholder: Images.placeholder,
            height: 50,
            width: 50,
            image:
                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${cartModel.thumbnail}',
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
                Text(cartModel.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titilliumBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: ColorResources.getHint(context),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      PriceConverter.convertPrice(context, cartModel.price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                    ),
                    cartModel.discount > 0
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ColorResources.getPrimary(context)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                PriceConverter.percentageCalculation(
                                    context, cartModel.price, cartModel.discount, 'amount'),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: titilliumRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHint(context)),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                Provider.of<AuthProvider>(context, listen: false).isLoggedIn()
                    ? Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                            child: QuantityButton(
                                isIncrement: false,
                                index: index,
                                quantity: cartModel.quantity,
                                maxQty: 20,
                                cartModel: cartModel),
                          ),
                          Text(cartModel.quantity.toString(), style: titilliumSemiBold),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            child: QuantityButton(
                                index: index,
                                isIncrement: true,
                                quantity: cartModel.quantity,
                                maxQty: 20,
                                cartModel: cartModel),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                (cartModel.variant != null && cartModel.variant.isNotEmpty)
                    ? Padding(
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Row(children: [
                          Text('${getTranslated('variations', context)}: ',
                              style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                          Flexible(
                              child: Text(cartModel.variant,
                                  style: robotoRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).disabledColor,
                                  ))),
                        ]),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        !fromCheckout
            ? IconButton(
                onPressed: () {
                  if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                    Provider.of<CartProvider>(context, listen: false).removeFromCartAPI(context, cartModel.id);
                  } else {
                    Provider.of<CartProvider>(context, listen: false).removeFromCart(index);
                  }
                },
                icon: Icon(Icons.cancel, color: ColorResources.RED),
              )
            : SizedBox.shrink(),
      ]),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final CartModel cartModel;
  final bool isIncrement;
  final int quantity;
  final int index;
  final int maxQty;
  QuantityButton(
      {@required this.isIncrement,
      @required this.quantity,
      @required this.index,
      @required this.maxQty,
      @required this.cartModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isIncrement && quantity > 1) {
          // Provider.of<CartProvider>(context, listen: false).setQuantity(false, index);
          Provider.of<CartProvider>(context, listen: false)
              .updateCartProductQuantity(cartModel.id, cartModel.quantity - 1, context)
              .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value.message),
              backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            ));
          });
        } else if (isIncrement && quantity < maxQty) {
          // Provider.of<CartProvider>(context, listen: false).setQuantity(true, index);
          Provider.of<CartProvider>(context, listen: false)
              .updateCartProductQuantity(cartModel.id, cartModel.quantity + 1, context)
              .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value.message),
              backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            ));
          });
        }
      },
      child: Icon(
        isIncrement ? Icons.add_circle : Icons.remove_circle,
        color: isIncrement
            ? quantity >= maxQty
                ? ColorResources.getGrey(context)
                : ColorResources.getPrimary(context)
            : quantity > 1
                ? ColorResources.getPrimary(context)
                : ColorResources.getGrey(context),
        size: 20,
      ),
    );
  }
}
