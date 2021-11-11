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
  late int close;
  late int cityId;
  late String createdAt;
  late String updatedAt;
  late City city;

  Transfer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buy = json['buy'].toDouble();
    sell = json['sell'].toDouble();
    buyStatus = json['buy_status'];
    sellStatus = json['sell_status'];
    createdBy = json['created_by'];
    cityId = json['city_id'];
    close = json['close'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    city = (json['city'] != null ? new City.fromJson(json['city']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buy'] = this.buy;
    data['sell'] = this.sell;
    data['buy_status'] = this.buyStatus;
    data['sell_status'] = this.sellStatus;
    data['created_by'] = this.createdBy;
    data['city_id'] = this.cityId;
    data['close'] = this.close;

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    return data;
  }
}

class City {
  late String name;
  late int id;

  City({required this.name, required this.id});

  City.fromJson(Map<String, dynamic> json) {
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
