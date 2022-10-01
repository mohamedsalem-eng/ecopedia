import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/order_details.dart';
import 'package:mechatronia_app/helper/price_converter.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/order_provider.dart';
import 'package:mechatronia_app/provider/product_details_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/screen/order/widget/refunded_status_bottom_sheet.dart';
import 'package:mechatronia_app/view/screen/product/review_dialog.dart';
import 'package:mechatronia_app/view/screen/product/widget/refund_request_bottom_sheet.dart';
import 'package:provider/provider.dart';

class OrderDetailsWidget extends StatefulWidget {
  final OrderDetailsModel orderDetailsModel;
  final String orderType;
  final Function callback;
  OrderDetailsWidget({this.orderDetailsModel, this.callback, this.orderType});

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FadeInImage.assetNetwork(
                  placeholder: Images.placeholder,
                  fit: BoxFit.scaleDown,
                  width: 50,
                  height: 50,
                  image:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${widget.orderDetailsModel.productDetails.thumbnail}',
                  imageErrorBuilder: (c, o, s) =>
                      Image.asset(Images.placeholder, fit: BoxFit.scaleDown, width: 50, height: 50),
                ),
                SizedBox(width: Dimensions.MARGIN_SIZE_DEFAULT),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.orderDetailsModel.productDetails.name,
                              style: titilliumSemiBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).hintColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Provider.of<OrderProvider>(context).orderTypeIndex == 1 && widget.orderType != "POS"
                              ? InkWell(
                                  onTap: () {
                                    if (Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == 1) {
                                      Provider.of<ProductDetailsProvider>(context, listen: false).removeData();
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => ReviewBottomSheet(
                                              productID: widget.orderDetailsModel.productDetails.id.toString(),
                                              callback: widget.callback));
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                                      border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                    ),
                                    child: Text(getTranslated('review', context),
                                        style: titilliumRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                          color: ColorResources.getTextTitle(context),
                                        )),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Consumer<OrderProvider>(builder: (context, refund, _) {
                            return refund.orderTypeIndex == 1 &&
                                    widget.orderDetailsModel.refundReq == 0 &&
                                    widget.orderType != "POS"
                                ? InkWell(
                                    onTap: () {
                                      Provider.of<ProductDetailsProvider>(context, listen: false).removeData();
                                      refund.getRefundReqInfo(context, widget.orderDetailsModel.id).then((value) {
                                        if (value.response.statusCode == 200) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => RefundBottomSheet(
                                                      product: widget.orderDetailsModel.productDetails,
                                                      orderDetailsId: widget.orderDetailsModel.id)));
                                        }
                                      });
                                    },
                                    child: refund.isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
                                        : Container(
                                            margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                            padding: EdgeInsets.symmetric(
                                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                                            decoration: BoxDecoration(
                                              color: ColorResources.getPrimary(context),
                                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                                            ),
                                            child: Text(getTranslated('refund_request', context),
                                                style: titilliumRegular.copyWith(
                                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                  color: Theme.of(context).highlightColor,
                                                )),
                                          ),
                                  )
                                : SizedBox();
                          }),
                          Consumer<OrderProvider>(builder: (context, refund, _) {
                            return Provider.of<OrderProvider>(context).orderTypeIndex == 1 &&
                                    widget.orderDetailsModel.refundReq != 0 &&
                                    widget.orderType != "POS"
                                ? InkWell(
                                    onTap: () {
                                      Provider.of<ProductDetailsProvider>(context, listen: false).removeData();
                                      refund.getRefundReqInfo(context, widget.orderDetailsModel.id).then((value) {
                                        if (value.response.statusCode == 200) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => RefundResultBottomSheet(
                                                      product: widget.orderDetailsModel.productDetails,
                                                      orderDetailsId: widget.orderDetailsModel.id,
                                                      orderDetailsModel: widget.orderDetailsModel)));
                                        }
                                      });
                                    },
                                    child: refund.isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
                                        : Container(
                                            margin: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                            padding: EdgeInsets.symmetric(
                                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                                            decoration: BoxDecoration(
                                              color: ColorResources.getPrimary(context),
                                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                                            ),
                                            child: Text(getTranslated('refund_status_btn', context),
                                                style: titilliumRegular.copyWith(
                                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                  color: Theme.of(context).highlightColor,
                                                )),
                                          ),
                                  )
                                : SizedBox();
                          }),
                        ],
                      ),
                      SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            PriceConverter.convertPrice(context, widget.orderDetailsModel.price),
                            style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                          ),
                          Text('x${widget.orderDetailsModel.qty}',
                              style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context))),
                          widget.orderDetailsModel.discount > 0
                              ? Container(
                                  height: 20,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: ColorResources.getPrimary(context))),
                                  child: Text(
                                    PriceConverter.percentageCalculation(
                                        context,
                                        (widget.orderDetailsModel.price * widget.orderDetailsModel.qty),
                                        widget.orderDetailsModel.discount,
                                        'amount'),
                                    style: titilliumRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        color: ColorResources.getPrimary(context)),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (widget.orderDetailsModel.variant != null && widget.orderDetailsModel.variant.isNotEmpty)
                ? Padding(
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Row(children: [
                      SizedBox(width: 65),
                      Text('${getTranslated('variations', context)}: ',
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                      Flexible(
                          child: Text(widget.orderDetailsModel.variant,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Theme.of(context).disabledColor,
                              ))),
                    ]),
                  )
                : SizedBox(),
            Divider(),
          ],
        ),
      ),
    );
  }
}
