import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/datasource/remote/dio/dio_client.dart';
import 'package:mechatronia_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:mechatronia_app/data/model/response/base/api_response.dart';
import 'package:mechatronia_app/data/model/response/onboarding_model.dart';
import 'package:mechatronia_app/localization/language_constrants.dart';
import 'package:mechatronia_app/utill/app_constants.dart';

class OnBoardingRepo {
  final DioClient dioClient;
  OnBoardingRepo({@required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext context) async {
    try {
      List<OnboardingModel> onBoardingList = [
        OnboardingModel(
          'assets/images/onboarding_image_one.png',
          '${getTranslated('on_boarding_title_one', context)} ${AppConstants.APP_NAME}',
          getTranslated('on_boarding_description_one', context),
        ),
        OnboardingModel(
          'assets/images/onboarding_image_two.png',
          getTranslated('on_boarding_title_two', context),
          getTranslated('on_boarding_description_two', context),
        ),
        OnboardingModel(
          'assets/images/onboarding_image_three.png',
          getTranslated('on_boarding_title_three', context),
          getTranslated('on_boarding_description_three', context),
        ),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
