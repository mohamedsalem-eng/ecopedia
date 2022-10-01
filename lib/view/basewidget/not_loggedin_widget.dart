import 'package:flutter/material.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/basewidget/button/custom_button.dart';
import 'package:mechatronia_app/view/screen/auth/auth_screen.dart';
import 'package:provider/provider.dart';

class NotLoggedInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.all(_height * 0.025),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.login, height: _height * 0.2, width: _width),
            SizedBox(height: _height * 0.05),
            Text(getTranslated('PLEASE_LOGIN_FIRST', context),
                textAlign: TextAlign.center, style: titilliumSemiBold.copyWith(fontSize: _height * 0.017)),
            SizedBox(height: _height * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: CustomButton(
                buttonText: getTranslated('LOGIN', context),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen())),
              ),
            ),
            InkWell(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).updateSelectedIndex(1);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(initialPage: 1)));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: _height * 0.02),
                child: Text(getTranslated('create_new_account', context),
                    style: titilliumRegular.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                    )),
              ),
            ),
          ],
        ));
  }
}
