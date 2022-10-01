import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/utill/images.dart';
import 'package:mechatronia_app/view/basewidget/button/custom_button.dart';
import 'package:mechatronia_app/view/basewidget/show_custom_snakbar.dart';
import 'package:mechatronia_app/view/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'code_picker_widget.dart';
import 'otp_verification_screen.dart';

class MobileVerificationScreen extends StatefulWidget {
  final String tempToken;
  MobileVerificationScreen(this.tempToken);

  @override
  _MobileVerificationScreenState createState() => _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  TextEditingController _numberController;
  final FocusNode _numberFocus = FocusNode();
  String _countryDialCode = '+880';

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    _countryDialCode =
        CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode)
            .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    final number = ModalRoute.of(context).settings.arguments;
    _numberController.text = number;
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 30),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Image.asset(Images.login,
                              matchTextDirection: true, height: MediaQuery.of(context).size.height / 4.5),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                          child: Text(
                        getTranslated('mobile_verification', context),
                      )),

                      SizedBox(height: 35),

                      Text(
                        getTranslated('mobile_number', context),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(children: [
                          CodePickerWidget(
                            onChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            initialSelection: _countryDialCode,
                            favorite: [_countryDialCode],
                            showDropDownButton: true,
                            padding: EdgeInsets.zero,
                            showFlagMain: true,
                            textStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),
                          ),
                          Expanded(
                              child: CustomTextField(
                            hintText: getTranslated('number_hint', context),
                            controller: _numberController,
                            focusNode: _numberFocus,
                            isPhoneNumber: true,
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.phone,
                          )),
                        ]),
                      ),

                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // for continue button
                      SizedBox(height: 12),
                      !authProvider.isPhoneNumberVerificationButtonLoading
                          ? CustomButton(
                              buttonText: getTranslated('continue', context),
                              onTap: () async {
                                // String countryCode;
                                String _number = _countryDialCode + _numberController.text.trim();
                                String _numberChk = _numberController.text.trim();

                                if (_numberChk.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                } else {
                                  authProvider.checkPhone(_number, widget.tempToken).then((value) async {
                                    if (value.isSuccess) {
                                      authProvider.updatePhone(_number);
                                      if (value.message == 'active') {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => VerificationScreen(widget.tempToken, _number, ''),
                                              settings: RouteSettings(
                                                arguments: _number,
                                              ),
                                            ),
                                            (route) => false);
                                      }
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(getTranslated('phone_number_already_exist', context)),
                                        backgroundColor: Colors.red,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
