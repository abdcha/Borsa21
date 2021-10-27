class PostGet {
  late List<Posts> posts;
  late int total;

  PostGet({required this.posts, required this.total});

  PostGet.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts.add(new Posts.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posts'] = this.posts.map((v) => v.toJson()).toList();
    data['total'] = this.total;
    return data;
  }

  toList() {}
}

class Posts {
  late int id;
  late String createdAt;
  late String updatedAt;
  late String image;
  late String body;
  late int userId;
  late int companyId;
  late int isFollowed;
  late Company company;
  late User user;

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    body = json['body'] == null ? "empty" : json['body'];
    userId = json['user_id'];
    companyId = json['company_id'];
    isFollowed = json['is_followed'];
    company = (json['company'] != null
        ? new Company.fromJson(json['company'])
        : null)!;
    user = (json['user'] != null ? new User.fromJson(json['user']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;

    data['body'] = this.body == null ? "empty" : this.body;
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    data['is_followed'] = this.isFollowed;
    data['company'] = this.company.toJson();
    data['user'] = this.user.toJson();
    return data;
  }
}

class User {
  late String name;
  late int id;
  late int cityId;
  late City city;
  late String phone;

  User(
      {required this.name,
      required this.id,
      required this.cityId,
      required this.city,
      required this.phone});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    cityId = json['city_id'];
    city = (json['city'] != null ? new City.fromJson(json['city']) : null)!;
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    data['city'] = this.city.toJson();
    data['phone'] = this.phone;

    return data;
  }
}

class Company {
  late String name;
  late int id;
  late String image;
  late String email;
  late String address;
  late String phone;

  Company({
    required this.name,
    required this.id,
    required this.image,
    required this.email,
    required this.address,
    required this.phone,
  });

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    image = json['image'];
    email = json['email'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['image'] = this.image;
    data['email'] = this.email;
    data['address'] = this.address;
    data['phone'] = this.phone;
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
