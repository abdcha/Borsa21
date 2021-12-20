// class CompanyInfo {
//   late Data data;

//   CompanyInfo({required this.data});

//   CompanyInfo.fromJson(Map<String, dynamic> json) {
//     data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   late Company company;

//   Data({required this.company});

//   Data.fromJson(Map<String, dynamic> json) {
//     company = (json['company'] != null
//         ? new Company.fromJson(json['company'])
//         : null)!;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.company != null) {
//       data['company'] = this.company.toJson();
//     }
//     return data;
//   }
// }

// class Company {
//   late int id;
//   late String createdAt;
//   late String updatedAt;
//   late String name;
//   late String image;
//   late String phone;
//   late int cityId;
//   late String address;
//   late String email;

//   Company.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     name = json['name'];
//     image = json['image'];
//     phone = json['phone'];
//     cityId = json['city_id'];
//     address = json['address'];
//     email = json['email'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['name'] = this.name;
//     data['image'] = this.image;
//     data['phone'] = this.phone;
//     data['city_id'] = this.cityId;
//     data['address'] = this.address;
//     data['email'] = this.email;
//     return data;
//   }
// }
class CompanyInfo {
  late Data data;

  CompanyInfo({required this.data});

  CompanyInfo.fromJson(Map<String, dynamic> json) {
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
  late Company company;
  late bool isFollow;

  Data({required this.company, required this.isFollow});

  Data.fromJson(Map<String, dynamic> json) {
    company =
        (json['company'] != null ? new Company.fromJson(json['company']) : null)!;
    isFollow = json['is_follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    data['is_follow'] = this.isFollow;
    return data;
  }
}

class Company {
  late int id;
  late String createdAt;
  late String updatedAt;
  late String name;
  late String image;
  late String phone;
  late int cityId;
  late String address;
  late String email;
  late Null deletedAt;


  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    image = json['image'];
    phone = json['phone'];
    cityId = json['city_id'];
    address = json['address'];
    email = json['email'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['city_id'] = this.cityId;
    data['address'] = this.address;
    data['email'] = this.email;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}




