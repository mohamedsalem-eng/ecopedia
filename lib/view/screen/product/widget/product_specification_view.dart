import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/basewidget/title_row.dart';
import 'package:mechatronia_app/view/screen/product/specification_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductSpecification extends StatelessWidget {
  final String productSpecification;
  final bool isService;
  ProductSpecification({@required this.productSpecification, @required this.isService});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    return Column(
      children: [
        TitleRow(
            title: isService ? getTranslated('description', context) : getTranslated('specification', context),
            isDetailsPage: true,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SpecificationScreen(specification: productSpecification)));
            }),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        productSpecification.isNotEmpty
            ? Html(data: productSpecification)
            : Center(
                child: Text(
                    isService ? getTranslated('no_description', context) : getTranslated('no_specification', context))),
      ],
    );
  }
}
