import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/product_model.dart';
import 'package:mechatronia_app/provider/product_provider.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/basewidget/product_shimmer.dart';
import 'package:mechatronia_app/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FeaturedServicetView extends StatelessWidget {
  final ScrollController scrollController;
  final bool isHome;

  FeaturedServicetView({this.scrollController, @required this.isHome});

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels &&
          Provider.of<ProductProvider>(context, listen: false).featuredServiceList.length != 0 &&
          !Provider.of<ProductProvider>(context, listen: false).isServiceFeaturedLoading) {
        int pageSize;

        pageSize = Provider.of<ProductProvider>(context, listen: false).featuredServicePageSize;

        if (offset < pageSize) {
          offset++;
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false).showBottomLoader();

          Provider.of<ProductProvider>(context, listen: false).getFeaturedProductList('1', context);
        }
      }
    });

    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        productList = prodProvider.featuredServiceList;

        return Column(children: [
          !prodProvider.firstServiceFeaturedLoading
              ? productList.length != 0
                  ? Container(
                      height: 250,
                      child: isHome
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productList.length,
                              itemBuilder: (ctx, index) {
                                return Container(
                                    width: (MediaQuery.of(context).size.width / 2) - 20,
                                    child: ProductWidget(productModel: productList[index]));
                              })
                          : StaggeredGridView.countBuilder(
                              itemCount: productList.length,
                              crossAxisCount: 2,
                              padding: EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                              itemBuilder: (BuildContext context, int index) {
                                return ProductWidget(productModel: productList[index]);
                              },
                            ),
                    )
                  : SizedBox.shrink()
              : ProductShimmer(isHomePage: true, isEnabled: prodProvider.firstServiceFeaturedLoading),
          prodProvider.isServiceFeaturedLoading
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                ))
              : SizedBox.shrink(),
        ]);
      },
    );
  }
}
