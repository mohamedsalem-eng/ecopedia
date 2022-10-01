import 'package:flutter/material.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/view/screen/product/widget/seller_view.dart';
import 'package:mechatronia_app/data/model/response/product_model.dart';

import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/product_details_provider.dart';
import 'package:mechatronia_app/provider/product_provider.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/provider/wishlist_provider.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/basewidget/no_internet_screen.dart';
import 'package:mechatronia_app/view/basewidget/title_row.dart';
import 'package:mechatronia_app/view/screen/product/widget/bottom_cart_view.dart';
import 'package:mechatronia_app/view/screen/product/widget/product_image_view.dart';
import 'package:mechatronia_app/view/screen/product/widget/product_specification_view.dart';
import 'package:mechatronia_app/view/screen/product/widget/product_title_view.dart';
import 'package:mechatronia_app/view/screen/product/widget/related_product_view.dart';
import 'package:mechatronia_app/view/screen/product/widget/review_widget.dart';
import 'package:provider/provider.dart';

import 'faq_and_review_screen.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  ProductDetails({
    @required this.product,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  _loadData(BuildContext context) async {
    Provider.of<ProductDetailsProvider>(context, listen: false).removePrevReview();
    Provider.of<ProductDetailsProvider>(context, listen: false).initProduct(widget.product, context);
    Provider.of<ProductProvider>(context, listen: false).removePrevRelatedProduct();
    Provider.of<ProductProvider>(context, listen: false).initRelatedProductList(widget.product.id.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false).getCount(widget.product.id.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.product.slug.toString(), context);
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListProvider>(context, listen: false).checkWishList(widget.product.id.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);
    return Consumer<ProductDetailsProvider>(
      builder: (context, details, child) {
        return details.hasConnection
            ? Scaffold(
                appBar: AppBar(
                  title: Row(children: [
                    InkWell(
                      child: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1.color, size: 20),
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Text(
                        widget.product.productType == "service"
                            ? getTranslated('service_details', context)
                            : "Course Details",
                        style:
                            robotoRegular.copyWith(fontSize: 20, color: Theme.of(context).textTheme.bodyText1.color)),
                  ]),
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor:
                      Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : Colors.white.withOpacity(0.5),
                ),
                bottomNavigationBar: BottomCartView(product: widget.product),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          ProductImageView(productModel: widget.product),
                          ProductTitleView(productModel: widget.product),
                        ],
                      ),

                      // Seller
                      widget.product.addedBy == 'seller'
                          ? SellerView(sellerId: widget.product.userId.toString())
                          : SizedBox.shrink(),

                      // Specification

                      (widget.product.details != null && widget.product.details.isNotEmpty)
                          ? Container(
                              margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              color: Theme.of(context).highlightColor,
                              child: ProductSpecification(
                                productSpecification: widget.product.details ?? '',
                                isService: widget.product.productType == "service",
                              ),
                            )
                          : SizedBox(),

                      // Reviews
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        color: Theme.of(context).highlightColor,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          TitleRow(
                              title: getTranslated('reviews', context) +
                                  '(${details.reviewList != null ? details.reviewList.length : 0})',
                              isDetailsPage: true,
                              onTap: () {
                                if (details.reviewList != null) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => ReviewScreen(reviewList: details.reviewList)));
                                }
                              }),
                          Divider(),
                          details.reviewList != null
                              ? details.reviewList.length != 0
                                  ? ReviewWidget(reviewModel: details.reviewList[0])
                                  : Center(child: Text(getTranslated('no_review', context)))
                              : ReviewShimmer(),
                        ]),
                      ),

                      // Related Products
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        color: Theme.of(context).highlightColor,
                        child: Column(
                          children: [
                            TitleRow(title: getTranslated('related_products', context), isDetailsPage: true),
                            SizedBox(height: 5),
                            RelatedProductView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                body: NoInternetOrDataScreen(isNoInternet: true, child: ProductDetails(product: widget.product)));
      },
    );
  }
}
