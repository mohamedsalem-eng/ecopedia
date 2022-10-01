import 'package:flutter/material.dart';
import 'package:mechatronia_app/provider/category_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/provider/top_seller_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TopSellerView extends StatelessWidget {
  final bool isHomePage;
  TopSellerView({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<TopSellerProvider>(
      builder: (context, topSellerProvider, child) {
        return topSellerProvider.topSellerList != null
            ? topSellerProvider.topSellerList.length != 0
                ? isHomePage
                    ? ConstrainedBox(
                        constraints: topSellerProvider.topSellerList.length > 0
                            ? BoxConstraints(maxHeight: 110)
                            : BoxConstraints(maxHeight: 0),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topSellerProvider.topSellerList.length,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => TopSellerProductScreen(
                                                topSeller: topSellerProvider.topSellerList[index],
                                                topSellerId: topSellerProvider.topSellerList[index].id,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width / 4.6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).highlightColor,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.15),
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ]),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                            child: FadeInImage.assetNetwork(
                                              placeholder: Images.placeholder,
                                              image: Provider.of<SplashProvider>(context, listen: false)
                                                      .baseUrls
                                                      .shopImageUrl +
                                                  '/' +
                                                  topSellerProvider.topSellerList[index].image,
                                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          topSellerProvider.topSellerList[index].name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: (1 / 1.3),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: topSellerProvider.topSellerList.length,
                        shrinkWrap: true,
                        physics: isHomePage ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          TopSellerProductScreen(topSeller: topSellerProvider.topSellerList[index])));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).highlightColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.withOpacity(0.15), blurRadius: 5, spreadRadius: 1)
                                        ]),
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder,
                                        image:
                                            Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl +
                                                '/' +
                                                topSellerProvider.topSellerList[index].image,
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: (MediaQuery.of(context).size.width / 4) * 0.3,
                                  child: Center(
                                      child: Text(
                                    topSellerProvider.topSellerList[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                  )),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                : SizedBox()
            : TopSellerShimmer();
      },
    );
  }
}

class TopSellerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1 / 1),
      ),
      itemCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200],
                spreadRadius: 2,
                blurRadius: 5)
          ]),
          margin: EdgeInsets.all(3),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              flex: 7,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: Provider.of<TopSellerProvider>(context).topSellerList.length == 0,
                child: Container(
                    decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                )),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorResources.getTextBg(context),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: Provider.of<CategoryProvider>(context).categoryList.length == 0,
                    child: Container(height: 10, color: Colors.white, margin: EdgeInsets.only(left: 15, right: 15)),
                  ),
                )),
          ]),
        );
      },
    );
  }
}
