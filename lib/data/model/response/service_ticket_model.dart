import 'package:mechatronia_app/data/model/response/product_model.dart';

class ServiceTicketModel {
  int _id;
  int _customerId;
  String _subject;
  Product _product;
  String _type;
  String _priority;
  String _description;
  String _reply;
  int _status;
  int _notSeen;
  String _createdAt;
  String _updatedAt;

  ServiceTicketModel(
      {int id,
      int customerId,
      String subject,
      String type,
      Product product,
      String priority,
      String description,
      String reply,
      int status,
      int notSeen,
      String createdAt,
      String updatedAt}) {
    this._id = id;
    this._customerId = customerId;
    this._subject = subject;
    this._product = product;
    this._type = type;
    this._notSeen = notSeen;
    this._priority = priority;
    this._description = description;
    this._reply = reply;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  int get notSeen => _notSeen;
  int get customerId => _customerId;
  String get subject => _subject;
  Product get product => _product;
  String get type => _type;
  String get priority => _priority;
  String get description => _description;
  String get reply => _reply;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  ServiceTicketModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _customerId = json['user_id'];
    _subject = json['subject'];
    _product = Product.fromJson(json['product'] ?? []);
    _type = json['type'];
    _notSeen = json['not_seen_count'];
    _priority = json['priority'];
    _description = json['description'];
    _reply = json['reply'];
    _status = json['status'] != "close" ? 0 : 1;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._customerId;
    data['subject'] = this._subject;
    data['type'] = this._type;
    data['priority'] = this._priority;
    data['description'] = this._description;
    data['not_seen_count'] = this._notSeen;
    data['reply'] = this._reply;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
