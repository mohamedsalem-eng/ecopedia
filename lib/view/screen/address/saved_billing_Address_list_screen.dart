import 'package:flutter/material.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/order_provider.dart';
import 'package:mechatronia_app/provider/profile_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/screen/address/widget/address_list_screen.dart';
import 'package:provider/provider.dart';

class SavedBillingAddressListScreen extends StatelessWidget {
  const SavedBillingAddressListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                profile.billingAddressList != null
                    ? profile.billingAddressList.length != 0
                        ? SizedBox(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: profile.billingAddressList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Provider.of<OrderProvider>(context, listen: false).setBillingAddressIndex(index);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorResources.getIconBg(context),
                                      border: index == Provider.of<OrderProvider>(context).billingAddressIndex
                                          ? Border.all(width: 2, color: Theme.of(context).primaryColor)
                                          : null,
                                    ),
                                    child: AddressListPage(address: profile.billingAddressList[index]),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                            child: Center(
                                child: Text(
                              getTranslated('no_address_available', context),
                              style: titilliumRegular,
                            )),
                          )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
              ],
            ),
          );
        },
      )),
    );
  }
}
