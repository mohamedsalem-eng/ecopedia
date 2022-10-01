class AreaModel {
  int id;
  int cost;
  String name;

  AreaModel({this.id, this.cost, this.name});

  AreaModel.fromJson(Map<String, dynamic> json) {
    
    id= int.parse(json['id']);
    cost = json['cost'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cost'] = this.cost;

    return data;
  }
}
