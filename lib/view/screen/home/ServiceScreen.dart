import 'package:flutter/material.dart';
import 'package:mechatronia_app/helper/product_type.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/screen/home/widget/products_view.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatelessWidget {
  final bool isBacButtonExist;
  ServiceScreen({this.isBacButtonExist = true});

  @override
  Widget build(BuildContext context) {
    // _loadData(context, false);

    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))),
        title: Text(getTranslated("service", context),
            style: titilliumRegular.copyWith(fontSize: 20, color: ColorResources.WHITE)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            // await _loadData(context, true);
            return true;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: ProductView(
                    isHomePage: false,
                    productType: ProductType.SERVICE,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
