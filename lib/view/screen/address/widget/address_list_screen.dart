import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/address_model.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/images.dart';

class AddressListPage extends StatelessWidget {
  final AddressModel address;
  AddressListPage({Key key, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        address.addressType == 'Home'
            ? Images.home_image
            : address.addressType == 'Ofice'
                ? Images.bag
                : Images.more_image,
        color: ColorResources.getSellerTxt(context),
        height: 30,
        width: 30,
      ),
      title: Text(address.address, style: titilliumRegular),
    );
  }
}
