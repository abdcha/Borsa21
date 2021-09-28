class Currency {
  late Data data;

  Currency({required this.data});

  Currency.fromJson(Map<String, dynamic> json) {
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
  late List<CurrencyPrice> currencyPrice;

  Data({required this.currencyPrice});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['CurrencyPrice'] != null) {
      currencyPrice = <CurrencyPrice>[];
      json['CurrencyPrice'].forEach((v) {
        currencyPrice.add(new CurrencyPrice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.currencyPrice != null) {
      data['CurrencyPrice'] =
          this.currencyPrice.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencyPrice {
  late int id;
  late int buy;
  late int sell;
  late String sellStatus;
  late int createdBy;
  late int cityId;
  late String createdAt;
  late String updatedAt;
  late String buyStatus;
  late City city;

  CurrencyPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buy = json['buy'];
    sell = json['sell'];
    sellStatus = json['sell_status'];
    createdBy = json['created_by'];
    cityId = json['city_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    buyStatus = json['buy_status'];
    city = (json['city'] != null ? new City.fromJson(json['city']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buy'] = this.buy;
    data['sell'] = this.sell;
    data['sell_status'] = this.sellStatus;
    data['created_by'] = this.createdBy;
    data['city_id'] = this.cityId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['buy_status'] = this.buyStatus;
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
