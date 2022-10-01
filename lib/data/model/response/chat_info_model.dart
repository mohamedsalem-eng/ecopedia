class ChatInfoModel {
  LastChat _lastChat;
  List<ChatList> _chatList;
  List<UniqueShops> _uniqueShops;

  ChatInfoModel(
      {LastChat lastChat,
        List<ChatList> chatList,
        List<UniqueShops> uniqueShops}) {
    if (lastChat != null) {
      this._lastChat = lastChat;
    }
    if (chatList != null) {
      this._chatList = chatList;
    }
    if (uniqueShops != null) {
      this._uniqueShops = uniqueShops;
    }
  }

  LastChat get lastChat => _lastChat;
  List<ChatList> get chatList => _chatList;
  List<UniqueShops> get uniqueShops => _uniqueShops;


  ChatInfoModel.fromJson(Map<String, dynamic> json) {
    _lastChat = json['last_chat'] != null
        ? new LastChat.fromJson(json['last_chat'])
        : null;
    if (json['chat_list'] != null) {
      _chatList = <ChatList>[];
      json['chat_list'].forEach((v) {
        _chatList.add(new ChatList.fromJson(v));
      });
    }
    if (json['unique_shops'] != null) {
      _uniqueShops = <UniqueShops>[];
      json['unique_shops'].forEach((v) {
        _uniqueShops.add(new UniqueShops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._lastChat != null) {
      data['last_chat'] = this._lastChat.toJson();
    }
    if (this._chatList != null) {
      data['chat_list'] = this._chatList.map((v) => v.toJson()).toList();
    }
    if (this._uniqueShops != null) {
      data['unique_shops'] = this._uniqueShops.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LastChat {
  int _id;
  int _userId;
  int _sellerId;
  String _message;
  int _sentByCustomer;
  int _sentBySeller;
  int _seenByCustomer;
  int _seenBySeller;
  int _status;
  String _createdAt;
  int _shopId;
  SellerInfo _sellerInfo;
  Shop _shop;

  LastChat(
      {int id,
        int userId,
        int sellerId,
        String message,
        int sentByCustomer,
        int sentBySeller,
        int seenByCustomer,
        int seenBySeller,
        int status,
        String createdAt,
        int shopId,
        SellerInfo sellerInfo,
        Shop shop}) {
    if (id != null) {
      this._id = id;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (sellerId != null) {
      this._sellerId = sellerId;
    }
    if (message != null) {
      this._message = message;
    }
    if (sentByCustomer != null) {
      this._sentByCustomer = sentByCustomer;
    }
    if (sentBySeller != null) {
      this._sentBySeller = sentBySeller;
    }
    if (seenByCustomer != null) {
      this._seenByCustomer = seenByCustomer;
    }
    if (seenBySeller != null) {
      this._seenBySeller = seenBySeller;
    }
    if (status != null) {
      this._status = status;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }

    if (shopId != null) {
      this._shopId = shopId;
    }
    if (sellerInfo != null) {
      this._sellerInfo = sellerInfo;
    }
    if (shop != null) {
      this._shop = shop;
    }
  }

  int get id => _id;
  int get userId => _userId;
  int get sellerId => _sellerId;
  String get message => _message;
  int get sentByCustomer => _sentByCustomer;
  int get sentBySeller => _sentBySeller;
  int get seenByCustomer => _seenByCustomer;
  int get seenBySeller => _seenBySeller;
  int get status => _status;
  String get createdAt => _createdAt;
  int get shopId => _shopId;
  SellerInfo get sellerInfo => _sellerInfo;
  Shop get shop => _shop;


  LastChat.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _sellerId = json['seller_id'];
    _message = json['message'];
    _sentByCustomer = json['sent_by_customer'];
    _sentBySeller = json['sent_by_seller'];
    _seenByCustomer = json['seen_by_customer'];
    _seenBySeller = json['seen_by_seller'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _shopId = json['shop_id'];
    _sellerInfo = json['seller_info'] != null
        ? new SellerInfo.fromJson(json['seller_info'])
        : null;

    _shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['seller_id'] = this._sellerId;
    data['message'] = this._message;
    data['sent_by_customer'] = this._sentByCustomer;
    data['sent_by_seller'] = this._sentBySeller;
    data['seen_by_customer'] = this._seenByCustomer;
    data['seen_by_seller'] = this._seenBySeller;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['shop_id'] = this._shopId;
    if (this._sellerInfo != null) {
      data['seller_info'] = this._sellerInfo.toJson();
    }

    if (this._shop != null) {
      data['shop'] = this._shop.toJson();
    }
    return data;
  }
}

class SellerInfo {
  int _id;
  String _fName;
  String _lName;
  String _phone;
  String _image;
  String _email;
  String _password;
  String _status;
  String _createdAt;
  String _updatedAt;
  String _bankName;
  String _branch;
  String _accountNo;
  String _holderName;
  String _authToken;
  int _salesCommissionPercentage;
  String _gst;
  String _cmFirebaseToken;
  int _posStatus;

  SellerInfo(
      {int id,
        String fName,
        String lName,
        String phone,
        String image,
        String email,
        String password,
        String status,
        String createdAt,
        String updatedAt,
        String bankName,
        String branch,
        String accountNo,
        String holderName,
        String authToken,
        int salesCommissionPercentage,
        String gst,
        String cmFirebaseToken,
        int posStatus}) {
    if (id != null) {
      this._id = id;
    }
    if (fName != null) {
      this._fName = fName;
    }
    if (lName != null) {
      this._lName = lName;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (image != null) {
      this._image = image;
    }
    if (email != null) {
      this._email = email;
    }
    if (password != null) {
      this._password = password;
    }
    if (status != null) {
      this._status = status;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (bankName != null) {
      this._bankName = bankName;
    }
    if (branch != null) {
      this._branch = branch;
    }
    if (accountNo != null) {
      this._accountNo = accountNo;
    }
    if (holderName != null) {
      this._holderName = holderName;
    }
    if (authToken != null) {
      this._authToken = authToken;
    }
    if (salesCommissionPercentage != null) {
      this._salesCommissionPercentage = salesCommissionPercentage;
    }
    if (gst != null) {
      this._gst = gst;
    }
    if (cmFirebaseToken != null) {
      this._cmFirebaseToken = cmFirebaseToken;
    }
    if (posStatus != null) {
      this._posStatus = posStatus;
    }
  }

  int get id => _id;
  String get fName => _fName;
  String get lName => _lName;
  String get phone => _phone;
  String get image => _image;
  String get email => _email;
  String get password => _password;
  String get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get bankName => _bankName;
  String get branch => _branch;
  String get accountNo => _accountNo;
  String get holderName => _holderName;
  String get authToken => _authToken;
  int get salesCommissionPercentage => _salesCommissionPercentage;
  String get gst => _gst;
  String get cmFirebaseToken => _cmFirebaseToken;
  int get posStatus => _posStatus;


  SellerInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _image = json['image'];
    _email = json['email'];
    _password = json['password'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _bankName = json['bank_name'];
    _branch = json['branch'];
    _accountNo = json['account_no'];
    _holderName = json['holder_name'];
    _authToken = json['auth_token'];
    _salesCommissionPercentage = json['sales_commission_percentage'];
    _gst = json['gst'];
    _cmFirebaseToken = json['cm_firebase_token'];
    _posStatus = json['pos_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['image'] = this._image;
    data['email'] = this._email;
    data['password'] = this._password;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['bank_name'] = this._bankName;
    data['branch'] = this._branch;
    data['account_no'] = this._accountNo;
    data['holder_name'] = this._holderName;
    data['auth_token'] = this._authToken;
    data['sales_commission_percentage'] = this._salesCommissionPercentage;
    data['gst'] = this._gst;
    data['cm_firebase_token'] = this._cmFirebaseToken;
    data['pos_status'] = this._posStatus;
    return data;
  }
}



class Shop {
  int _id;
  int _sellerId;
  String _name;
  String _address;
  String _contact;
  String _image;
  String _createdAt;
  String _updatedAt;
  String _banner;

  Shop(
      {int id,
        int sellerId,
        String name,
        String address,
        String contact,
        String image,
        String createdAt,
        String updatedAt,
        String banner}) {
    if (id != null) {
      this._id = id;
    }
    if (sellerId != null) {
      this._sellerId = sellerId;
    }
    if (name != null) {
      this._name = name;
    }
    if (address != null) {
      this._address = address;
    }
    if (contact != null) {
      this._contact = contact;
    }
    if (image != null) {
      this._image = image;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (banner != null) {
      this._banner = banner;
    }
  }

  int get id => _id;
  int get sellerId => _sellerId;
  String get name => _name;
  String get address => _address;
  String get contact => _contact;
  String get image => _image;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get banner => _banner;


  Shop.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _sellerId = json['seller_id'];
    _name = json['name'];
    _address = json['address'];
    _contact = json['contact'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['seller_id'] = this._sellerId;
    data['name'] = this._name;
    data['address'] = this._address;
    data['contact'] = this._contact;
    data['image'] = this._image;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['banner'] = this._banner;
    return data;
  }
}

class ChatList {
  int _id;
  int _userId;
  int _sellerId;
  String _message;
  int _sentByCustomer;
  int _sentBySeller;
  int _seenByCustomer;
  int _seenBySeller;
  int _status;
  String _createdAt;
  String _updatedAt;
  int _shopId;
  String _name;
  String _image;
  SellerInfo _sellerInfo;
  Shop _shop;

  ChatList(
      {int id,
        int userId,
        int sellerId,
        String message,
        int sentByCustomer,
        int sentBySeller,
        int seenByCustomer,
        int seenBySeller,
        int status,
        String createdAt,
        String updatedAt,
        int shopId,
        String name,
        String image,
        SellerInfo sellerInfo,
        Shop shop}) {
    if (id != null) {
      this._id = id;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (sellerId != null) {
      this._sellerId = sellerId;
    }
    if (message != null) {
      this._message = message;
    }
    if (sentByCustomer != null) {
      this._sentByCustomer = sentByCustomer;
    }
    if (sentBySeller != null) {
      this._sentBySeller = sentBySeller;
    }
    if (seenByCustomer != null) {
      this._seenByCustomer = seenByCustomer;
    }
    if (seenBySeller != null) {
      this._seenBySeller = seenBySeller;
    }
    if (status != null) {
      this._status = status;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (shopId != null) {
      this._shopId = shopId;
    }
    if (name != null) {
      this._name = name;
    }
    if (image != null) {
      this._image = image;
    }
    if (sellerInfo != null) {
      this._sellerInfo = sellerInfo;
    }

    if (shop != null) {
      this._shop = shop;
    }
  }

  int get id => _id;
  int get userId => _userId;
  int get sellerId => _sellerId;
  String get message => _message;
  int get sentByCustomer => _sentByCustomer;
  int get sentBySeller => _sentBySeller;
  int get seenByCustomer => _seenByCustomer;
  int get seenBySeller => _seenBySeller;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get shopId => _shopId;
  String get name => _name;
  String get image => _image;
  SellerInfo get sellerInfo => _sellerInfo;
  Shop get shop => _shop;


  ChatList.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _sellerId = json['seller_id'];
    _message = json['message'];
    _sentByCustomer = json['sent_by_customer'];
    _sentBySeller = json['sent_by_seller'];
    _seenByCustomer = json['seen_by_customer'];
    _seenBySeller = json['seen_by_seller'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _shopId = json['shop_id'];
    _name = json['name'];
    _image = json['image'];
    _sellerInfo = json['seller_info'] != null
        ? new SellerInfo.fromJson(json['seller_info'])
        : null;
    _shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['seller_id'] = this._sellerId;
    data['message'] = this._message;
    data['sent_by_customer'] = this._sentByCustomer;
    data['sent_by_seller'] = this._sentBySeller;
    data['seen_by_customer'] = this._seenByCustomer;
    data['seen_by_seller'] = this._seenBySeller;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['shop_id'] = this._shopId;
    data['name'] = this._name;
    data['image'] = this._image;
    if (this._sellerInfo != null) {
      data['seller_info'] = this._sellerInfo.toJson();
    }

    if (this._shop != null) {
      data['shop'] = this._shop.toJson();
    }
    return data;
  }
}

class UniqueShops {
  int _id;
  int _userId;
  int _sellerId;
  String _message;
  int _sentByCustomer;
  int _sentBySeller;
  int _seenByCustomer;
  int _seenBySeller;
  int _status;
  String _createdAt;
  int _shopId;
  SellerInfo _sellerInfo;
  Shop _shop;

  UniqueShops(
      {int id,
        int userId,
        int sellerId,
        String message,
        int sentByCustomer,
        int sentBySeller,
        int seenByCustomer,
        int seenBySeller,
        int status,
        String createdAt,
        int shopId,
        SellerInfo sellerInfo,
        Shop shop}) {
    if (id != null) {
      this._id = id;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (sellerId != null) {
      this._sellerId = sellerId;
    }
    if (message != null) {
      this._message = message;
    }
    if (sentByCustomer != null) {
      this._sentByCustomer = sentByCustomer;
    }
    if (sentBySeller != null) {
      this._sentBySeller = sentBySeller;
    }
    if (seenByCustomer != null) {
      this._seenByCustomer = seenByCustomer;
    }
    if (seenBySeller != null) {
      this._seenBySeller = seenBySeller;
    }
    if (status != null) {
      this._status = status;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }

    if (shopId != null) {
      this._shopId = shopId;
    }
    if (sellerInfo != null) {
      this._sellerInfo = sellerInfo;
    }
    if (shop != null) {
      this._shop = shop;
    }
  }

  int get id => _id;
  int get userId => _userId;
  int get sellerId => _sellerId;
  String get message => _message;
  int get sentByCustomer => _sentByCustomer;
  int get sentBySeller => _sentBySeller;
  int get seenByCustomer => _seenByCustomer;
  int get seenBySeller => _seenBySeller;
  int get status => _status;
  String get createdAt => _createdAt;
  int get shopId => _shopId;
  SellerInfo get sellerInfo => _sellerInfo;
  Shop get shop => _shop;


  UniqueShops.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _sellerId = json['seller_id'];
    _message = json['message'];
    _sentByCustomer = json['sent_by_customer'];
    _sentBySeller = json['sent_by_seller'];
    _seenByCustomer = json['seen_by_customer'];
    _seenBySeller = json['seen_by_seller'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _shopId = json['shop_id'];
    _sellerInfo = json['seller_info'] != null
        ? new SellerInfo.fromJson(json['seller_info'])
        : null;
    _shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['seller_id'] = this._sellerId;
    data['message'] = this._message;
    data['sent_by_customer'] = this._sentByCustomer;
    data['sent_by_seller'] = this._sentBySeller;
    data['seen_by_customer'] = this._seenByCustomer;
    data['seen_by_seller'] = this._seenBySeller;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['shop_id'] = this._shopId;
    if (this._sellerInfo != null) {
      data['seller_info'] = this._sellerInfo.toJson();
    }
    if (this._shop != null) {
      data['shop'] = this._shop.toJson();
    }
    return data;
  }
}

