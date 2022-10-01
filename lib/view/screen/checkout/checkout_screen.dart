import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/body/order_place_model.dart';
import 'package:mechatronia_app/data/model/response/cart_model.dart';
import 'package:mechatronia_app/helper/price_converter.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/cart_provider.dart';
import 'package:mechatronia_app/provider/coupon_provider.dart';
import 'package:mechatronia_app/provider/order_provider.dart';
import 'package:mechatronia_app/provider/product_provider.dart';
import 'package:mechatronia_app/provider/profile_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/basewidget/amount_widget.dart';
import 'package:mechatronia_app/view/basewidget/animated_custom_dialog.dart';
import 'package:mechatronia_app/view/basewidget/custom_app_bar.dart';
import 'package:mechatronia_app/view/basewidget/my_dialog.dart';
import 'package:mechatronia_app/view/basewidget/show_custom_snakbar.dart';
import 'package:mechatronia_app/view/basewidget/textfield/custom_textfield.dart';
import 'package:mechatronia_app/view/basewidget/title_row.dart';
import 'package:mechatronia_app/view/screen/address/add_new_address_screen.dart';
import 'package:mechatronia_app/view/screen/address/saved_address_list_screen.dart';
import 'package:mechatronia_app/view/screen/checkout/widget/custom_check_box.dart';
import 'package:mechatronia_app/view/screen/checkout/widget/shipping_method_bottom_sheet.dart';
import 'package:mechatronia_app/view/screen/dashboard/dashboard_screen.dart';
import 'package:mechatronia_app/view/screen/payment/payment_screen.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  final double totalOrderAmount;
  final double shippingFee;
  final double discount;
  final double tax;
  final int sellerId;
  CheckoutScreen(
      {@required this.cartList,
      this.fromProductDetails = false,
      @required this.discount,
      @required this.tax,
      @required this.totalOrderAmount,
      @required this.shippingFee,
      this.sellerId});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _orderNoteController = TextEditingController();
  final FocusNode _orderNoteNode = FocusNode();
  double _order = 0;
  bool _digitalPayment;
  bool _cod;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<CouponProvider>(context, listen: false).removePrevCouponData();
    Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    Provider.of<CartProvider>(context, listen: false).getChosenShippingMethod(context);
    _digitalPayment = Provider.of<SplashProvider>(context, listen: false).configModel.digitalPayment;
    _cod = Provider.of<SplashProvider>(context, listen: false).configModel.cod;

    Provider.of<OrderProvider>(context, listen: false).shippingAddressNull();
    Provider.of<OrderProvider>(context, listen: false).billingAddressNull();
  }

  @override
  Widget build(BuildContext context) {
    _order = widget.totalOrderAmount + widget.discount;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      bottomNavigationBar: Container(
        height: 60,
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
            color: ColorResources.getPrimary(context),
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: Consumer<OrderProvider>(
          builder: (context, order, child) {
            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Consumer<CouponProvider>(builder: (context, coupon, child) {
                double _couponDiscount = coupon.discount != null ? coupon.discount : 0;
                return Text(
                  PriceConverter.convertPrice(
                      context, (widget.totalOrderAmount + cartProvider.shippingCost + widget.tax - _couponDiscount)),
                  style: titilliumSemiBold.copyWith(color: Theme.of(context).highlightColor),
                );
              }),
              !Provider.of<OrderProvider>(context).isLoading
                  ? Builder(
                      builder: (context) => TextButton(
                        onPressed: () async {
                          if (Provider.of<OrderProvider>(context, listen: false).addressIndex == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(getTranslated('select_a_shipping_address', context)),
                                backgroundColor: Colors.red));
                          } else {
                            List<CartModel> _cartList = [];
                            _cartList.addAll(widget.cartList);

                            for (int index = 0; index < widget.cartList.length; index++) {
                              for (int i = 0;
                                  i < Provider.of<CartProvider>(context, listen: false).chosenShippingList.length;
                                  i++) {
                                if (Provider.of<CartProvider>(context, listen: false)
                                        .chosenShippingList[i]
                                        .cartGroupId ==
                                    widget.cartList[index].cartGroupId) {
                                  _cartList[index].shippingMethodId =
                                      Provider.of<CartProvider>(context, listen: false).chosenShippingList[i].id;
                                  break;
                                }
                              }
                            }

                            String orderNote = _orderNoteController.text.trim();
                            double couponDiscount = Provider.of<CouponProvider>(context, listen: false).discount != null
                                ? Provider.of<CouponProvider>(context, listen: false).discount
                                : 0;
                            String couponCode = Provider.of<CouponProvider>(context, listen: false).discount != null
                                ? Provider.of<CouponProvider>(context, listen: false).coupon.code
                                : '';
                            if (_cod && Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
                              Provider.of<OrderProvider>(context, listen: false).placeOrder(
                                  OrderPlaceModel(
                                    CustomerInfo(
                                        Provider.of<ProfileProvider>(context, listen: false)
                                            .addressList[
                                                Provider.of<OrderProvider>(context, listen: false).addressIndex]
                                            .id
                                            .toString(),
                                        Provider.of<ProfileProvider>(context, listen: false)
                                            .addressList[
                                                Provider.of<OrderProvider>(context, listen: false).addressIndex]
                                            .address,
                                        Provider.of<ProfileProvider>(context, listen: false)
                                            .billingAddressList[
                                                Provider.of<OrderProvider>(context, listen: false).billingAddressIndex]
                                            .id
                                            .toString(),
                                        Provider.of<ProfileProvider>(context, listen: false)
                                            .billingAddressList[
                                                Provider.of<OrderProvider>(context, listen: false).billingAddressIndex]
                                            .address,
                                        orderNote),
                                    _cartList,
                                    order.paymentMethodIndex == 0 ? 'cash_on_delivery' : '',
                                    couponDiscount,
                                  ),
                                  _callback,
                                  _cartList,
                                  Provider.of<ProfileProvider>(context, listen: false)
                                      .addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex]
                                      .id
                                      .toString(),
                                  couponCode,
                                  Provider.of<ProfileProvider>(context, listen: false)
                                      .billingAddressList[
                                          Provider.of<OrderProvider>(context, listen: false).billingAddressIndex]
                                      .id
                                      .toString(),
                                  orderNote);
                            } else {
                              String userID =
                                  await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PaymentScreen(
                                            customerID: userID,
                                            addressID: Provider.of<ProfileProvider>(context, listen: false)
                                                .addressList[
                                                    Provider.of<OrderProvider>(context, listen: false).addressIndex]
                                                .id
                                                .toString(),
                                            couponCode:
                                                Provider.of<CouponProvider>(context, listen: false).discount != null
                                                    ? Provider.of<CouponProvider>(context, listen: false).coupon.code
                                                    : '',
                                            billingId: Provider.of<ProfileProvider>(context, listen: false)
                                                .billingAddressList[Provider.of<OrderProvider>(context, listen: false)
                                                    .billingAddressIndex]
                                                .id
                                                .toString(),
                                            orderNote: orderNote,
                                          )));
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).highlightColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(getTranslated('proceed', context),
                            style: titilliumSemiBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                              color: ColorResources.getPrimary(context),
                            )),
                      ),
                    )
                  : Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).highlightColor)),
                    ),
            ]);
          },
        ),
      ),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('checkout', context)),
          Expanded(
            child: ListView(physics: BouncingScrollPhysics(), padding: EdgeInsets.all(0), children: [
              // Shipping Details
              Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(color: Theme.of(context).highlightColor),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${getTranslated('SHIPPING_TO', context)} : ',
                          style: titilliumRegular.copyWith(fontWeight: FontWeight.w600)),
                      Expanded(
                        child: Text(
                          Provider.of<OrderProvider>(context, listen: true).addressIndex == null
                              ? getTranslated('add_your_address', context)
                              : Provider.of<ProfileProvider>(context, listen: false)
                                  .addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex]
                                  .address,
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => AddNewAddressScreen(isBilling: false))),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: ColorResources.getPrimary(context)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.7),
                              child: Icon(Icons.add, size: 15, color: Theme.of(context).cardColor),
                            )),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (BuildContext context) => SavedAddressListScreen())),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: ColorResources.getPrimary(context)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.7),
                              child: Icon(Icons.edit, size: 15, color: Theme.of(context).cardColor),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  /*  Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text('${getTranslated('billing_address', context)} : ',  style: titilliumRegular.copyWith(fontWeight: FontWeight.w600)),
                      Expanded(child: Text(
                        Provider.of<OrderProvider>(context).billingAddressIndex == null ? getTranslated('add_your_address', context)
                            : Provider.of<ProfileProvider>(context, listen: false).billingAddressList[Provider.of<OrderProvider>(context, listen: false).billingAddressIndex].address,
                        style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                        maxLines: 3, overflow: TextOverflow.fade,
                      ),),
                      InkWell(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddNewAddressScreen(isBilling: true))),
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: ColorResources.getPrimary(context)),
                            child: Icon(Icons.add, size: 15, color: Theme.of(context).cardColor)),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                      InkWell(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SavedBillingAddressListScreen())),
                        child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: ColorResources.getPrimary(context)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.7),
                              child: Icon(Icons.edit, size: 9, color: Theme.of(context).cardColor),
                            )),
                      ),
                    ],
                  ), */
                ]),
              ),

              // Order Details
              Container(
                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TitleRow(title: getTranslated('ORDER_DETAILS', context)),
                  ConstrainedBox(
                    constraints: Provider.of<CartProvider>(context, listen: false).cartList.length > 0
                        ? BoxConstraints(
                            maxHeight:
                                90 * Provider.of<CartProvider>(context, listen: false).cartList.length.toDouble())
                        : BoxConstraints(maxHeight: 0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Provider.of<CartProvider>(context, listen: false).cartList.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: Row(children: [
                              FadeInImage.assetNetwork(
                                placeholder: Images.placeholder,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                image:
                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${Provider.of<CartProvider>(context, listen: false).cartList[index].thumbnail}',
                                imageErrorBuilder: (c, o, s) =>
                                    Image.asset(Images.placeholder, fit: BoxFit.cover, width: 50, height: 50),
                              ),
                              SizedBox(width: Dimensions.MARGIN_SIZE_DEFAULT),
                              Expanded(
                                flex: 3,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    Provider.of<CartProvider>(context, listen: false).cartList[index].name,
                                    style: titilliumRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                        color: ColorResources.getPrimary(context)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                  Row(children: [
                                    Text(
                                      PriceConverter.convertPrice(context,
                                          Provider.of<CartProvider>(context, listen: false).cartList[index].price),
                                      style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                    Text(
                                        Provider.of<CartProvider>(context, listen: false)
                                            .cartList[index]
                                            .quantity
                                            .toString(),
                                        style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context))),
                                    Provider.of<CartProvider>(context, listen: false).cartList[index].discount > 0
                                        ? Container(
                                            padding:
                                                EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: ColorResources.getPrimary(context))),
                                            child: Text(
                                              PriceConverter.percentageCalculation(
                                                  context,
                                                  Provider.of<CartProvider>(context, listen: false)
                                                      .cartList[index]
                                                      .price,
                                                  Provider.of<CartProvider>(context, listen: false)
                                                      .cartList[index]
                                                      .discount,
                                                  Provider.of<CartProvider>(context, listen: false)
                                                      .cartList[index]
                                                      .discountType),
                                              style: titilliumRegular.copyWith(
                                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                  color: ColorResources.getPrimary(context)),
                                            ),
                                          )
                                        : SizedBox(),
                                  ]),
                                ]),
                              ),
                            ]),
                          );
                        }),
                  ),

                  // Coupon
                  Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Have a coupon?',
                              hintStyle: titilliumRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR),
                              filled: true,
                              fillColor: ColorResources.getIconBg(context),
                              border: InputBorder.none,
                            )),
                      ),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    !Provider.of<CouponProvider>(context).isLoading
                        ? ElevatedButton(
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                Provider.of<CouponProvider>(context, listen: false)
                                    .initCoupon(_controller.text, _order)
                                    .then((value) {
                                  if (value > 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content:
                                            Text('You got ${PriceConverter.convertPrice(context, value)} discount'),
                                        backgroundColor: Colors.green));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(getTranslated('invalid_coupon_or', context)),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: ColorResources.getGreen(context),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(getTranslated('APPLY', context)),
                          )
                        : CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                  ]),
                ]),
              ),

              // Total bill
              Container(
                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Consumer<OrderProvider>(
                  builder: (context, order, child) {
                    //_shippingCost = order.shippingIndex != null ? order.shippingList[order.shippingIndex].cost : 0;
                    double _couponDiscount = Provider.of<CouponProvider>(context).discount != null
                        ? Provider.of<CouponProvider>(context).discount
                        : 0;

                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      TitleRow(title: getTranslated('TOTAL', context)),
                      AmountWidget(
                          title: getTranslated('ORDER', context), amount: PriceConverter.convertPrice(context, _order)),
                      AmountWidget(
                          title: getTranslated('SHIPPING_FEE', context),
                          amount: PriceConverter.convertPrice(context, cartProvider.shippingCost)),
                      AmountWidget(
                          title: getTranslated('DISCOUNT', context),
                          amount: PriceConverter.convertPrice(context, widget.discount)),
                      AmountWidget(
                          title: getTranslated('coupon_voucher', context),
                          amount: PriceConverter.convertPrice(context, _couponDiscount)),
                      AmountWidget(
                          title: getTranslated('TAX', context),
                          amount: PriceConverter.convertPrice(context, widget.tax)),
                      Divider(height: 5, color: Theme.of(context).hintColor),
                      AmountWidget(
                          title: getTranslated('TOTAL_PAYABLE', context),
                          amount: PriceConverter.convertPrice(context,
                              (_order + cartProvider.shippingCost - widget.discount - _couponDiscount + widget.tax))),
                    ]);
                  },
                ),
              ),

              Provider.of<SplashProvider>(context, listen: false).configModel.shippingMethod != 'sellerwise_shipping'
                  ? InkWell(
                      onTap: () {
                        if (Provider.of<OrderProvider>(context, listen: false).addressIndex == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(getTranslated('select_a_shipping_address', context)),
                              backgroundColor: Colors.red));
                        } else {
                          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                            final address = Provider.of<ProfileProvider>(context, listen: false)
                                .addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex]
                                .city;

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ShippingMethodBottomSheet(
                                  groupId: 'all_cart_group', sellerIndex: 0, sellerId: 1, city: address),
                            );
                          } else {
                            showCustomSnackBar('not_logged_in', context);
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('SHIPPING_PARTNER', context), style: titilliumRegular),
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                              Text(
                                (cartProvider.shippingList == null ||
                                        cartProvider.shippingList[0].shippingMethodList == null ||
                                        cartProvider.chosenShippingList.length == 0 ||
                                        cartProvider.shippingList[0].shippingIndex == -1)
                                    ? ''
                                    : '${cartProvider.shippingList[0].shippingMethodList[cartProvider.shippingList[0].shippingIndex].title.toString()}',
                                style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                            ]),
                          ]),
                        ),
                      ),
                    )
                  : SizedBox(),

              // Payment Method
              Container(
                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Column(children: [
                  TitleRow(title: getTranslated('payment_method', context)),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  _cod ? CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0) : SizedBox(),
                  _digitalPayment
                      ? CustomCheckBox(title: getTranslated('digital_payment', context), index: !_cod ? 0 : 1)
                      : SizedBox(),
                ]),
              ),

              Container(
                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    getTranslated('order_note', context),
                    style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  CustomTextField(
                    hintText: getTranslated('enter_note', context),
                    textInputType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    focusNode: _orderNoteNode,
                    controller: _orderNoteController,
                  ),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID, List<CartModel> carts) async {
    if (isSuccess) {
      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
        1,
        context,
        reload: true,
      );
      if (Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
        showAnimatedDialog(
            context,
            MyDialog(
              icon: Icons.check,
              title: getTranslated('order_placed', context),
              description: getTranslated('your_order_placed', context),
              isFailed: false,
            ),
            dismissible: false,
            isFlip: true);
      } else {}
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: ColorResources.RED));
    }
  }
}

class PaymentButton extends StatelessWidget {
  final String image;
  final Function onTap;
  PaymentButton({@required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: ColorResources.getGrey(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(image),
      ),
    );
  }
}
