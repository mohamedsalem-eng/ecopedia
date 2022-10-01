import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/service_ticket_model.dart';

import 'package:mechatronia_app/helper/date_converter.dart';

import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/service_provider.dart';

import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/basewidget/custom_expanded_app_bar.dart';
import 'package:mechatronia_app/view/basewidget/no_internet_screen.dart';
import 'package:mechatronia_app/view/screen/service/service_conversation_screen.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ServiceTicketScreen extends StatelessWidget {
  bool first = true;
  @override
  Widget build(BuildContext context) {
    if (first) {
      first = false;
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Provider.of<ServiceProvider>(context, listen: false).getServiceTicketList(context);
      }
    }

    return CustomExpandedAppBar(
      title: getTranslated('service_enquiry', context),
      isGuestCheck: true,
      child: Provider.of<ServiceProvider>(context).serviceTicketList != null
          ? Provider.of<ServiceProvider>(context).serviceTicketList.length != 0
              ? Consumer<ServiceProvider>(
                  builder: (context, support, child) {
                    List<ServiceTicketModel> serviceTicketList = support.serviceTicketList.reversed.toList();
                    return RefreshIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                      onRefresh: () async {
                        await support.getServiceTicketList(context);
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        itemCount: serviceTicketList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ServiceConversationScreen(
                                            serviceTicketModel: serviceTicketList[index],
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                color: ColorResources.getImageBg(context),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: ColorResources.getSellerTxt(context), width: 2),
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Place date: ${DateConverter.localDateToIsoStringAMPM(DateTime.parse(serviceTicketList[index].createdAt))}',
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                    (serviceTicketList[index]?.notSeen ?? 0) > 0
                                        ? CircleAvatar(
                                            radius: 7,
                                            backgroundColor: ColorResources.RED,
                                            child: Text(serviceTicketList[index]?.notSeen.toString(),
                                                style: titilliumSemiBold.copyWith(
                                                  color: ColorResources.WHITE,
                                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                )),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                                /* Text(serviceTicketList[index]?.product?.name ?? "", style: titilliumSemiBold), */
                                Row(children: [
                                  Icon(Icons.notifications, color: ColorResources.getPrimary(context), size: 20),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                      child: Text(serviceTicketList[index]?.product?.name ?? "",
                                          style: titilliumSemiBold)),
                                  TextButton(
                                    onPressed: null,
                                    style: TextButton.styleFrom(
                                      backgroundColor: serviceTicketList[index].status == 1
                                          ? ColorResources.getGreen(context)
                                          : Theme.of(context).primaryColor,
                                    ),
                                    child: Text(
                                      serviceTicketList[index].status == 0
                                          ? getTranslated('pending', context)
                                          : getTranslated('solved', context),
                                      style: titilliumSemiBold.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ]),
                              ]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : NoInternetOrDataScreen(isNoInternet: false)
          : SupportTicketShimmer(),
    );
  }
}

class SupportTicketShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: ColorResources.IMAGE_BG,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorResources.SELLER_TXT, width: 2),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: Provider.of<ServiceProvider>(context).serviceTicketList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 10, width: 100, color: ColorResources.WHITE),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Container(height: 15, color: ColorResources.WHITE),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                Container(height: 15, width: 15, color: ColorResources.WHITE),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Container(height: 15, width: 50, color: ColorResources.WHITE),
                Expanded(child: SizedBox.shrink()),
                Container(height: 30, width: 70, color: ColorResources.WHITE),
              ]),
            ]),
          ),
        );
      },
    );
  }
}
