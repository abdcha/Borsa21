class Post {
  late Data data;

  Post({required this.data});

  Post.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late List<Posts> posts;
  late int total;

  Data({required this.posts, required this.total});

  Data.fromJson(Map<String, dynamic> json) {
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
}

class Posts {
  late int id;
  late String createdAt;
  late String updatedAt;
  late String? image;
  late String body;
  late int userId;
  late int companyId;

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    body = json['body'];
    userId = json['user_id'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['body'] = this.body;
    data['user_id'] = this.userId;
    data['company_id'] = this.companyId;
    return data;
  }
}
