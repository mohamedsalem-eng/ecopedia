import 'package:flutter/material.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/profile_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/view/basewidget/custom_app_bar.dart';
import 'package:mechatronia_app/view/basewidget/no_internet_screen.dart';
import 'package:mechatronia_app/view/basewidget/not_loggedin_widget.dart';
import 'package:mechatronia_app/view/basewidget/show_custom_modal_dialog.dart';
import 'package:mechatronia_app/view/screen/address/add_new_address_screen.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (!isGuestMode) {
      Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
      Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    }
    final areaList = Provider.of<SplashProvider>(context, listen: false).configModel.areaList;

    return Scaffold(
      floatingActionButton: isGuestMode
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) => AddNewAddressScreen(isBilling: false))),
              child: Icon(Icons.add, color: Theme.of(context).highlightColor),
              backgroundColor: ColorResources.getPrimary(context),
            ),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('ADDRESS_LIST', context)),
          isGuestMode
              ? Expanded(child: NotLoggedInWidget())
              : Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return profileProvider.shippingAddressList != null
                        ? profileProvider.shippingAddressList.length > 0
                            ? Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
                                    await Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
                                  },
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    itemCount: profileProvider.shippingAddressList.length,
                                    itemBuilder: (context, index) => Card(
                                      child: ListTile(
                                        title: Text(
                                            'Address: ${profileProvider.shippingAddressList[index].address}' ?? ""),
                                        subtitle: Text(
                                            'City: ${areaList.firstWhere((element) => element.id.toString() == profileProvider.shippingAddressList[index].city).name ?? ""}'),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete_forever, color: Colors.red),
                                          onPressed: () {
                                            showCustomModalDialog(
                                              context,
                                              title: getTranslated('REMOVE_ADDRESS', context),
                                              content: profileProvider.shippingAddressList[index].address,
                                              cancelButtonText: getTranslated('CANCEL', context),
                                              submitButtonText: getTranslated('REMOVE', context),
                                              submitOnPressed: () {
                                                Provider.of<ProfileProvider>(context, listen: false).removeAddressById(
                                                    profileProvider.shippingAddressList[index].id, index, context);
                                                Provider.of<ProfileProvider>(context, listen: false)
                                                    .initAddressList(context);
                                                Navigator.of(context).pop();
                                              },
                                              cancelOnPressed: () => Navigator.of(context).pop(),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(child: NoInternetOrDataScreen(isNoInternet: false))
                        : Expanded(
                            child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))));
                  },
                ),
        ],
      ),
    );
  }
}
