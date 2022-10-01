import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/area_model.dart';
import 'package:mechatronia_app/data/model/response/shipping_method_model.dart';
import 'package:mechatronia_app/helper/price_converter.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/cart_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ShippingMethodBottomSheet extends StatefulWidget {
  final String groupId;
  final int sellerId;
  final String city;
  final int sellerIndex;
  ShippingMethodBottomSheet(
      {@required this.groupId, @required this.sellerId, @required this.sellerIndex, @required this.city});

  @override
  _ShippingMethodBottomSheetState createState() => _ShippingMethodBottomSheetState();
}

class _ShippingMethodBottomSheetState extends State<ShippingMethodBottomSheet> {
  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('shipping_method_added_successfully', context)), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed'), backgroundColor: Colors.red));
    }
  }

  @override
  void initState() {
    //Provider.of<CartProvider>(context,listen: false).getShippingMethod(context, widget.cart.sellerId,widget.sellerIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Close Button
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).highlightColor, boxShadow: [
                BoxShadow(
                    color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200],
                    spreadRadius: 1,
                    blurRadius: 5)
              ]),
              child: Icon(Icons.clear, size: Dimensions.ICON_SIZE_SMALL),
            ),
          ),
        ),

        Consumer<CartProvider>(
          builder: (context, order, child) {
            return order.shippingList[widget.sellerIndex].shippingMethodList != null
                ? order.shippingList[widget.sellerIndex].shippingMethodList.length != 0
                    ? SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: order.shippingList[widget.sellerIndex].shippingMethodList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final hasArea = order.shippingList[widget.sellerIndex].shippingMethodList[index].hasArea;
                            double cost = order.shippingList[widget.sellerIndex].shippingMethodList[index].cost;
                            if (hasArea) {
                              final areaList = Provider.of<SplashProvider>(context, listen: false).configModel.areaList;

                              cost += areaList
                                  .firstWhere((element) => element.id.toString() == widget.city,
                                      orElse: () => AreaModel(cost: 0, id: 0, name: ""))
                                  .cost;
                            }
                            return RadioListTile(
                              title: Text(
                                  '${order.shippingList[widget.sellerIndex].shippingMethodList[index].title} (Duration: ${order.shippingList[widget.sellerIndex].shippingMethodList[index].duration}, Cost: ${PriceConverter.convertPrice(context, cost)})'),
                              value: index,
                              groupValue: order.shippingList[widget.sellerIndex].shippingIndex,
                              activeColor: Theme.of(context).primaryColor,
                              toggleable: false,
                              onChanged: (value) async {
                                Provider.of<CartProvider>(context, listen: false)
                                    .setSelectedShippingMethod(value, widget.sellerIndex);
                                ShippingMethodModel shipping = ShippingMethodModel();
                                shipping.id = order.shippingList[widget.sellerIndex].shippingMethodList[index].id;
                                shipping.duration = widget.groupId;
                                order.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      )
                                    : order.addShippingMethod(
                                        context, shipping.id, shipping.duration, widget.city, route);
                                // Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      )
                    : Center(child: Text('No method available'))
                : Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          },
        ),
      ]),
    );
  }
}
