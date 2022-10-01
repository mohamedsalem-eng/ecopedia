import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/top_seller_model.dart';

import 'package:mechatronia_app/helper/product_type.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/product_provider.dart';
import 'package:mechatronia_app/provider/seller_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/basewidget/animated_custom_dialog.dart';
import 'package:mechatronia_app/view/basewidget/guest_dialog.dart';
import 'package:mechatronia_app/view/basewidget/search_widget.dart';
import 'package:mechatronia_app/view/screen/chat/top_seller_chat_screen.dart';
import 'package:mechatronia_app/view/screen/home/widget/products_view.dart';
import 'package:provider/provider.dart';

class TopSellerProductScreen extends StatelessWidget {
  final TopSellerModel topSeller;
  final int topSellerId;

  TopSellerProductScreen({@required this.topSeller, this.topSellerId});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).clearSellerData();
    Provider.of<ProductProvider>(context, listen: false).initSellerProductList(topSellerId.toString(), 1, context);
    Provider.of<SellerProvider>(context, listen: false).initSeller(topSeller.sellerId.toString(), context);
    ScrollController _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          SearchWidget(
            hintText: 'Search product...',
            onTextChanged: (String newText) => Provider.of<ProductProvider>(context, listen: false).filterData(newText),
            onClearPressed: () {},
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              children: [
                // Banner
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder,
                      height: 120,
                      fit: BoxFit.cover,
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/banner/${topSeller.banner != null ? topSeller.banner : ''}',
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, fit: BoxFit.cover),
                    ),
                  ),
                ),

                Container(
                  color: Theme.of(context).highlightColor,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(children: [
                    // Seller Info
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/${topSeller.image}',
                          imageErrorBuilder: (c, o, s) =>
                              Image.asset(Images.placeholder, height: 80, width: 80, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(
                        child: Consumer<SellerProvider>(builder: (context, sellerProvider, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topSeller.name,
                                style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              sellerProvider.sellerModel != null
                                  ? Row(
                                      children: [
                                        Container(width: 16, height: 16, child: Image.asset(Images.star)),
                                        Text(
                                          sellerProvider.sellerModel.avgRating.toString() ?? '',
                                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                        Text(
                                          sellerProvider.sellerModel.totalReview.toString() +
                                              ' ' +
                                              '${getTranslated('reviews', context)}',
                                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                            ],
                          );
                        }),
                      ),
                      IconButton(
                        onPressed: () {
                          if (!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                            showAnimatedDialog(context, GuestDialog(), isFlip: true);
                          } else if (topSeller != null) {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => TopSellerChatScreen(topSeller: topSeller)));
                          }
                        },
                        icon: Image.asset(Images.chat_image,
                            color: ColorResources.SELLER_TXT, height: Dimensions.ICON_SIZE_DEFAULT),
                      ),
                    ]),
                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: ProductView(
                      isHomePage: false,
                      productType: ProductType.SELLER_PRODUCT,
                      scrollController: _scrollController,
                      sellerId: topSeller.id.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
