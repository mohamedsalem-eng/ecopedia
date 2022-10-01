import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/body/register_model.dart';
import 'package:mechatronia_app/helper/email_checker.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/provider/auth_provider.dart';
import 'package:mechatronia_app/provider/profile_provider.dart';
import 'package:mechatronia_app/provider/splash_provider.dart';
import 'package:mechatronia_app/utill/color_resources.dart';
import 'package:mechatronia_app/utill/custom_themes.dart';
import 'package:mechatronia_app/utill/dimensions.dart';
import 'package:mechatronia_app/view/basewidget/button/custom_button.dart';
import 'package:mechatronia_app/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:mechatronia_app/view/basewidget/textfield/custom_textfield.dart';
import 'package:mechatronia_app/view/screen/auth/widget/social_login_widget.dart';
import 'package:mechatronia_app/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'code_picker_widget.dart';
import 'otp_verification_screen.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey;

  FocusNode _fNameFocus = FocusNode();
  FocusNode _lNameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();

  RegisterModel register = RegisterModel();
  bool isEmailVerified = false;

  addUser() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      isEmailVerified = true;

      String _firstName = _firstNameController.text.trim();
      String _lastName = _lastNameController.text.trim();
      String _email = _emailController.text.trim();
      String _phone = _phoneController.text.trim();
      String _phoneNumber = _countryDialCode + _phoneController.text.trim();
      String _password = _passwordController.text.trim();
      String _confirmPassword = _confirmPasswordController.text.trim();

      if (_firstName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('first_name_field_is_required', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_lastName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('last_name_field_is_required', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else if (EmailChecker.isNotValid(_email)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('enter_valid_email_address', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_phone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PASSWORD_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('CONFIRM_PASSWORD_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PASSWORD_DID_NOT_MATCH', context)),
          backgroundColor: Colors.red,
        ));
      } else {
        register.fName = '${_firstNameController.text}';
        register.lName = _lastNameController.text ?? " ";
        register.email = _emailController.text;
        register.phone = _phoneNumber;
        register.password = _passwordController.text;
        await Provider.of<AuthProvider>(context, listen: false).registration(register, route);
      }
    } else {
      isEmailVerified = false;
    }
  }

  route(bool isRoute, String token, String tempToken, String errorMessage) async {
    String _phone = _countryDialCode + _phoneController.text.trim();
    if (isRoute) {
      if (Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification) {
        Provider.of<AuthProvider>(context, listen: false)
            .checkEmail(_emailController.text.toString(), tempToken)
            .then((value) async {
          if (value.isSuccess) {
            Provider.of<AuthProvider>(context, listen: false).updateEmail(_emailController.text.toString());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => VerificationScreen(tempToken, '', _emailController.text.toString())),
                (route) => false);
          }
        });
      } else if (Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification) {
        Provider.of<AuthProvider>(context, listen: false).checkPhone(_phone, tempToken).then((value) async {
          if (value.isSuccess) {
            Provider.of<AuthProvider>(context, listen: false).updatePhone(_phone);
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => VerificationScreen(tempToken, _phone, '')), (route) => false);
          }
        });
      } else {
        await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
        _emailController.clear();
        _passwordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
        _phoneController.clear();
        _confirmPasswordController.clear();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  String _countryDialCode = "+880";
  @override
  void initState() {
    super.initState();
    Provider.of<SplashProvider>(context, listen: false).configModel;
    _countryDialCode =
        CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode)
            .dialCode;

    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              // for first and last name
              Container(
                margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomTextField(
                      hintText: getTranslated('FIRST_NAME', context),
                      textInputType: TextInputType.name,
                      focusNode: _fNameFocus,
                      nextNode: _lNameFocus,
                      isPhoneNumber: false,
                      capitalization: TextCapitalization.words,
                      controller: _firstNameController,
                    )),
                    SizedBox(width: 15),
                    Expanded(
                        child: CustomTextField(
                      hintText: getTranslated('LAST_NAME', context),
                      focusNode: _lNameFocus,
                      nextNode: _emailFocus,
                      capitalization: TextCapitalization.words,
                      controller: _lastNameController,
                    )),
                  ],
                ),
              ),

              // for email
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                    top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  hintText: getTranslated('ENTER_YOUR_EMAIL', context),
                  focusNode: _emailFocus,
                  nextNode: _phoneFocus,
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
              ),

              // for phone

              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                    top: Dimensions.MARGIN_SIZE_SMALL),
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
                    hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    nextNode: _passwordFocus,
                    isPhoneNumber: true,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.phone,
                  )),
                ]),
              ),

              // for password
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                    top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomPasswordTextField(
                  hintTxt: getTranslated('PASSWORD', context),
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  nextNode: _confirmPasswordFocus,
                  textInputAction: TextInputAction.next,
                ),
              ),

              // for re-enter password
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT,
                    top: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomPasswordTextField(
                  hintTxt: getTranslated('RE_ENTER_PASSWORD', context),
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),

        // for register button
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
          child: Provider.of<AuthProvider>(context).isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : CustomButton(onTap: addUser, buttonText: getTranslated('SIGN_UP', context)),
        ),

        SocialLoginWidget(),

        // for skip for now
        Provider.of<AuthProvider>(context).isLoading
            ? SizedBox()
            : Center(
                child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashBoardScreen()));
                },
                child: Text(getTranslated('SKIP_FOR_NOW', context),
                    style: titilliumRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getColombiaBlue(context))),
              )),
      ],
    );
  }
}
