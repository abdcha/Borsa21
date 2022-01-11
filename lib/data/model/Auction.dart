class Auction {
  late Data data;

  Auction({required this.data});

  Auction.fromJson(Map<String, dynamic> json) {
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
  late List<Auctions> auctions;

  Data({required this.auctions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['auctions'] != null) {
      auctions = <Auctions>[];
      json['auctions'].forEach((v) {
        auctions.add(new Auctions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.auctions != null) {
      data['auctions'] = this.auctions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Auctions {
  late int id;
  late String createdAt;
  late String updatedAt;
  late String endAt;
  late String filePath;
  late String value;

  Auctions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    endAt = json['end_subscription'];
    filePath = json['file_path'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['end_subscription'] = this.endAt;
    data['file_path'] = this.filePath;
    data['value'] = this.value;
    return data;
  }
}
