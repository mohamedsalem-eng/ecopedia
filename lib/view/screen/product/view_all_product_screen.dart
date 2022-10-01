import 'package:flutter/material.dart';
import 'package:mechatronia_app/helper/product_type.dart';

import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/screen/home/widget/products_view.dart';
import 'package:provider/provider.dart';

class AllProductScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final ProductType productType;
  final String title;
  AllProductScreen({@required this.productType, this.title});

  // Future<void> _loadData(BuildContext context, bool reload) async {
  //   String _languageCode = Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode;
  //   await Provider.of<BrandProvider>(context, listen: false).getBrandList(reload, context);
  //   await Provider.of<ProductProvider>(context, listen: false).getLatestProductList('1', context, _languageCode, reload: reload);
  //
  //
  //
  // }

  @override
  Widget build(BuildContext context) {
    // _loadData(context, false);

    final _header = title == null
        ? productType == ProductType.FEATURED_PRODUCT
            ? 'Featured Product'
            : 'Latest Courses'
        : title;

    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20, color: ColorResources.WHITE),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(_header, style: titilliumRegular.copyWith(fontSize: 20, color: ColorResources.WHITE)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            // await _loadData(context, true);
            return true;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: ProductView(isHomePage: false, productType: productType, scrollController: _scrollController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
