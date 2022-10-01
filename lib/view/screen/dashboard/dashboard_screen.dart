import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/category.dart';
import 'package:mechatronia_app/helper/network_info.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/screen/category/all_category_screen.dart';
import 'package:mechatronia_app/view/screen/home/ServiceScreen.dart';
import 'package:mechatronia_app/view/screen/home/home_screen.dart';
import 'package:mechatronia_app/view/screen/more/more_screen.dart';
import 'package:mechatronia_app/view/screen/order/order_screen.dart';
import 'package:mechatronia_app/view/screen/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PageController _pageController = PageController();
  int _pageIndex = 0;

  List<Widget> _screens;

  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashProvider>(context, listen: false).configModel.businessMode == "single";

    _screens = [HomePage(), AllCategoryScreen(), WishListScreen(), MoreScreen()];

    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    /*  final count = Provider.of<ServiceProvider>(
      context, listen: false
    ).getCount(context); */
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).textTheme.bodyText1.color,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: _getBottomWidget(singleVendor),
          onTap: (int index) {
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        icon,
        color: index == _pageIndex
            ? Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
        height: 25,
        width: 25,
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  List<BottomNavigationBarItem> _getBottomWidget(bool isSingleVendor) {
    List<BottomNavigationBarItem> _list = [];
    _list.add(_barItem(Images.home_image, getTranslated('home', context), 0));
    /* if(!isSingleVendor) {
      _list.add(_barItem(Images.message_image, getTranslated('inbox', context), 1));
    } */
    _list.add(_barItem(Images.more_filled_image, "Categories", 1));
    _list.add(_barItem(Images.wish_image, "Wishlist", 2));
    _list.add(_barItem(Images.more_image, getTranslated('more', context), 3));
    return _list;
  }
}
