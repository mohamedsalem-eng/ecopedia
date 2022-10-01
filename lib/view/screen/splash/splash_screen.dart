import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/provider/theme_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/basewidget/no_internet_screen.dart';
import 'package:mechatronia_app/view/screen/auth/auth_screen.dart';
import 'package:mechatronia_app/view/screen/dashboard/dashboard_screen.dart';
import 'package:mechatronia_app/view/screen/maintenance/maintenance_screen.dart';
import 'package:mechatronia_app/view/screen/onboarding/onboarding_screen.dart';
import 'package:mechatronia_app/view/screen/splash/widget/splash_painter.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', context) : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig(context).then((bool isSuccess) {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false).initSharedPrefData();
        Timer(Duration(seconds: 1), () {
          if (Provider.of<SplashProvider>(context, listen: false).configModel.maintenanceMode) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MaintenanceScreen()));
          } else {
            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken(context);
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => DashBoardScreen()));
            }
            else {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AuthScreen()));
                }
            // else {
            //   if (Provider.of<SplashProvider>(context, listen: false).showIntro()) {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //         builder: (BuildContext context) => OnBoardingScreen(
            //               indicatorColor: ColorResources.GREY,
            //               selectedIndicatorColor: Theme.of(context).primaryColor,
            //             )));
            //   } else {
            //     Navigator.of(context)
            //         .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AuthScreen()));
            //   }
            // }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Provider.of<SplashProvider>(context).hasConnection
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors
                      .white, //Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : ColorResources.getPrimary(context),
                  // child: CustomPaint(
                  //   painter: SplashPainter(),
                  // ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(Images.splash_logo, height: 350.0, fit: BoxFit.scaleDown, width: 350.0),
                    ],
                  ),
                ),
              ],
            )
          : NoInternetOrDataScreen(isNoInternet: true, child: SplashScreen()),
    );
  }
}
