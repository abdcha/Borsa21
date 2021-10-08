class Chat {
  late Data data;

  Chat({required this.data});

  Chat.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late List<Message> message;
  late int total;

  Data({required this.message, required this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message.add(new Message.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message.map((v) => v.toJson()).toList();
    data['total'] = this.total;
    return data;
  }
}

class Message {
  late String createdAt;
  late String username;
  late String companyImage;
  late String message;
  late Null replayOn;

  Message.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    username = json['username'];
    companyImage = json['company_image'];
    message = json['message'];
    replayOn = json['replay_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['username'] = this.username;
    data['company_image'] = this.companyImage;
    data['message'] = this.message;
    data['replay_on'] = this.replayOn;
    return data;
  }
}
