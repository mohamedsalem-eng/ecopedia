import 'dart:io';

import 'package:mechatronia_app/data/model/response/service_reply_model.dart';
import 'package:mechatronia_app/data/model/response/service_ticket_model.dart';
import 'package:mechatronia_app/data/repository/service_repo.dart';
import 'package:mechatronia_app/helper/api_checker.dart';
import 'package:mechatronia_app/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:mechatronia_app/data/model/response/base/api_response.dart';
import 'package:mechatronia_app/data/model/response/base/error_response.dart';

class ServiceProvider extends ChangeNotifier {
  final ServiceRepo serviceRepo;
  ServiceProvider({@required this.serviceRepo});

  List<ServiceTicketModel> _serviceTicketList;
  List<ServiceReplyModel> _serviceReplyList;
  int _count;
  bool _isLoading = false;

  List<ServiceTicketModel> get serviceTicketList => _serviceTicketList;
  List<ServiceReplyModel> get serviceReplyList =>
      _serviceReplyList != null ? _serviceReplyList.reversed.toList() : _serviceReplyList;
  bool get isLoading => _isLoading;
  int get count => _count;

  Future submitService(int productId, File file, String note,
      Function(bool isSuccess, String message, BuildContext context) callback, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await serviceRepo.sendSupportTicket(productId, file, note);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data["message"];
      callback(true, message, context);
      _isLoading = false;
      _serviceTicketList
          .add(ServiceTicketModel(description: note, createdAt: DateConverter.formatDate(DateTime.now()), status: 0));

      getServiceTicketList(context);
      notifyListeners();
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, context);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getServiceTicketList(BuildContext context) async {
    ApiResponse apiResponse = await serviceRepo.getServiceTicketList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _serviceTicketList = [];
      apiResponse.response.data
          .forEach((supportTicket) => _serviceTicketList.add(ServiceTicketModel.fromJson(supportTicket)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getserviceReplyList(BuildContext context, int ticketID) async {
    _serviceReplyList = null;
    ApiResponse apiResponse = await serviceRepo.getserviceReplyList(ticketID.toString());
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _serviceReplyList = [];
      apiResponse.response.data
          .forEach((supportReply) => _serviceReplyList.add(ServiceReplyModel.fromJson(supportReply)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> sendReply(BuildContext context, int ticketID, String message) async {
    ApiResponse apiResponse = await serviceRepo.sendReply(ticketID.toString(), message);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _serviceReplyList.add(
          ServiceReplyModel(customerMessage: message, createdAt: DateConverter.localDateToIsoString(DateTime.now())));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getCount(BuildContext context) async {
    ApiResponse apiResponse = await serviceRepo.getCount;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _count = apiResponse.response?.data['message'] ?? 0;
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
}
