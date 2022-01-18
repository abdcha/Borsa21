class AdvertisementAll {
  late Data data;

  AdvertisementAll({required this.data});

  AdvertisementAll.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late List<Advertisements> advertisements;

  Data({required this.advertisements});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['advertisements'] != null) {
      advertisements = <Advertisements>[];
      json['advertisements'].forEach((v) {
        advertisements.add(new Advertisements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['advertisements'] =
          this.advertisements.map((v) => v.toJson()).toList();
    return data;
  }
}

class Advertisements {
  late int id;
  late String createdAt;
  late String updatedAt;
  late String advertiser;
  late String image;

  Advertisements(
      {required this.id, required this.createdAt, required this.updatedAt, required this.advertiser, required this.image});

  Advertisements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    advertiser = json['advertiser'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['advertiser'] = this.advertiser;
    data['image'] = this.image;
    return data;
  }
}