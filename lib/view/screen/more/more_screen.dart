import 'package:flutter/material.dart';
import 'package:mechatronia_app/provider/cart_provider.dart';
import 'package:mechatronia_app/provider/localization_provider.dart';
import 'package:mechatronia_app/provider/service_provider.dart';
import 'package:mechatronia_app/provider/wishlist_provider.dart';
import 'package:mechatronia_app/view/screen/chat/inbox_screen.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/profile_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/basewidget/animated_custom_dialog.dart';
import 'package:mechatronia_app/view/basewidget/guest_dialog.dart';
import 'package:mechatronia_app/view/screen/cart/cart_screen.dart';
import 'package:mechatronia_app/view/screen/category/all_category_screen.dart';
import 'package:mechatronia_app/view/screen/more/web_view_screen.dart';
import 'package:mechatronia_app/view/screen/more/widget/html_view_Screen.dart';
import 'package:mechatronia_app/view/screen/more/widget/sign_out_confirmation_dialog.dart';
import 'package:mechatronia_app/view/screen/notification/notification_screen.dart';
import 'package:mechatronia_app/view/screen/offer/offers_screen.dart';
import 'package:mechatronia_app/view/screen/order/order_screen.dart';
import 'package:mechatronia_app/view/screen/profile/address_list_screen.dart';
import 'package:mechatronia_app/view/screen/profile/profile_screen.dart';
import 'package:mechatronia_app/view/screen/service/service_ticket_screen.dart';
import 'package:mechatronia_app/view/screen/setting/settings_screen.dart';
import 'package:mechatronia_app/view/screen/support/support_ticket_screen.dart';
import 'package:mechatronia_app/view/screen/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import 'faq_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool isGuestMode;
  String version;
  bool singleVendor = false;
  @override
  void initState() {
    isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (!isGuestMode) {
      Provider.of<ServiceProvider>(context, listen: false).getCount(context);
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      Provider.of<WishListProvider>(context, listen: false).initWishList(
        context,
        Provider.of<LocalizationProvider>(context, listen: false).locale.countryCode,
      );
      version = Provider.of<SplashProvider>(context, listen: false).configModel?.version != null
          ? Provider.of<SplashProvider>(context, listen: false).configModel?.version
          : 'version';
    }
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel.businessMode == "single";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final count = Provider.of<ServiceProvider>(context).count;
    return Scaffold(
      body: Stack(children: [
        // Background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            Images.more_page_header,
            height: 150,
            fit: BoxFit.fill,
            color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : ColorResources.getPrimary(context),
          ),
        ),

        // AppBar
        Positioned(
          top: 40,
          left: Dimensions.PADDING_SIZE_SMALL,
          right: Dimensions.PADDING_SIZE_SMALL,
          child: Consumer<ProfileProvider>(
            builder: (context, profile, child) {
              return Row(children: [
                Image.asset(Images.translogo, height: 60, color: ColorResources.WHITE),
                Expanded(child: SizedBox.shrink()),
                InkWell(
                  onTap: () {
                    if (isGuestMode) {
                      showAnimatedDialog(context, GuestDialog(), isFlip: true);
                    } else {
                      if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                      }
                    }
                  },
                  child: Row(children: [
                    Text(
                        !isGuestMode
                            ? profile.userInfoModel != null
                                ? '${profile.userInfoModel.fName} ${profile.userInfoModel.lName}'
                                : 'Full Name'
                            : 'Guest',
                        style: titilliumRegular.copyWith(color: ColorResources.WHITE)),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    isGuestMode
                        ? CircleAvatar(child: Icon(Icons.person, size: 35))
                        : profile.userInfoModel == null
                            ? CircleAvatar(child: Icon(Icons.person, size: 35))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.logo_image,
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.fill,
                                  image:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModel.image}',
                                  imageErrorBuilder: (c, o, s) => CircleAvatar(child: Icon(Icons.person, size: 35)),
                                ),
                              ),
                  ]),
                ),
              ]);
            },
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 120),
          decoration: BoxDecoration(
            color: ColorResources.getIconBg(context),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              // Top Row Items
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SquareButton(
                  image: Images.live,
                  title: "Live",
                  navigateTo: MoreScreen(),
                  count: 1,
                  hasCount: false,
                ),
                SquareButton(
                  image: Images.accessibility,
                  title: "Accessibility",
                  navigateTo: MoreScreen(),
                  count: 1,
                  hasCount: false,
                ),
                SquareButton(
                  image: Images.offers,
                  title: "Donate",
                navigateTo: MoreScreen(),
                  count: 0,
                  hasCount: false,
                ),
                SquareButton(
                  image: Images.wishlist,
                  title: getTranslated('wishlist', context),
                  navigateTo: WishListScreen(),
                  count: Provider.of<AuthProvider>(context, listen: false).isLoggedIn() &&
                          Provider.of<WishListProvider>(context, listen: false).wishList != null &&
                          Provider.of<WishListProvider>(context, listen: false).wishList.length > 0
                      ? Provider.of<WishListProvider>(context, listen: false).wishList.length
                      : 0,
                  hasCount: false,
                ),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              // Buttons
              // TitleButton(
              //   image: Images.preference,
              //   title: getTranslated('service_enquiry', context),
              //   navigateTo: ServiceTicketScreen(),
              //   count: count,
              // ),
              // TitleButton(
              //     image: Images.fast_delivery,
              //     title: getTranslated('address', context),
              //     navigateTo: AddressListScreen()),
              TitleButton(
                  image: Images.more_filled_image,
                  title: getTranslated('all_category', context),
                  navigateTo: AllCategoryScreen()),
              TitleButton(
                  image: Images.notification_filled,
                  title: getTranslated('notification', context),
                  navigateTo: NotificationScreen()),
              //TODO: seller
              singleVendor
                  ? SizedBox()
                  : TitleButton(image: Images.chats, title: getTranslated('chats', context), navigateTo: InboxScreen()),
              TitleButton(
                  image: Images.settings, title: getTranslated('settings', context), navigateTo: SettingsScreen()),
              TitleButton(
                  image: Images.preference,
                  title: getTranslated('support_ticket', context),
                  navigateTo: SupportTicketScreen()),
              TitleButton(
                  image: Images.term_condition,
                  title: getTranslated('terms_condition', context),
                  navigateTo: HtmlViewScreen(
                    title: getTranslated('terms_condition', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                  )),
              TitleButton(
                  image: Images.privacy_policy,
                  title: getTranslated('privacy_policy', context),
                  navigateTo: HtmlViewScreen(
                    title: getTranslated('privacy_policy', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                  )),
              TitleButton(
                  image: Images.help_center,
                  title: getTranslated('faq', context),
                  navigateTo: FaqScreen(
                    title: getTranslated('faq', context),
                    // url: Provider.of<SplashProvider>(context, listen: false).configModel.staticUrls.faq,
                  )),

              TitleButton(
                  image: Images.about_us,
                  title: getTranslated('about_us', context),
                  navigateTo: HtmlViewScreen(
                    title: getTranslated('about_us', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.aboutUs,
                  )),

              TitleButton(
                  image: Images.contact_us,
                  title: getTranslated('contact_us', context),
                  navigateTo: WebViewScreen(
                    title: getTranslated('contact_us', context),
                    url: Provider.of<SplashProvider>(context, listen: false).configModel.staticUrls.contactUs,
                  )),

              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: ColorResources.getPrimary(context),
                    width: 35,
                    height: 35,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(child: Icon(Icons.ad_units,color: Colors.white,)),
                    ),
                  ),
                ),
                title: Text(getTranslated('app_info', context),
                    style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                trailing: Text(version ?? ""),
              ),

              isGuestMode
                  ? SizedBox()
                  : ListTile(
                      leading: Icon(Icons.exit_to_app, color: ColorResources.getPrimary(context), size: 25),
                      title: Text(getTranslated('sign_out', context),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      onTap: () => showAnimatedDialog(context, SignOutConfirmationDialog(), isFlip: true),
                    ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;

  SquareButton(
      {@required this.image,
      @required this.title,
      @required this.navigateTo,
      @required this.count,
      @required this.hasCount});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 100;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(children: [
        Container(
          width: width / 4,
          height: width / 4,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorResources.getPrimary(context),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(image, color: Theme.of(context).highlightColor),
              hasCount
                  ? Positioned(
                      top: -4,
                      right: -4,
                      child: Consumer<CartProvider>(builder: (context, cart, child) {
                        return CircleAvatar(
                          radius: 7,
                          backgroundColor: ColorResources.RED,
                          child: Text(count.toString(),
                              style: titilliumSemiBold.copyWith(
                                color: ColorResources.WHITE,
                                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                              )),
                        );
                      }),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(title, style: titilliumRegular),
        ),
      ]),
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String title;
  final int count;
  final Widget navigateTo;
  TitleButton({@required this.image, @required this.title, @required this.navigateTo, this.count});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image, width: 25, height: 25, fit: BoxFit.fill, color: ColorResources.getPrimary(context)),
      title: Text(title, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      trailing: count == null || count == 0
          ? null
          : Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: ColorResources.RED,
                child: Text(count.toString(),
                    style: titilliumSemiBold.copyWith(
                      color: ColorResources.WHITE,
                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    )),
              ),
            ),
      onTap: () => Navigator.push(
        context,
        /*PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              animation = CurvedAnimation(parent: animation, curve: Curves.bounceInOut);
              return ScaleTransition(scale: animation, child: child, alignment: Alignment.center);
            },
          ),*/
        MaterialPageRoute(builder: (_) => navigateTo),
      ),
      /*onTap: () => Navigator.push(context, PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: Duration(milliseconds: 500),
      )),*/
    );
  }
}
