import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/product_model.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';

import 'package:mechatronia_app/provider/product_details_provider.dart';
import 'package:mechatronia_app/provider/service_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/basewidget/animated_custom_dialog.dart';
import 'package:mechatronia_app/view/basewidget/button/custom_button.dart';
import 'package:mechatronia_app/view/basewidget/guest_dialog.dart';
import 'package:mechatronia_app/view/basewidget/show_custom_snakbar.dart';
import 'package:mechatronia_app/view/screen/product/widget/onLoading.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class FileBottomSheet extends StatefulWidget {
  final Product product;
  final Function callback;
  FileBottomSheet({@required this.product, this.callback});

  @override
  _FileBottomSheetState createState() => _FileBottomSheetState();
}

class _FileBottomSheetState extends State<FileBottomSheet> {
  String _note;
  File _file;
  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductDetailsProvider>(context, listen: false).initData(widget.product);

    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              ),
              child: Consumer<ProductDetailsProvider>(
                builder: (context, details, child) {
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Close Button
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).highlightColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200],
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  )
                                ]),
                            child: Icon(Icons.clear, size: Dimensions.ICON_SIZE_SMALL),
                          ),
                        )),

                    // Product details
                    Row(children: [
                      Container(
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          color: ColorResources.getImageBg(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${widget.product.thumbnail}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(widget.product.name ?? '',
                              style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ]),
                      ),
                      Expanded(child: SizedBox.shrink()),
                    ]),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (note) {
                              _note = note;
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                                label: Text(getTranslated("note", context)), border: OutlineInputBorder()),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Text(_file == null ? getTranslated("select_file", context) : p.basename(_file.path)),
                            onPressed: () async {
                              final ext = Provider.of<SplashProvider>(context, listen: false).configModel.fileExt;

                              FilePickerResult result = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ext,
                              );

                              if (result != null) {
                                setState(() {
                                  _file = File(result.files.single.path);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    // Cart button
                    Builder(builder: (context) {
                      return CustomButton(
                          buttonText: getTranslated('send_file', context),
                          onTap: () async {
                            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                              if (_file == null) {
                                Navigator.pop(context);
                                showCustomSnackBar(getTranslated('send_file', context), context, isError: true);
                              } else {
                                onLoading(context);
                                await Provider.of<ServiceProvider>(context, listen: false)
                                    .submitService(widget.product.id, _file, _note, callback, context);
                                Navigator.of(context).pop();
                              }
                            } else {
                              return showAnimatedDialog(context, GuestDialog(), isFlip: true);
                            }
                          });
                    }),
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void callback(bool isSuccess, String message, context) {
    if (isSuccess) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      showCustomSnackBar(message, context, isError: false);
    } else {
      Navigator.of(context).pop();
      showCustomSnackBar(message, context, isError: true);
    }
  }
}
