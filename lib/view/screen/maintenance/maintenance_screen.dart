import 'package:flutter/material.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';

class MaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(Images.maintenance, width: 200, height: 200),
            Text(getTranslated('maintenance_mode', context),
                style: titilliumBold.copyWith(
                  fontSize: 30,
                  color: Theme.of(context).textTheme.bodyText1.color,
                )),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              getTranslated('maintenance_text', context),
              textAlign: TextAlign.center,
              style: titilliumRegular,
            ),
          ]),
        ),
      ),
    );
  }
}
