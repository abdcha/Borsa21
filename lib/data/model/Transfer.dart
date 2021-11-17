class Transfers {
  late Data data;

  Transfers({required this.data});

  Transfers.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  late List<Transfer> transfer;

  Data({required this.transfer});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Transfer'] != null) {
      transfer = <Transfer>[];
      json['Transfer'].forEach((v) {
        transfer.add(new Transfer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transfer != null) {
      data['Transfer'] = this.transfer.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transfer {
  late int id;
  late double buy;
  late double sell;
  late String buyStatus;
  late String sellStatus;
  late int createdBy;
  late int firstCityId;
  late String createdAt;
  late String updatedAt;
  late int close;
  late int secondCityId;
  late FirstCity firstCity;
  late FirstCity secondCity;

  Transfer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buy = json['buy'].toDouble();
    sell = json['sell'].toDouble();
    buyStatus = json['buy_status'];
    sellStatus = json['sell_status'];
    createdBy = json['created_by'];
    firstCityId = json['first_city_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    close = json['close'];
    secondCityId = json['second_city_id'];

    firstCity = new FirstCity.fromJson(json['first_city']);

    secondCity = new FirstCity.fromJson(json['second_city']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buy'] = this.buy;
    data['sell'] = this.sell;
    data['buy_status'] = this.buyStatus;
    data['sell_status'] = this.sellStatus;
    data['created_by'] = this.createdBy;
    data['first_city_id'] = this.firstCityId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['close'] = this.close;
    data['second_city_id'] = this.secondCityId;
    data['first_city'] = this.firstCity.toJson();
    data['second_city'] = this.secondCity.toJson();
    return data;
  }
}

class FirstCity {
  late String name;
  late int id;

  FirstCity({required this.name, required this.id});

  FirstCity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
