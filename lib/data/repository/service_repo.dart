import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/datasource/remote/dio/dio_client.dart';
import 'package:mechatronia_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:mechatronia_app/data/model/response/base/api_response.dart';
import 'package:mechatronia_app/utill/app_constants.dart';

class ServiceRepo {
  final DioClient dioClient;
  ServiceRepo({@required this.dioClient});

  Future<ApiResponse> sendSupportTicket(int productId, File file, String note) async {
    try {
      String fileName = file.path.split('/').last;
      FormData _formData = FormData.fromMap({
        "enquiry_file": await MultipartFile.fromFile(file.path, filename: fileName),
        "product_id": productId,
        "description": note,
      });
      Response response = await dioClient.post(AppConstants.SUBMIT_SERVICE_URI, data: _formData);
      print(response.data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getServiceTicketList() async {
    try {
      final response = await dioClient.get(AppConstants.SERVICE_TICKET_GET_URI);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getserviceReplyList(String ticketID) async {
    try {
      final response = await dioClient.get('${AppConstants.SERVICE_TICKET_CONV_URI}$ticketID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendReply(String ticketID, String message) async {
    try {
      final response =
          await dioClient.post('${AppConstants.SERVICE_TICKET_REPLY_URI}$ticketID', data: {'message': message});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> get getCount async {
    try {
      final response = await dioClient.get('${AppConstants.SERVICE_TICKET_COUNT_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
